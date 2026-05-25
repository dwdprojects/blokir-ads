package com.dwd.blokirads

import android.content.Context
import android.util.Log
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Manager untuk dynamic blocklist yang didownload dari internet.
 * Source: Steven Black's Hosts (~100.000+ domain iklan, malware, tracking)
 * https://github.com/StevenBlack/hosts
 *
 * Format hosts file:
 *   0.0.0.0 example-ad.com
 *   0.0.0.0 tracker.net
 *   # ini komentar (diabaikan)
 */
class DynamicBlocklistManager(private val context: Context) {

    companion object {
        private const val TAG = "BlocklistManager"

        // Sumber blocklist dari komunitas (dipilih yang paling ringan & kompatibel)
        private val BLOCKLIST_SOURCES = listOf(
            // Hagezi Multi Pro (Ultimate DNS Blocklist - sangat komprehensif)
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/pro.txt",
            // Steven Black — Ads + Tracking (sekitar 100k+ domain)
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
            // AdGuard Mobile Filter — khusus mobile ads
            "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/adservers.txt",
            // Regional Asia / Vietnam / Indonesia (untuk melengkapi yang lolos)
            "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
        )

        // File cache lokal di storage internal aplikasi
        private const val CACHE_FILENAME = "dynamic_blocklist.txt"
        // Update setiap 7 hari sekali
        private const val UPDATE_INTERVAL_MS = 7L * 24 * 60 * 60 * 1000
    }

    // Domain yang sudah di-load ke memory (HashSet untuk O(1) lookup)
    private var dynamicDomains: Set<String> = emptySet()
    val isLoaded = AtomicBoolean(false)
    var domainCount = 0
        private set

    // ────────────────────────────────────────────────────────────────────────
    // Public API
    // ────────────────────────────────────────────────────────────────────────

    /**
     * Load blocklist: dari cache jika masih fresh, atau download baru.
     * Dipanggil di background thread.
     */
    fun loadBlocklist(onProgress: ((String) -> Unit)? = null) {
        try {
            val cacheFile = File(context.filesDir, CACHE_FILENAME)

            if (isCacheFresh(cacheFile)) {
                onProgress?.invoke("Memuat blocklist dari cache...")
                Log.d(TAG, "Loading blocklist from cache: ${cacheFile.path}")
                parseCacheFile(cacheFile)
            } else {
                onProgress?.invoke("Mengunduh blocklist terbaru...")
                Log.d(TAG, "Cache expired or missing, downloading...")
                downloadAndCache(cacheFile, onProgress)
                parseCacheFile(cacheFile)
            }

            isLoaded.set(true)
            Log.i(TAG, "Blocklist loaded: $domainCount domains")
            onProgress?.invoke("Blocklist siap: $domainCount domain diblokir")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load dynamic blocklist: ${e.message}", e)
            // Fallback: kosong, akan pakai static list dari BlokirVpnService
            isLoaded.set(true)
        }
    }

    /**
     * Cek apakah domain ada di dynamic blocklist.
     */
    fun isDomainBlocked(domain: String): Boolean {
        if (!isLoaded.get() || dynamicDomains.isEmpty()) return false
        val lower = domain.lowercase().trimEnd('.')
        if (dynamicDomains.contains(lower)) return true
        // Cek subdomain
        var idx = lower.indexOf('.')
        while (idx != -1) {
            val parent = lower.substring(idx + 1)
            if (dynamicDomains.contains(parent)) return true
            idx = lower.indexOf('.', idx + 1)
        }
        return false
    }

    /**
     * Paksa update blocklist (download ulang meski cache masih fresh).
     */
    fun forceUpdate(onProgress: ((String) -> Unit)? = null) {
        val cacheFile = File(context.filesDir, CACHE_FILENAME)
        cacheFile.delete()
        isLoaded.set(false)
        dynamicDomains = emptySet()
        loadBlocklist(onProgress)
    }

    // ────────────────────────────────────────────────────────────────────────
    // Download & Cache
    // ────────────────────────────────────────────────────────────────────────

    private fun isCacheFresh(file: File): Boolean {
        if (!file.exists() || file.length() < 1000) return false
        val age = System.currentTimeMillis() - file.lastModified()
        return age < UPDATE_INTERVAL_MS
    }

    private fun downloadAndCache(
        cacheFile: File,
        onProgress: ((String) -> Unit)? = null
    ) {
        var success = false

        for ((index, sourceUrl) in BLOCKLIST_SOURCES.withIndex()) {
            try {
                onProgress?.invoke("Mengunduh dari sumber ${index + 1}/${BLOCKLIST_SOURCES.size}...")
                Log.d(TAG, "Trying source: $sourceUrl")

                val connection = URL(sourceUrl).openConnection() as HttpURLConnection
                connection.apply {
                    connectTimeout = 15000
                    readTimeout = 30000
                    setRequestProperty("User-Agent", "BlokirAds/1.0 Android")
                }

                if (connection.responseCode == 200) {
                    val temp = File(context.filesDir, "blocklist_tmp.txt")
                    temp.bufferedWriter().use { writer ->
                        BufferedReader(InputStreamReader(connection.inputStream)).use { reader ->
                            var lineCount = 0
                            reader.forEachLine { line ->
                                writer.write(line)
                                writer.newLine()
                                lineCount++
                                if (lineCount % 10000 == 0) {
                                    onProgress?.invoke("Mengunduh... $lineCount baris")
                                }
                            }
                        }
                    }
                    connection.disconnect()

                    // Pindahkan file temp ke cache final
                    temp.renameTo(cacheFile)
                    Log.i(TAG, "Downloaded successfully from $sourceUrl")
                    success = true
                    break
                } else {
                    connection.disconnect()
                    Log.w(TAG, "HTTP ${connection.responseCode} from $sourceUrl")
                }
            } catch (e: Exception) {
                Log.w(TAG, "Failed to download from $sourceUrl: ${e.message}")
            }
        }

        if (!success) {
            Log.e(TAG, "All sources failed. Using fallback.")
        }
    }

    // ────────────────────────────────────────────────────────────────────────
    // Parse
    // ────────────────────────────────────────────────────────────────────────

    private fun parseCacheFile(file: File) {
        if (!file.exists()) return

        val domains = HashSet<String>(150_000)

        file.bufferedReader().use { reader ->
            reader.forEachLine { rawLine ->
                val line = rawLine.trim()
                // Skip komentar dan baris kosong
                if (line.isEmpty() || line.startsWith('#') || line.startsWith('!')) return@forEachLine

                when {
                    // Format hosts file: "0.0.0.0 domain.com" atau "127.0.0.1 domain.com"
                    line.startsWith("0.0.0.0 ") || line.startsWith("127.0.0.1 ") -> {
                        val parts = line.split("\\s+".toRegex())
                        if (parts.size >= 2) {
                            val domain = parts[1].lowercase().trim()
                            if (isValidDomain(domain)) domains.add(domain)
                        }
                    }
                    // Format AdGuard: "||domain.com^"
                    line.startsWith("||") && line.endsWith("^") -> {
                        val domain = line.removePrefix("||").removeSuffix("^").lowercase()
                        if (isValidDomain(domain)) domains.add(domain)
                    }
                    // Format plain domain list (satu domain per baris)
                    !line.contains(' ') && !line.startsWith('[') -> {
                        val domain = line.lowercase().trimEnd('.')
                        if (isValidDomain(domain)) domains.add(domain)
                    }
                }
            }
        }

        dynamicDomains = domains
        domainCount = domains.size
        Log.d(TAG, "Parsed ${domains.size} domains from ${file.name}")
    }

    private fun isValidDomain(domain: String): Boolean {
        if (domain.isEmpty() || domain.length > 253) return false
        if (domain == "localhost" || domain == "broadcasthost") return false
        if (!domain.contains('.')) return false
        if (domain.startsWith('.') || domain.endsWith('.')) return false
        return domain.all { it.isLetterOrDigit() || it == '.' || it == '-' || it == '_' }
    }
}
