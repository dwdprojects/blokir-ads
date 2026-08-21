package com.dwd.blokirads

import android.content.Context
import android.content.SharedPreferences

class CustomBlocklistManager(context: Context) {

    private val prefs: SharedPreferences = context.getSharedPreferences("CustomBlocklistPrefs", Context.MODE_PRIVATE)
    private val blockedDomains: MutableSet<String>

    init {
        // Memuat domain yang disimpan saat inisialisasi
        blockedDomains = prefs.getStringSet("custom_domains", mutableSetOf())?.toMutableSet() ?: mutableSetOf()
    }

    /**
     * Tambahkan domain kustom ke dalam daftar blokir.
     */
    fun addDomain(domain: String) {
        val cleanDomain = domain.lowercase().trimEnd('.')
        if (cleanDomain.isNotEmpty() && !blockedDomains.contains(cleanDomain)) {
            blockedDomains.add(cleanDomain)
            save()
        }
    }

    /**
     * Hapus domain dari daftar blokir kustom.
     */
    fun removeDomain(domain: String) {
        val cleanDomain = domain.lowercase().trimEnd('.')
        if (blockedDomains.contains(cleanDomain)) {
            blockedDomains.remove(cleanDomain)
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
     * Mengambil seluruh daftar domain kustom.
     */
    fun getCustomDomains(): List<String> {
        return blockedDomains.toList()
    }

    private fun save() {
        prefs.edit().putStringSet("custom_domains", blockedDomains).apply()
    }
}
