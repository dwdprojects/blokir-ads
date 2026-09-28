# ⚙️ Alur & Logika Settings Cubit (SETTINGS_FLOW)

Dokumen ini menjelaskan pengelolaan konfigurasi preferensi pengguna pada folder `lib/features/settings/presentation/cubit/`.

---

## 📌 File Breakdown

* **`settings_cubit.dart`**: Mengelola pembacaan dan penyimpanan konfigurasi lokal (bahasa, tema, dan mode perlindungan global) menggunakan `SharedPreferences`.
* **`settings_state.dart`**: Immutable state yang merepresentasikan pengaturan aktif: `language` (`AppLanguage`), `themeMode` (`AppThemeMode`), dan `isGlobalProtection` (`bool`).

---

## ⚙️ Logika Langkah Demi Langkah (Step-by-Step)

### 1. Inisialisasi Settings (`_loadSettings`)
* Saat aplikasi pertama kali berjalan, `SettingsCubit` membaca nilai tersimpan dari `SharedPreferences`:
  1. `app_language_key`: Default ke `.id` (Bahasa Indonesia).
  2. `app_theme_key`: Default ke `.system` (Mengikuti tema OS).
  3. `app_global_protection_key`: Default ke `true` (Mode Perlindungan Global aktif otomatis).
* Hasil pembacaan di-emit ke state awal.

### 2. Pengubahan Mode Perlindungan Global (`toggleGlobalProtection`)
* **Tujuan**: Memungkinkan pengguna beralih antara melindungi seluruh game & aplikasi secara otomatis, atau hanya membatasi aplikasi pilihan.
* **Alur**:
  1. Pengguna menyalakan/mematikan switch di halaman Pengaturan.
  2. Cubit memanggil `prefs.setBool(_globalProtectionKey, isGlobal)`.
  3. Cubit meng-emit `state.copyWith(isGlobalProtection: isGlobal)`.
  4. Halaman utama (`AdBlockerHomePage`) dan service VPN otomatis mengadopsi preferensi ini saat tombol aktivasi ditekan.

---

## 📊 Contoh Konkret

* **Default Baru**:
  * `isGlobalProtection = true`
  * State: `SettingsState(language: .id, themeMode: .system, isGlobalProtection: true)`
* **Pengalihan Mode**:
  * Pengguna mematikan switch: `toggleGlobalProtection(false)`
  * State terbarui: `SettingsState(..., isGlobalProtection: false)`
  * Efek di Home Page: Menampilkan peringatan seleksi aplikasi jika belum ada aplikasi terpilih.

---

## ⚠️ Edge Cases & Catatan

1. **Storage Kosong (First Run)**:
   * Menggunakan fallback `prefs.getBool(_globalProtectionKey) ?? true` agar pengguna baru langsung terlindungi secara maksimal tanpa setup rumit.
2. **Sinkronisasi Reaktif**:
   * Komponen UI menggunakan `context.select<SettingsCubit, bool>` agar hanya me-rebuild widget terkait saat preferensi berubah.
