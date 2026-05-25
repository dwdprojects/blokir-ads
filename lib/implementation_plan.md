# Blokir Ads — Flutter Project Structure

## Gambaran Aplikasi

**Blokir Ads** adalah aplikasi Android yang memblokir iklan pada aplikasi lain yang terinstall di perangkat. User memilih aplikasi target yang ingin diblokir iklannya, kemudian aplikasi menggunakan VPN lokal berbasis DNS untuk memfilter lalu lintas iklan tanpa koneksi server luar.

> [!IMPORTANT]
> Aplikasi ini memerlukan **VPN Permission** di Android untuk memblokir iklan secara efektif menggunakan DNS filtering. Ini bukan adblocker berbasis root — murni menggunakan Android VPN API untuk intercept DNS requests.

## Cara Kerja Teknis

1. User install **Blokir Ads** → pilih app target dari daftar installed apps
2. App membuat **local VPN tunnel** (menggunakan `VpnService` Android)
3. Semua DNS request dari app target di-intercept
4. Domain iklan (AdMob, Meta Ads, dll) di-resolve ke `0.0.0.0` (null route)
5. Iklan tidak bisa load → tampilan bersih

## Open Questions

> [!WARNING]
> Beberapa keputusan teknis penting yang perlu konfirmasi:
> 1. **Target platform**: Hanya Android? (iOS sangat terbatas untuk VPN lokal)
> 2. **Metode blokir**: DNS-based VPN (tanpa root) atau butuh root access?
> 3. **Filter apps**: Blokir semua app sekaligus atau per-app spesifik?
> 4. **Blocklist**: Gunakan blocklist lokal (bundled) atau update dari server?

---

## Proposed Changes

### Core Layer

#### [NEW] `lib/core/theme/app_colors.dart`
Palet warna gelap premium dengan aksen biru elektrik.

#### [NEW] `lib/core/theme/app_text_styles.dart`
Typography system dengan Google Fonts (Inter).

#### [NEW] `lib/core/theme/app_theme.dart`
Dark theme Material 3 keseluruhan app.

#### [NEW] `lib/core/constants/app_constants.dart`
Konstanta umum: nama app, versi blocklist, dsb.

#### [NEW] `lib/core/constants/blocklist_constants.dart`
Daftar domain iklan yang diblokir (AdMob, Meta, Unity Ads, dll).

#### [NEW] `lib/core/utils/app_utils.dart`
Helper: format nama app, icon resolving, dsb.

#### [NEW] `lib/core/utils/vpn_utils.dart`
Utility untuk cek status VPN, permission check.

#### [NEW] `lib/core/widgets/custom_button.dart`
Tombol reusable dengan style premium.

#### [NEW] `lib/core/widgets/app_card.dart`
Card widget reusable dengan glassmorphism style.

#### [NEW] `lib/core/widgets/loading_widget.dart`
Loading indicator reusable.

---

### Feature: App Selector (Pilih Aplikasi Target)

#### [NEW] `lib/features/app_selector/domain/entities/installed_app_entity.dart`
Entity: nama app, packageName, icon bytes, isBlocked.

#### [NEW] `lib/features/app_selector/domain/repositories/app_selector_repository.dart`
Abstract repository untuk ambil installed apps.

#### [NEW] `lib/features/app_selector/domain/usecases/get_installed_apps_usecase.dart`
Usecase: ambil semua aplikasi terinstall.

#### [NEW] `lib/features/app_selector/domain/usecases/toggle_app_block_usecase.dart`
Usecase: toggle blokir/tidak blokir app tertentu.

#### [NEW] `lib/features/app_selector/data/models/installed_app_model.dart`
Model + JSON serialization dari package info.

#### [NEW] `lib/features/app_selector/data/datasources/installed_apps_datasource.dart`
Datasource: query installed apps dari sistem Android.

#### [NEW] `lib/features/app_selector/data/repositories/app_selector_repository_impl.dart`
Implementasi repository.

#### [NEW] `lib/features/app_selector/presentation/cubit/app_selector_cubit.dart`
Cubit: manage state daftar apps (loading/loaded/error).

#### [NEW] `lib/features/app_selector/presentation/cubit/app_selector_state.dart`
State classes untuk AppSelectorCubit.

#### [NEW] `lib/features/app_selector/presentation/pages/app_selector_page.dart`
Halaman: list installed apps dengan toggle blokir, search bar.

#### [NEW] `lib/features/app_selector/presentation/widgets/app_list_tile.dart`
Widget tile untuk satu item app dalam list.

---

### Feature: Ad Blocker (VPN Engine)

#### [NEW] `lib/features/ad_blocker/domain/entities/blocker_status_entity.dart`
Entity: isActive, blockedCount, uptime.

#### [NEW] `lib/features/ad_blocker/domain/repositories/ad_blocker_repository.dart`
Abstract: start/stop VPN, get status.

#### [NEW] `lib/features/ad_blocker/domain/usecases/start_blocker_usecase.dart`
Usecase: start VPN service.

#### [NEW] `lib/features/ad_blocker/domain/usecases/stop_blocker_usecase.dart`
Usecase: stop VPN service.

#### [NEW] `lib/features/ad_blocker/domain/usecases/get_blocker_status_usecase.dart`
Usecase: ambil status blocker saat ini.

#### [NEW] `lib/features/ad_blocker/data/datasources/vpn_service_datasource.dart`
Datasource: komunikasi dengan Android VPN native service.

#### [NEW] `lib/features/ad_blocker/data/repositories/ad_blocker_repository_impl.dart`
Implementasi repository.

#### [NEW] `lib/features/ad_blocker/presentation/cubit/ad_blocker_cubit.dart`
Cubit: manage ON/OFF state blocker + statistik.

#### [NEW] `lib/features/ad_blocker/presentation/cubit/ad_blocker_state.dart`
State classes untuk AdBlockerCubit.

#### [NEW] `lib/features/ad_blocker/presentation/pages/ad_blocker_home_page.dart`
Halaman utama: tombol ON/OFF besar, status, statistik.

#### [NEW] `lib/features/ad_blocker/presentation/widgets/blocker_toggle_widget.dart`
Widget toggle animasi premium (power button style).

#### [NEW] `lib/features/ad_blocker/presentation/widgets/blocker_stats_widget.dart`
Widget statistik: jumlah iklan diblokir.

---

### Feature: Blocklist Manager (Kelola Daftar Domain)

#### [NEW] `lib/features/blocklist/domain/entities/blocked_domain_entity.dart`
Entity: domain, category, isEnabled.

#### [NEW] `lib/features/blocklist/domain/repositories/blocklist_repository.dart`
Abstract: CRUD domain blocklist.

#### [NEW] `lib/features/blocklist/domain/usecases/get_blocklist_usecase.dart`
#### [NEW] `lib/features/blocklist/domain/usecases/add_domain_usecase.dart`
#### [NEW] `lib/features/blocklist/domain/usecases/remove_domain_usecase.dart`

#### [NEW] `lib/features/blocklist/data/models/blocked_domain_model.dart`
#### [NEW] `lib/features/blocklist/data/datasources/blocklist_local_datasource.dart`
Local storage dengan `shared_preferences` atau `hive`.

#### [NEW] `lib/features/blocklist/data/repositories/blocklist_repository_impl.dart`

#### [NEW] `lib/features/blocklist/presentation/cubit/blocklist_cubit.dart`
#### [NEW] `lib/features/blocklist/presentation/cubit/blocklist_state.dart`
#### [NEW] `lib/features/blocklist/presentation/pages/blocklist_page.dart`
Halaman kelola domain: add, remove, enable/disable.

---

### Feature: Dashboard / Home

#### [NEW] `lib/features/dashboard/presentation/pages/dashboard_page.dart`
Navigation hub ke semua fitur.

#### [NEW] `lib/features/dashboard/presentation/widgets/feature_card_widget.dart`
Card navigasi premium untuk setiap fitur.

---

### Root Files

#### [MODIFY] `lib/main.dart`
Entry point bersih dengan BlocProvider setup dan MaterialApp.

#### [NEW] `lib/app.dart`
Root widget dengan theme, routing, dan providers.

#### [NEW] `lib/routes/app_router.dart`
Centralized routing dengan named routes.

---

## Dependencies yang Dibutuhkan (`pubspec.yaml`)

```yaml
dependencies:
  flutter_bloc: ^9.0.0       # State management
  device_apps: ^2.2.0        # List installed apps + icons
  shared_preferences: ^2.3.0 # Simpan konfigurasi lokal
  equatable: ^2.0.7          # Value equality untuk entities
  get_it: ^8.0.0             # Dependency injection
  google_fonts: ^6.2.1       # Typography
```

> [!NOTE]
> Implementasi VPN native (Android `VpnService`) memerlukan method channel ke Kotlin. Untuk tahap ini, kita buat **struktur lengkap + UI** dulu dengan VPN sebagai method channel placeholder.

## Verification Plan

### Struktur Folder
- Pastikan semua folder dan file terbuat di lokasi yang benar
- Jalankan `flutter analyze` untuk cek syntax error
- Pastikan import paths valid

### UI
- Jalankan `flutter run` dan cek home page tampil
- Verifikasi dark theme dan animasi berfungsi
