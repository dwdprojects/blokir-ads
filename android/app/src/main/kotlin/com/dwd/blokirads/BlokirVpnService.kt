package com.dwd.blokirads

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.InetAddress
import java.nio.ByteBuffer
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger

class BlokirVpnService : VpnService() {

    companion object {
        private const val TAG = "BlokirVpnService"
        private const val CHANNEL_ID = "blokir_ads_vpn"
        private const val NOTIFICATION_ID = 1
        const val ACTION_START = "ACTION_START_VPN"
        const val ACTION_STOP = "ACTION_STOP_VPN"
        const val EXTRA_TARGET_PACKAGES = "target_packages"

        // Shared state — diakses dari MainActivity
        val isRunning = AtomicBoolean(false)
        val blockedCount = AtomicInteger(0)

        // Static reference ke manager untuk akses dari MainActivity
        private var sharedManager: DynamicBlocklistManager? = null
        private var sharedCustomManager: CustomBlocklistManager? = null

        val blocklistDomainCount: Int
            get() = sharedManager?.domainCount ?: 0

        val isDynamicLoaded: Boolean
            get() = sharedManager?.isLoaded?.get() ?: false

        fun forceUpdateBlocklist(context: Context, onProgress: ((String) -> Unit)? = null) {
            val manager = sharedManager
                ?: DynamicBlocklistManager(context.applicationContext).also { sharedManager = it }
            manager.forceUpdate(onProgress)
        }

        fun addCustomDomain(context: Context, domain: String) {
            val manager = sharedCustomManager
                ?: CustomBlocklistManager(context.applicationContext).also { sharedCustomManager = it }
            manager.addDomain(domain)
        }

        fun removeCustomDomain(context: Context, domain: String) {
            val manager = sharedCustomManager
                ?: CustomBlocklistManager(context.applicationContext).also { sharedCustomManager = it }
            manager.removeDomain(domain)
        }

        fun addCustomWhitelist(context: Context, domain: String) {
            val manager = sharedCustomManager
                ?: CustomBlocklistManager(context.applicationContext).also { sharedCustomManager = it }
            manager.addWhitelist(domain)
        }

        // ─────────────────────────────────────────────────────────────────────
        // WHITELIST — Domain yang TIDAK BOLEH diblokir sama sekali.
        // Melindungi sistem reward, poin, klaim hadiah, dan fungsi inti app.
        // Diutamakan di atas semua blocklist (static, dynamic, custom).
        // ─────────────────────────────────────────────────────────────────────
        val whitelistedDomains: Set<String> = setOf(
            // ── Sistem Reward & Klaim Poin (Reward Apps) ──
            // AppsFlyer — platform attribution untuk reward & poin (bukan hanya iklan)
            "appsflyer.com", "onelink.me",
            // Adjust — dipakai reward apps untuk verifikasi tonton konten & poin
            "adjust.com", "adj.st", "adjustapi.com", "adjust.net.in",
            // Branch — deep-link untuk klaim reward & referral
            "branch.io", "app.link", "bnc.lt",
            // Kochava & Singular — attribution reward install
            "kochava.com", "singular.net",
            // AppLovin, Pangle, Unity, Vungle, Liftoff (Hanya API verifikasi/events, bukan CDN video)
            "api16-access-wf-my.pangle.io", "api16-dual-event-sg2.pangle.io", "api16-access-ttp.tiktokpangle.us", "mediation-sg2-log.pangle.io",
            "ms.applovin.com", "ms4.applovin.com", "rt.applovin.com", "sts.applovin.com", "d.applovin.com", "prod-mediate-events.applovin.com",
            "ms.applvn.com", "d.applvn.com", "ms4.applvn.com",
            "gateway.unityads.unity3d.com",
            "events.ads.vungle.com", "logs.ads.vungle.com",
            "click.liftoff.io", "adexp.liftoff.io", "impression-east.liftoff.io",
            "googleads.g.doubleclick.net", // Eksperimen: biarkan API AdMob lewat, tapi biarkan CDN video terblokir

            // ── Firebase & Google Core (Login, Notifikasi, Analitik Aplikasi) ──
            "firebase.googleapis.com", "firebaseinstallations.googleapis.com",
            "firebaseio.com", "fcm.googleapis.com", "fcm-xmpp.googleapis.com",
            "play.googleapis.com", "googleapis.com",
            "accounts.google.com", "www.googleapis.com",
            "crashlytics.com", "firebaselogging.googleapis.com",

            // ── App Store & Update ──
            "dl.google.com", "android.clients.google.com",
            "connectivitycheck.gstatic.com", "gstatic.com",

            // ── CDN & Streaming Konten (Video, Gambar, Audio) ──
            // Cloudflare
            "cloudflare.com", "cloudflare-dns.com", "cdn.cloudflare.com",
            // Akamai — CDN video streaming populer
            "akamaihd.net", "akamaized.net", "akamaistream.net", "edgekey.net",
            // Fastly CDN
            "fastly.net", "fastlylb.net",
            // AWS (banyak apps pakai S3/CloudFront untuk host konten)
            "amazonaws.com", "cloudfront.net",
            // Azure
            "azureedge.net", "azure.com",

            // ── Platform Streaming & Konten Legal ──
            // YouTube (konten + reward watch-time)
            "youtube.com", "youtu.be", "ytimg.com", "googlevideo.com", "yt3.ggpht.com",
            // TikTok (konten)
            "tiktok.com", "tiktokcdn.com", "musical.ly",
            // Instagram & Facebook konten
            "instagram.com", "cdninstagram.com", "facebook.com", "fbcdn.net",
            // Twitter/X
            "twitter.com", "x.com", "twimg.com",

            // ── Payment & Monetisasi Resmi ──
            "paypal.com", "stripe.com", "braintreegateway.com",
            "xendit.co", "midtrans.com", "doku.com", "ovo.id",
            "gopay.co.id", "dana.id", "shopeepay.co.id",

            // ── Security & Certificate ──
            "letsencrypt.org", "ocsp.digicert.com", "ocsp.comodoca.com",
            "crl.globalsign.com", "ocsp.globalsign.com",

            // ── DNS Standar (Jangan Diblokir) ──
            "dns.google", "cloudflare-dns.com", "dns.quad9.net"
        )

        // Daftar domain iklan yang diblokir (DNS null-routing ke 0.0.0.0)
        val blockedDomains = setOf(
            // Google AdMob & Play Install Ads
            "admob.com", "googleadservices.com", "googlesyndication.com",
            "doubleclick.net", "googleads.g.doubleclick.net",
            "pagead2.googlesyndication.com", "ad.doubleclick.net",
            "adservice.google.com", "ads.google.com", "tpc.googlesyndication.com",
            "googleoptimize.com", "google-analytics.com", "analytics.google.com",
            "fundingchoicesmessages.google.com", "adsense.googlesyndication.com",
            // Meta / Facebook
            "an.facebook.com", "connect.facebook.net", "fbsbx.com",
            // Unity Ads
            "unityads.unity3d.com", "auction.unityads.unity3d.com",
            "config.unityads.unity3d.com", "publisher-event.unityads.unity3d.com",
            "unity3d.com",
            // AppLovin
            "applovin.com", "rtb.applovin.com", "d.applovin.com",
            "ads.applovin.com", "ms.applovin.com", "img.applovin.com",
            // Chartboost
            "chartboost.com", "live.chartboost.com", "a.chartboost.com",
            // Vungle / Liftoff
            "vungle.com", "ads.vungle.com", "cdn-lb.vungle.com", "liftoff.io",
            // IronSource / Unity Level Play
            "ironsrc.com", "supersonic.com", "ads.supersonic.com",
            "outcome-ssp.supersonicads.com", "level-play-cdn.com",
            // InMobi
            "inmobi.com", "w.inmobi.com", "c.inmobi.com",
            // Adcolony / Digital Turbine
            "adcolony.com", "events.adcolony.com", "ads30.adcolony.com",
            "digitalturbine.com", "fyber.com",
            // Tapjoy
            "tapjoy.com", "ltv.tapjoy.com",
            // StartApp
            "startapp.com", "startapps.com",
            // Amazon Ads
            "aax.amazon-adsystem.com", "amazon-adsystem.com",
            // Snap Ads
            "snapads.com", "tr.snapchat.com",
            // TikTok / Pangle Ads
            "ads.tiktok.com", "business.tiktok.com", "pangle.io", "pangleglobal.com",
            // Mintegral / Mindworks
            "mintegral.com", "mktkts.com", "mrdatadog.com",
            // tlivesdk (terlihat di logcat)
            "tlivesdk.com", "mlvbdc.tlivesdk.com",
            // Branch (install ads redirect)
            "branch.io", "app.link", "bnc.lt",
            // Adjust (tracking & attribution)
            "adjust.com", "adjust.net.in", "adjustapi.com",
            // AppsFlyer
            "appsflyer.com", "onelink.me",
            // Kochava & Singular
            "kochava.com", "control.kochava.com", "singular.net", "s.singular.net",
            // General Ad Networks
            "mopub.com", "ads.mopub.com", "media.net", "openx.net",
            "rubiconproject.com", "pubmatic.com", "criteo.com",
            "adsrvr.org", "moatads.com", "scorecardresearch.com",
            "outbrain.com", "taboola.com", "smaato.net", "smaato.com",
            "bidmachine.io", "smartadserver.com"
        )
    }

    private var vpnInterface: ParcelFileDescriptor? = null
    private var targetPackages: List<String> = emptyList()
    private var vpnThread: Thread? = null
    private val shouldRun = AtomicBoolean(false)

    // Dynamic blocklist (didownload otomatis dari internet)
    private lateinit var blocklistManager: DynamicBlocklistManager
    
    // Custom blocklist (dibuat oleh user)
    private lateinit var customBlocklistManager: CustomBlocklistManager

    // ────────────────────────────────────────────────────────────
    // Lifecycle
    // ────────────────────────────────────────────────────────────

    override fun onCreate() {
        super.onCreate()
        blocklistManager = DynamicBlocklistManager(applicationContext)
        sharedManager = blocklistManager // Expose ke companion object
        
        customBlocklistManager = CustomBlocklistManager(applicationContext)
        sharedCustomManager = customBlocklistManager // Expose ke companion object
        
        // Load blocklist di background saat service pertama kali dibuat
        Thread({
            Log.d(TAG, "Loading dynamic blocklist...")
            blocklistManager.loadBlocklist { progress ->
                Log.d(TAG, "Blocklist: $progress")
            }
        }, "BlocklistLoaderThread").also {
            it.isDaemon = true
            it.start()
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> {
                stopVpn()
                return START_NOT_STICKY
            }
            ACTION_START -> {
                targetPackages = intent.getStringArrayListExtra(EXTRA_TARGET_PACKAGES)
                    ?.toList() ?: emptyList()
                startVpn()
            }
        }
        return START_STICKY
    }

    override fun onRevoke() {
        Log.w(TAG, "VPN revoked by system")
        stopVpn()
        super.onRevoke()
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }

    // ────────────────────────────────────────────────────────────
    // VPN Start / Stop
    // ────────────────────────────────────────────────────────────

    private fun startVpn() {
        if (isRunning.get()) {
            Log.d(TAG, "VPN already running, restarting...")
            stopVpn()
        }

        try {
            val builder = Builder()
                .setSession("Blokir Ads VPN")
                // IP lokal untuk VPN interface kita
                .addAddress("10.0.0.2", 32)
                // Set DNS server virtual yang akan dituju oleh target app
                .addDnsServer("10.0.0.3")
                // SPLIT-TUNNELING: HANYA route traffic yang menuju ke DNS server (10.0.0.3)
                // Traffic lain (TCP/HTTPS/Video/Gambar) akan lewat WiFi/Seluler normal
                .addRoute("10.0.0.3", 32)
                .setMtu(1500)

            // Per-app targeting: hanya traffic dari app yang dipilih
            // yang melewati VPN tunnel kita
            if (targetPackages.isNotEmpty()) {
                for (pkg in targetPackages) {
                    try {
                        builder.addAllowedApplication(pkg)
                        Log.d(TAG, "Added allowed app: $pkg")
                    } catch (e: Exception) {
                        Log.w(TAG, "Package not found: $pkg")
                    }
                }
                // Selalu allow apps kita sendiri agar tidak self-block
                try {
                    builder.addAllowedApplication(packageName)
                } catch (e: Exception) { /* ignore */ }
            }

            vpnInterface = builder.establish()

            if (vpnInterface == null) {
                Log.e(TAG, "Failed to establish VPN interface")
                return
            }

            isRunning.set(true)
            blockedCount.set(0)
            shouldRun.set(true)
            
            sendStatusToFlutter(true)

            startForeground(NOTIFICATION_ID, buildNotification())

            // Start packet processing thread
            vpnThread = Thread({ processPackets() }, "VpnPacketThread").also {
                it.isDaemon = true
                it.start()
            }

            Log.i(TAG, "VPN started for packages: $targetPackages")
        } catch (e: Exception) {
            Log.e(TAG, "Error starting VPN: ${e.message}", e)
            isRunning.set(false)
        }
    }

    private fun stopVpn() {
        shouldRun.set(false)
        isRunning.set(false)
        
        sendStatusToFlutter(false)

        vpnThread?.interrupt()
        vpnThread = null

        try {
            vpnInterface?.close()
        } catch (e: Exception) {
            Log.w(TAG, "Error closing VPN interface: ${e.message}")
        }
        vpnInterface = null

        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()

        Log.i(TAG, "VPN stopped. Total blocked: ${blockedCount.get()}")
    }

    // ────────────────────────────────────────────────────────────
    // Packet Processing (DNS Intercept)
    // ────────────────────────────────────────────────────────────

    private fun processPackets() {
        val pfd = vpnInterface ?: return
        val inputStream = FileInputStream(pfd.fileDescriptor)
        val outputStream = FileOutputStream(pfd.fileDescriptor)
        val packet = ByteArray(32767)
        val buffer = ByteBuffer.allocate(32767)

        Log.d(TAG, "Packet processing started")

        while (shouldRun.get()) {
            try {
                buffer.clear()
                val length = inputStream.read(packet)
                if (length <= 0) continue

                buffer.put(packet, 0, length)
                buffer.flip()

                // Parse IP header untuk cek apakah ini DNS query (UDP port 53)
                if (length < 20) continue // IP header minimum 20 bytes

                val ipVersion = (packet[0].toInt() and 0xFF) shr 4
                if (ipVersion != 4) continue

                val protocol = packet[9].toInt() and 0xFF
                if (protocol != 17) continue // 17 = UDP

                // UDP: cek destination port 53 (DNS)
                val ipHeaderLen = (packet[0].toInt() and 0x0F) * 4
                if (length < ipHeaderLen + 8) continue

                val destPort = ((packet[ipHeaderLen + 2].toInt() and 0xFF) shl 8) or
                        (packet[ipHeaderLen + 3].toInt() and 0xFF)

                if (destPort != 53) continue // Bukan DNS

                // Ini DNS query — parse dan cek apakah domain di-block
                val dnsOffset = ipHeaderLen + 8
                if (length <= dnsOffset + 12) continue

                val domain = parseDnsQuery(packet, dnsOffset + 12, length)
                Log.v(TAG, "DNS query: $domain")
                if (domain != null) {
                    sendLogToFlutter("DNS query: $domain")
                }

                if (domain != null && isDomainBlocked(domain)) {
                    Log.d(TAG, "BLOCKED: $domain")
                    sendLogToFlutter("BLOCKED: $domain")
                    blockedCount.incrementAndGet()
                    updateNotification()

                    // Kirim DNS response dengan IP 0.0.0.0 (null-route)
                    val blockedResponse = buildBlockedDnsResponse(packet, length, ipHeaderLen)
                    if (blockedResponse != null) {
                        outputStream.write(blockedResponse)
                    }
                } else {
                    // Domain aman, forward ke DNS server asli
                    forwardDnsQuery(packet, length, ipHeaderLen, outputStream)
                }
            } catch (e: InterruptedException) {
                Log.d(TAG, "Packet processing interrupted")
                break
            } catch (e: Exception) {
                if (shouldRun.get()) {
                    Log.w(TAG, "Packet processing error: ${e.message}")
                }
            }
        }

        Log.d(TAG, "Packet processing stopped")
    }

    private fun isDomainBlocked(domain: String): Boolean {
        val lower = domain.lowercase().trimEnd('.')

        // 0. CUSTOM WHITELIST DIUTAMAKAN — User overrides
        if (customBlocklistManager.isDomainWhitelisted(lower)) {
            Log.v(TAG, "CUSTOM WHITELISTED (allowed): $lower")
            return false
        }

        // 0.1 WHITELIST HARDCODED — Domain reward, poin, CDN, dan fungsi inti
        //    tidak boleh diblokir apapun yang terjadi.
        if (isWhitelisted(lower)) {
            Log.v(TAG, "WHITELISTED (allowed): $lower")
            return false
        }

        // 1. Cek custom blocklist buatan user (Prioritas Tertinggi setelah whitelist)
        if (customBlocklistManager.isDomainBlocked(lower)) {
            return true
        }

        // 2. Cek dynamic blocklist (100k+ domain dari community)
        if (blocklistManager.isLoaded.get() && blocklistManager.isDomainBlocked(lower)) {
            return true
        }

        // 3. Fallback ke static blocklist (selalu tersedia meski offline)
        if (blockedDomains.contains(lower)) return true
        return blockedDomains.any { blocked ->
            lower == blocked || lower.endsWith(".$blocked")
        }
    }

    /**
     * Cek apakah domain atau parent domain-nya ada di whitelist.
     * Contoh: "cdn.appsflyer.com" → parent "appsflyer.com" → WHITELISTED ✓
     */
    private fun isWhitelisted(domain: String): Boolean {
        if (whitelistedDomains.contains(domain)) return true
        // Cek parent domain secara rekursif
        var idx = domain.indexOf('.')
        while (idx != -1) {
            val parent = domain.substring(idx + 1)
            if (whitelistedDomains.contains(parent)) return true
            idx = domain.indexOf('.', idx + 1)
        }
        return false
    }

    // ────────────────────────────────────────────────────────────
    // DNS Parsing
    // ────────────────────────────────────────────────────────────

    private fun parseDnsQuery(packet: ByteArray, offset: Int, length: Int): String? {
        return try {
            val sb = StringBuilder()
            var pos = offset
            while (pos < length) {
                val labelLen = packet[pos].toInt() and 0xFF
                if (labelLen == 0) break
                if (labelLen > 63 || pos + labelLen + 1 > length) return null
                if (sb.isNotEmpty()) sb.append('.')
                sb.append(String(packet, pos + 1, labelLen, Charsets.US_ASCII))
                pos += labelLen + 1
            }
            sb.toString().ifEmpty { null }
        } catch (e: Exception) {
            null
        }
    }

    // ────────────────────────────────────────────────────────────
    // DNS Response Builder (null-route → 0.0.0.0)
    // ────────────────────────────────────────────────────────────

    private fun buildBlockedDnsResponse(
        originalPacket: ByteArray,
        length: Int,
        ipHeaderLen: Int
    ): ByteArray? {
        return try {
            val dnsOffset = ipHeaderLen + 8
            val dnsLength = length - dnsOffset
            if (dnsLength < 12) return null

            // Build DNS response payload
            val dnsResponse = ByteArray(dnsLength + 16)
            System.arraycopy(originalPacket, dnsOffset, dnsResponse, 0, dnsLength)

            // Set QR=1 (response), Opcode=0, AA=1, TC=0, RD=1, RA=1, RCODE=0
            dnsResponse[2] = 0x81.toByte()
            dnsResponse[3] = 0x80.toByte()
            // ANCOUNT = 1
            dnsResponse[6] = 0x00
            dnsResponse[7] = 0x01

            // Append Answer section: pointer to question name
            val answerStart = dnsLength
            // Name pointer: 0xC00C → points to offset 12 in DNS message (question name)
            dnsResponse[answerStart] = 0xC0.toByte()
            dnsResponse[answerStart + 1] = 0x0C.toByte()
            // Type A (0x0001)
            dnsResponse[answerStart + 2] = 0x00
            dnsResponse[answerStart + 3] = 0x01
            // Class IN (0x0001)
            dnsResponse[answerStart + 4] = 0x00
            dnsResponse[answerStart + 5] = 0x01
            // TTL = 60 seconds
            dnsResponse[answerStart + 6] = 0x00
            dnsResponse[answerStart + 7] = 0x00
            dnsResponse[answerStart + 8] = 0x00
            dnsResponse[answerStart + 9] = 0x3C
            // RDLENGTH = 4 (IPv4)
            dnsResponse[answerStart + 10] = 0x00
            dnsResponse[answerStart + 11] = 0x04
            // RDATA = 0.0.0.0
            dnsResponse[answerStart + 12] = 0x00
            dnsResponse[answerStart + 13] = 0x00
            dnsResponse[answerStart + 14] = 0x00
            dnsResponse[answerStart + 15] = 0x00

            val totalDnsLen = dnsLength + 16

            // Rebuild full IP + UDP packet (swap src/dst)
            buildIpUdpPacket(originalPacket, ipHeaderLen, dnsResponse, totalDnsLen, swapSrcDst = true)
        } catch (e: Exception) {
            Log.w(TAG, "Error building blocked DNS response: ${e.message}")
            null
        }
    }

    // ────────────────────────────────────────────────────────────
    // DNS Forward (untuk domain yang tidak diblokir)
    // ────────────────────────────────────────────────────────────

    private fun forwardDnsQuery(
        packet: ByteArray,
        length: Int,
        ipHeaderLen: Int,
        outputStream: FileOutputStream
    ) {
        try {
            val dnsOffset = ipHeaderLen + 8
            val dnsLength = length - dnsOffset
            if (dnsLength < 12) return

            val dnsPayload = packet.copyOfRange(dnsOffset, dnsOffset + dnsLength)

            // Forward ke Google DNS 8.8.8.8 secara real
            val socket = DatagramSocket()
            protect(socket) // Penting! Agar DNS query kita sendiri tidak melewati VPN lagi

            val dnsAddress = InetAddress.getByName("8.8.8.8")
            val sendPacket = DatagramPacket(dnsPayload, dnsPayload.size, dnsAddress, 53)
            socket.soTimeout = 3000
            socket.send(sendPacket)

            val responseBuffer = ByteArray(4096)
            val responsePacket = DatagramPacket(responseBuffer, responseBuffer.size)
            socket.receive(responsePacket)
            socket.close()

            val responseData = responsePacket.data.copyOf(responsePacket.length)

            // Rebuild IP+UDP dengan response DNS
            val fullResponse = buildIpUdpPacket(
                originalPacket = packet,
                ipHeaderLen = ipHeaderLen,
                payload = responseData,
                payloadLen = responseData.size,
                swapSrcDst = true
            )
            if (fullResponse != null) {
                outputStream.write(fullResponse)
            }
        } catch (e: Exception) {
            // Timeout atau error jaringan — biarkan saja
            Log.v(TAG, "DNS forward failed: ${e.message}")
        }
    }

    private fun sendLogToFlutter(logMessage: String) {
        val sink = MainActivity.logEventSink ?: return
        android.os.Handler(android.os.Looper.getMainLooper()).post {
            try {
                sink.success(logMessage)
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    private fun sendStatusToFlutter(isActive: Boolean) {
        val sink = MainActivity.statusEventSink ?: return
        android.os.Handler(android.os.Looper.getMainLooper()).post {
            try {
                sink.success(isActive)
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    // ────────────────────────────────────────────────────────────
    // IP + UDP Packet Builder
    // ────────────────────────────────────────────────────────────

    private fun buildIpUdpPacket(
        originalPacket: ByteArray,
        ipHeaderLen: Int,
        payload: ByteArray,
        payloadLen: Int,
        swapSrcDst: Boolean
    ): ByteArray? {
        return try {
            val totalLen = ipHeaderLen + 8 + payloadLen
            val result = ByteArray(totalLen)

            // Copy IP header dari original
            System.arraycopy(originalPacket, 0, result, 0, ipHeaderLen)

            // Update total length
            result[2] = (totalLen shr 8).toByte()
            result[3] = (totalLen and 0xFF).toByte()

            if (swapSrcDst) {
                // Swap source dan destination IP
                System.arraycopy(originalPacket, 12, result, 16, 4) // src → dst
                System.arraycopy(originalPacket, 16, result, 12, 4) // dst → src
            }

            // Recalculate IP checksum
            result[10] = 0
            result[11] = 0
            val ipChecksum = calculateChecksum(result, 0, ipHeaderLen)
            result[10] = (ipChecksum shr 8).toByte()
            result[11] = (ipChecksum and 0xFF).toByte()

            // UDP header
            val udpOffset = ipHeaderLen
            if (swapSrcDst) {
                // Swap src/dst port
                result[udpOffset] = originalPacket[ipHeaderLen + 2]
                result[udpOffset + 1] = originalPacket[ipHeaderLen + 3]
                result[udpOffset + 2] = originalPacket[ipHeaderLen]
                result[udpOffset + 3] = originalPacket[ipHeaderLen + 1]
            } else {
                System.arraycopy(originalPacket, ipHeaderLen, result, udpOffset, 4)
            }

            // UDP length
            val udpLen = 8 + payloadLen
            result[udpOffset + 4] = (udpLen shr 8).toByte()
            result[udpOffset + 5] = (udpLen and 0xFF).toByte()
            // UDP checksum = 0 (optional untuk UDP)
            result[udpOffset + 6] = 0
            result[udpOffset + 7] = 0

            // DNS payload
            System.arraycopy(payload, 0, result, ipHeaderLen + 8, payloadLen)

            result
        } catch (e: Exception) {
            null
        }
    }

    private fun calculateChecksum(data: ByteArray, offset: Int, length: Int): Int {
        var sum = 0
        var i = offset
        while (i < offset + length - 1) {
            sum += ((data[i].toInt() and 0xFF) shl 8) or (data[i + 1].toInt() and 0xFF)
            i += 2
        }
        if ((length and 1) != 0) {
            sum += (data[offset + length - 1].toInt() and 0xFF) shl 8
        }
        while (sum shr 16 != 0) {
            sum = (sum and 0xFFFF) + (sum shr 16)
        }
        return sum.inv() and 0xFFFF
    }

    // ────────────────────────────────────────────────────────────
    // Foreground Notification
    // ────────────────────────────────────────────────────────────

    private fun buildNotification(): Notification {
        createNotificationChannel()

        val stopIntent = Intent(this, BlokirVpnService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 0, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val openIntent = Intent(this, MainActivity::class.java)
        val openPendingIntent = PendingIntent.getActivity(
            this, 0, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Blokir Ads — Aktif")
            .setContentText("Memblokir iklan · ${blockedCount.get()} diblokir")
            .setSmallIcon(android.R.drawable.ic_menu_close_clear_cancel)
            .setOngoing(true)
            .setContentIntent(openPendingIntent)
            .addAction(
                Notification.Action.Builder(
                    null, "Matikan",
                    stopPendingIntent
                ).build()
            )
            .build()
    }

    private fun updateNotification() {
        val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(NOTIFICATION_ID, buildNotification())
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Blokir Ads VPN",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Status pemblokiran iklan aktif"
            setShowBadge(false)
        }
        val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        nm.createNotificationChannel(channel)
    }
}
