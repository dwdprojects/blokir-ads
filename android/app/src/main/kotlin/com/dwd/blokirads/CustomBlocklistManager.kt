package com.dwd.blokirads

import android.content.Context
import android.content.SharedPreferences

class CustomBlocklistManager(context: Context) {

    private val prefs: SharedPreferences = context.getSharedPreferences("CustomBlocklistPrefs", Context.MODE_PRIVATE)
    private val blockedDomains: MutableSet<String>
    private val whitelistedDomains: MutableSet<String>

    init {
        // Memuat domain yang disimpan saat inisialisasi
        blockedDomains = prefs.getStringSet("custom_domains", mutableSetOf())?.toMutableSet() ?: mutableSetOf()
        whitelistedDomains = prefs.getStringSet("custom_whitelists", mutableSetOf())?.toMutableSet() ?: mutableSetOf()
    }

    /**
     * Tambahkan domain kustom ke dalam daftar blokir.
     */
    fun addDomain(domain: String) {
        val cleanDomain = domain.lowercase().trimEnd('.')
        if (cleanDomain.isNotEmpty()) {
            whitelistedDomains.remove(cleanDomain) // pastikan tidak bentrok
            if (!blockedDomains.contains(cleanDomain)) {
                blockedDomains.add(cleanDomain)
                save()
            }
        }
    }

    /**
     * Tambahkan domain kustom ke dalam daftar whitelist (pengecualian).
     */
    fun addWhitelist(domain: String) {
        val cleanDomain = domain.lowercase().trimEnd('.')
        if (cleanDomain.isNotEmpty()) {
            blockedDomains.remove(cleanDomain) // pastikan tidak bentrok
            if (!whitelistedDomains.contains(cleanDomain)) {
                whitelistedDomains.add(cleanDomain)
                save()
            }
        }
    }

    /**
     * Hapus domain dari daftar blokir maupun whitelist kustom.
     */
    fun removeDomain(domain: String) {
        val cleanDomain = domain.lowercase().trimEnd('.')
        var changed = false
        if (blockedDomains.contains(cleanDomain)) {
            blockedDomains.remove(cleanDomain)
            changed = true
        }
        if (whitelistedDomains.contains(cleanDomain)) {
            whitelistedDomains.remove(cleanDomain)
            changed = true
        }
        if (changed) {
            save()
        }
    }

    /**
     * Periksa apakah domain ini masuk ke daftar blokir kustom buatan pengguna.
     */
    fun isDomainBlocked(domain: String): Boolean {
        if (blockedDomains.isEmpty()) return false
        val lower = domain.lowercase().trimEnd('.')
        
        // Cek domain secara tepat
        if (blockedDomains.contains(lower)) return true
        
        // Cek subdomain
        var idx = lower.indexOf('.')
        while (idx != -1) {
            val parent = lower.substring(idx + 1)
            if (blockedDomains.contains(parent)) return true
            idx = lower.indexOf('.', idx + 1)
        }
        return false
    }

    /**
     * Periksa apakah domain ini masuk ke daftar whitelist kustom buatan pengguna.
     */
    fun isDomainWhitelisted(domain: String): Boolean {
        if (whitelistedDomains.isEmpty()) return false
        val lower = domain.lowercase().trimEnd('.')
        
        // Cek domain secara tepat
        if (whitelistedDomains.contains(lower)) return true
        
        // Cek subdomain
        var idx = lower.indexOf('.')
        while (idx != -1) {
            val parent = lower.substring(idx + 1)
            if (whitelistedDomains.contains(parent)) return true
            idx = lower.indexOf('.', idx + 1)
        }
        return false
    }

    /**
     * Mengambil seluruh daftar domain kustom.
     */
    fun getCustomDomains(): List<String> {
        return blockedDomains.toList()
    }

    fun getCustomWhitelists(): List<String> {
        return whitelistedDomains.toList()
    }

    private fun save() {
        prefs.edit()
            .putStringSet("custom_domains", blockedDomains)
            .putStringSet("custom_whitelists", whitelistedDomains)
            .apply()
    }
}
