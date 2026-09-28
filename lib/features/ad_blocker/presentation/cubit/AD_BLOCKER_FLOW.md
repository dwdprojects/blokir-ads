# 🛡️ Alur & Logika Ad Blocker Cubit (AD_BLOCKER_FLOW)

Dokumen ini menjelaskan arsitektur state management dan alur eksekusi pada folder `lib/features/ad_blocker/presentation/cubit/`.

---

## 📌 File Breakdown

* **`ad_blocker_cubit.dart`**: Mengelola siklus hidup VPN, request izin VPN, toggle aktif/nonaktif (Mode Global vs Per-App), pemantauan uptime, dan penerimaan status/log secara reaktif dari sistem Android.
* **`ad_blocker_state.dart`**: Definisi state (Immutable / Equatable): `AdBlockerInitial`, `AdBlockerLoading`, `AdBlockerActive`, `AdBlockerInactive`, `AdBlockerPermissionRequired`, dan `AdBlockerError`.

---

## ⚙️ Logika Langkah Demi Langkah (Step-by-Step)

### 1. Inisialisasi & Reaktivitas Status
* Saat `AdBlockerCubit` diinstansiasi, cubit langsung berlangganan ke `_repository.statusStream` (EventChannel dari native Android `BlokirVpnService`).
* Jika sistem Android mematikan VPN (misalnya dicabut dari quick settings atau crash), `_handleStatusChanged(false)` otomatis dipanggil dan memperbarui UI tanpa polling.

### 2. Memulai Layanan (`toggleBlocker`)
```dart
await cubit.toggleBlocker(
  targetPackages: targetPackages,
  isGlobalMode: isGlobalProtection,
);
```
1. **Pengecekan State**: Jika status saat ini aktif, cubit memanggil `_stopBlocker()`.
2. **Pengecekan Izin**: Jika nonaktif, periksa izin VPN (`requestPermission`). Jika user belum menyetujui prompt VPN Android, emit `AdBlockerPermissionRequired`.
3. **Pemilihan Mode**:
   * **Mode Global (`isGlobalMode = true`)**: Mengirimkan sinyal ke native Android untuk mengecualikan aplikasi Blokir Ads sendiri (`addDisallowedApplication`) dan menyaring **semua aplikasi & game di perangkat secara otomatis**. Game baru yang diinstal anak-anak otomatis terproteksi.
   * **Mode Per-App (`isGlobalMode = false`)**: Hanya mendaftarkan paket yang ada di `targetPackages` (`addAllowedApplication`).
4. **Timer Uptime**: Ketika status aktif diterima, `_startUptimeTimer()` menyalakan timer 1 detik berkala untuk menghitung durasi aktif perlindungan.

---

## 📊 Contoh Konkret (Input / Output)

### Contoh 1: Menyalakan Mode Global
* **Input**: `targetPackages = []`, `isGlobalMode = true`
* **Alur**:
  1. `emit(AdBlockerLoading)`
  2. `requestPermission()` → `true`
  3. `startBlocker(targetPackages: [], isGlobalMode: true)`
  4. Native `BlokirVpnService` aktif → `statusStream` mengirim `true`
  5. `emit(AdBlockerActive(status: BlockerStatusEntity(isActive: true, blockedCount: 0, uptime: 0s)))`
* **Output Tampilan**: Badge hijau "Perlindungan Aktif", status target "Semua Game & App".

### Contoh 2: Game Menampilkan Iklan & Mencoba Install Liar
* **Latar**: Anak bermain game Unity yang mencoba memuat iklan dari `unityads.unity3d.com` atau redirect via `app.appsflyer.com`.
* **Intersepsi**: Native VPN merespons DNS dengan IP `0.0.0.0` (null-route).
* **Hasil**: Iklan gagal dimuat, pengalihan otomatis ke Play Store terblokir, dan `blockedCount` bertambah +1.

---

## ⚠️ Edge Cases & Penanganan Error

1. **User Menolak Izin VPN Sistem**:
   * `requestPermission()` menghasilkan `false`.
   * Cubit meng-emit `AdBlockerPermissionRequired` sehingga UI memunculkan SnackBar peringatan izin.
2. **Koneksi Terputus / Revoke oleh Sistem**:
   * Android memanggil `onRevoke()` pada service.
   * EventChannel native mengirim `false` ke `statusStream`.
   * Timer uptime dihentikan (`_stopUptimeTimer()`), dan state kembali ke `AdBlockerInactive`.
3. **Memory Leak Prevention**:
   * Metode `close()` membatalkan `_statusSubscription` dan membatalkan `_uptimeTimer`.
4. **Pencegahan Double-Start Saat Instal Pertama (Race Condition)**:
   * Native Android memisahkan request code antara `REQUEST_CODE_PERMISSION` (hanya meminta izin dialog) dan `REQUEST_CODE_START_VPN` (memulai layanan).
   * Pada saat izin pertama kali disetujui pengguna, dialog hanya mengembalikan `granted = true` ke Flutter, lalu Flutter secara teratur memanggil `startBlocker()`.
   * Pada `BlokirVpnService`, pemanggilan berulang dicegah dengan `restartVpnInterface()` alih-alih `stopSelf()`, sehingga service tidak pernah mati secara prematur saat pertama kali dinyalakan.
