import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/presentation/cubit/settings_state.dart';

abstract class AppStrings {
  // Settings Page
  String get account;
  String get appPreferences;
  String get appearance;
  String get language;
  String get selectApp;
  String get selectAppSubtitle;
  String get customBlocklist;
  String get customBlocklistSubtitle;
  String get supportAndLegal;
  String get aboutUs;
  String get privacyPolicy;
  String get termsAndConditions;
  String get appVersion;

  // Language & Theme
  String get system;
  String get light;
  String get dark;
  String get indonesian;
  String get english;

  // Bottom Sheets
  String get chooseLanguage;
  String get chooseTheme;
  String get cancel;
  String get comingSoon;

  // App Selector
  String get searchApp;
  String get allApps;
  String get restrictedApps;
  String get blocked;
  
  // Home Page
  String get protectionInactive;
  String get protectionActive;
  String get inactive;
  String get active;
  String get tapToActivate;
  String get tapToDeactivate;
  String get adsBlocked;
  String get uptime;
  String get targetApps;
  String get liveDnsTerminal;
  String get waitingDnsQuery;
  String get noAppSelectedWarning;

  String get blockDomainTitle;
  String blockDomainMessage(String domain);
  String domainBlockedSuccess(String domain);
  String get blockNow;
  
  String get appName;
  
  static AppStrings of(BuildContext context) {
    // If the widget is not in the tree or we can't access cubit, fallback to ID
    try {
      final lang = context.watch<SettingsCubit>().state.language;
      return lang == AppLanguage.en ? _EnStrings() : _IdStrings();
    } catch (_) {
      return _IdStrings();
    }
  }
}

class _IdStrings implements AppStrings {
  @override String get account => 'Akun';
  @override String get appPreferences => 'PREFERENSI APLIKASI';
  @override String get appearance => 'Tampilan';
  @override String get language => 'Bahasa';
  @override String get selectApp => 'Pilih Aplikasi';
  @override String get selectAppSubtitle => 'Atur aplikasi yang dibatasi';
  @override String get customBlocklist => 'Blocklist Kustom';
  @override String get customBlocklistSubtitle => 'Kelola filter DNS';
  @override String get supportAndLegal => 'DUKUNGAN & LEGAL';
  @override String get aboutUs => 'Tentang Kami';
  @override String get privacyPolicy => 'Kebijakan Privasi';
  @override String get termsAndConditions => 'Syarat & Ketentuan';
  @override String get appVersion => 'Versi Aplikasi';

  @override String get system => 'Sistem';
  @override String get light => 'Terang';
  @override String get dark => 'Gelap';
  @override String get indonesian => 'Bahasa Indonesia';
  @override String get english => 'Bahasa Inggris';

  @override String get chooseLanguage => 'Pilih Bahasa';
  @override String get chooseTheme => 'Pilih Tema';
  @override String get cancel => 'Batal';
  @override String get comingSoon => 'Segera Hadir';

  @override String get searchApp => 'Cari aplikasi...';
  @override String get allApps => 'Semua Aplikasi';
  @override String get restrictedApps => 'Dibatasi';
  @override String get blocked => 'diblokir';

  @override String get protectionInactive => 'Perlindungan Tidak Aktif';
  @override String get protectionActive => 'Perlindungan Aktif';
  @override String get inactive => 'NONAKTIF';
  @override String get active => 'AKTIF';
  @override String get tapToActivate => 'Ketuk untuk mengaktifkan';
  @override String get tapToDeactivate => 'Ketuk untuk menonaktifkan';
  @override String get adsBlocked => 'Iklan Diblokir';
  @override String get uptime => 'Waktu Aktif';
  @override String get targetApps => 'App Target';
  @override String get liveDnsTerminal => 'Live DNS Terminal';
  @override String get waitingDnsQuery => 'Menunggu DNS query...';
  @override String get noAppSelectedWarning => 'Belum ada aplikasi dipilih. Pilih aplikasi target agar blokir iklan berjalan.';

  @override String get blockDomainTitle => 'Blokir Domain?';
  @override String blockDomainMessage(String domain) => 'Apakah Anda yakin ingin memblokir iklan dari:\n\n$domain\n\nJika ini bukan iklan, aplikasi target mungkin akan bermasalah.';
  @override String domainBlockedSuccess(String domain) => '$domain berhasil diblokir!';
  @override String get blockNow => 'Blokir Sekarang';

  @override String get appName => 'Blokir Iklan';
}

class _EnStrings implements AppStrings {
  @override String get account => 'Account';
  @override String get appPreferences => 'APP PREFERENCES';
  @override String get appearance => 'Appearance';
  @override String get language => 'Language';
  @override String get selectApp => 'Select Apps';
  @override String get selectAppSubtitle => 'Manage restricted apps';
  @override String get customBlocklist => 'Custom Blocklist';
  @override String get customBlocklistSubtitle => 'Manage DNS filters';
  @override String get supportAndLegal => 'SUPPORT & LEGAL';
  @override String get aboutUs => 'About Us';
  @override String get privacyPolicy => 'Privacy Policy';
  @override String get termsAndConditions => 'Terms & Conditions';
  @override String get appVersion => 'App Version';

  @override String get system => 'System';
  @override String get light => 'Light';
  @override String get dark => 'Dark';
  @override String get indonesian => 'Indonesian';
  @override String get english => 'English';

  @override String get chooseLanguage => 'Choose Language';
  @override String get chooseTheme => 'Choose Theme';
  @override String get cancel => 'Cancel';
  @override String get comingSoon => 'Coming Soon';

  @override String get searchApp => 'Search apps...';
  @override String get allApps => 'All Apps';
  @override String get restrictedApps => 'Restricted';
  @override String get blocked => 'blocked';

  @override String get protectionInactive => 'Protection Inactive';
  @override String get protectionActive => 'Protection Active';
  @override String get inactive => 'INACTIVE';
  @override String get active => 'ACTIVE';
  @override String get tapToActivate => 'Tap to activate';
  @override String get tapToDeactivate => 'Tap to deactivate';
  @override String get adsBlocked => 'Ads Blocked';
  @override String get uptime => 'Uptime';
  @override String get targetApps => 'Target Apps';
  @override String get liveDnsTerminal => 'Live DNS Terminal';
  @override String get waitingDnsQuery => 'Waiting for DNS query...';
  @override String get noAppSelectedWarning => 'No apps selected. Choose target apps to enable ad blocking.';

  @override String get blockDomainTitle => 'Block Domain?';
  @override String blockDomainMessage(String domain) => 'Are you sure you want to block ads from:\n\n$domain\n\nIf this is not an ad, the target app might misbehave.';
  @override String domainBlockedSuccess(String domain) => '$domain successfully blocked!';
  @override String get blockNow => 'Block Now';

  @override String get appName => 'Block Ads';
}
