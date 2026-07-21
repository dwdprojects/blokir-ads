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

  // About Us Page
  String get aboutAppDescription;
  String get keyFeatures;
  String get featureAdBlock;
  String get featureCustomBlocklist;
  String get featureLiveDns;
  String get featureTargetApp;
  String get featurePrivacy;
  String get developedBy;
  String get developerTeam;
  String get supportUs;
  String get rateApp;
  String get shareApp;
  String shareMessage(String appName);
  String get supportDevelopmentTitle;
  String get supportDevelopmentDesc;
  String supportVia(String provider);

  // Legal & Terms Page
  String get legalAndTerms;
  String get lastUpdated;
  String privacyPolicyIntro(String appName);
  String termsIntro(String appName);
  String get dataCollectionTitle;
  String get dataCollectionDesc;
  String get dataUsageTitle;
  String get dataUsageDesc;
  String get dataSecurityTitle;
  String get dataSecurityDesc;
  String get userRightsTitle;
  String get userRightsDesc;
  String get contactTitle;
  String get contactDesc;
  String get acceptanceTitle;
  String get acceptanceDesc;
  String get serviceUseTitle;
  String get serviceUseDesc;
  String get disclaimerTitle;
  String get disclaimerDesc;
  String get changesTitle;
  String get changesDesc;

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

  @override String get aboutAppDescription => 'Blokir Iklan adalah aplikasi komprehensif yang dibangun dengan dedikasi tinggi untuk memberikan perlindungan privasi dan kenyamanan Anda saat berselancar di internet. Kami menyajikan fitur lengkap mulai dari pemblokiran iklan otomatis, kustomisasi filter, hingga pemantauan DNS secara real-time.';
  @override String get keyFeatures => 'Fitur Unggulan';
  @override String get featureAdBlock => 'Blokir Iklan Otomatis';
  @override String get featureCustomBlocklist => 'Kustomisasi Blocklist';
  @override String get featureLiveDns => 'Live DNS Terminal';
  @override String get featureTargetApp => 'Pemilihan Aplikasi Target';
  @override String get featurePrivacy => 'Perlindungan Privasi';
  @override String get developedBy => 'Dikembangkan Oleh';
  @override String get developerTeam => 'DWD Project';
  @override String get supportUs => 'Dukung Pengembangan';
  @override String get rateApp => 'Beri Nilai Aplikasi';
  @override String get shareApp => 'Bagikan Aplikasi';
  @override String shareMessage(String appName) => 'Lindungi privasi dan blokir iklan dengan aplikasi $appName!\n\nUnduh sekarang!';
  @override String get supportDevelopmentTitle => 'Dukung Pengembangan';
  @override String get supportDevelopmentDesc => 'Aplikasi ini 100% gratis dan open-source. Jika aplikasi ini membantu Anda, pertimbangkan untuk memberikan dukungan agar pengembangan terus berjalan.';
  @override String supportVia(String provider) => 'Dukung via $provider';

  @override String get legalAndTerms => 'Kebijakan & Ketentuan';
  @override String get lastUpdated => 'Terakhir diperbarui: 21 Mei 2026';
  @override String privacyPolicyIntro(String appName) => 'Kami berkomitmen untuk melindungi privasi dan data pribadi Anda. Dokumen ini menjelaskan bagaimana aplikasi $appName beroperasi tanpa mengumpulkan data identitas Anda.';
  @override String termsIntro(String appName) => 'Dengan menggunakan aplikasi $appName, Anda menyetujui syarat dan ketentuan berikut. Harap baca dengan saksama sebelum menggunakan layanan kami.';
  @override String get dataCollectionTitle => 'Pengumpulan Data';
  @override String get dataCollectionDesc => 'Aplikasi ini dirancang dengan prinsip privasi-pertama (privacy-first). Kami tidak mengumpulkan, menyimpan, atau mengirimkan riwayat penjelajahan, query DNS, maupun data pribadi Anda ke server mana pun. Semua pemrosesan filter DNS dilakukan secara lokal di perangkat Anda.';
  @override String get dataUsageTitle => 'Penggunaan Data';
  @override String get dataUsageDesc => 'Aplikasi hanya menggunakan koneksi VPN lokal (VpnService) untuk merutekan lalu lintas internet Anda melalui filter DNS internal guna memblokir iklan. Tidak ada data yang diarahkan ke VPN eksternal.';
  @override String get dataSecurityTitle => 'Keamanan Data';
  @override String get dataSecurityDesc => 'Karena seluruh pemrosesan dilakukan secara offline di dalam perangkat (on-device), data Anda tidak akan pernah bocor ke pihak ketiga. Kami tidak memiliki server analitik untuk melacak aktivitas Anda.';
  @override String get userRightsTitle => 'Hak Pengguna';
  @override String get userRightsDesc => 'Anda memiliki hak penuh untuk mengaktifkan atau menonaktifkan layanan kapan saja, mengubah pengaturan blocklist kustom, serta menghapus data lokal aplikasi dari pengaturan sistem Android.';
  @override String get contactTitle => 'Kontak & Pertanyaan';
  @override String get contactDesc => 'Jika Anda memiliki pertanyaan atau masukan terkait kebijakan privasi ini, Anda dapat menghubungi tim pengembang kami melalui repositori GitHub resmi kami.';
  @override String get acceptanceTitle => 'Penerimaan Syarat';
  @override String get acceptanceDesc => 'Dengan menginstal dan menggunakan aplikasi ini, Anda menyatakan setuju dan terikat dengan semua ketentuan yang tertulis di halaman ini.';
  @override String get serviceUseTitle => 'Penggunaan Layanan';
  @override String get serviceUseDesc => 'Aplikasi ini disediakan sebagai alat pemblokir iklan lokal. Anda setuju untuk tidak menggunakan aplikasi ini dengan tujuan yang melanggar hukum, merusak layanan pihak ketiga, atau menyalahgunakan fitur VpnService.';
  @override String get disclaimerTitle => 'Penafian (Disclaimer)';
  @override String get disclaimerDesc => 'Aplikasi ini disediakan "sebagaimana adanya" tanpa jaminan apa pun. Kami tidak bertanggung jawab atas kerusakan fungsi pada aplikasi target yang diakibatkan oleh pemblokiran domain iklan tertentu.';
  @override String get changesTitle => 'Perubahan Kebijakan';
  @override String get changesDesc => 'Kami berhak untuk memperbarui kebijakan dan ketentuan ini kapan saja. Perubahan akan berlaku secara langsung setelah kami memperbarui halaman ini di pembaruan aplikasi berikutnya.';

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

  @override String get aboutAppDescription => 'Block Ads is a comprehensive app built with high dedication to provide privacy protection and comfort while you surf the internet. We present complete features ranging from automatic ad blocking, filter customization, to real-time DNS monitoring.';
  @override String get keyFeatures => 'Key Features';
  @override String get featureAdBlock => 'Automatic Ad Blocking';
  @override String get featureCustomBlocklist => 'Custom Blocklist';
  @override String get featureLiveDns => 'Live DNS Terminal';
  @override String get featureTargetApp => 'Target App Selection';
  @override String get featurePrivacy => 'Privacy Protection';
  @override String get developedBy => 'Developed By';
  @override String get developerTeam => 'DWD Project';
  @override String get supportUs => 'Support Development';
  @override String get rateApp => 'Rate App';
  @override String get shareApp => 'Share App';
  @override String shareMessage(String appName) => 'Protect your privacy and block ads with the $appName app!\n\nDownload now!';
  @override String get supportDevelopmentTitle => 'Support Development';
  @override String get supportDevelopmentDesc => 'This app is 100% free and open-source. If this app helps you, consider supporting us to keep the development going.';
  @override String supportVia(String provider) => 'Support via $provider';

  @override String get legalAndTerms => 'Privacy & Terms';
  @override String get lastUpdated => 'Last updated: May 21, 2026';
  @override String privacyPolicyIntro(String appName) => 'We are committed to protecting your privacy and personal data. This document explains how the $appName app operates without collecting your identity data.';
  @override String termsIntro(String appName) => 'By using the $appName app, you agree to the following terms and conditions. Please read carefully before using our services.';
  @override String get dataCollectionTitle => 'Data Collection';
  @override String get dataCollectionDesc => 'This app is designed with a privacy-first principle. We do not collect, store, or transmit your browsing history, DNS queries, or personal data to any servers. All DNS filter processing is done locally on your device.';
  @override String get dataUsageTitle => 'Data Usage';
  @override String get dataUsageDesc => 'The app only uses a local VPN connection (VpnService) to route your internet traffic through an internal DNS filter to block ads. No data is directed to external VPNs.';
  @override String get dataSecurityTitle => 'Data Security';
  @override String get dataSecurityDesc => 'Since all processing is done entirely offline on your device, your data will never leak to third parties. We do not have analytics servers to track your activities.';
  @override String get userRightsTitle => 'User Rights';
  @override String get userRightsDesc => 'You have full rights to enable or disable the service at any time, change custom blocklist settings, and delete local app data from Android system settings.';
  @override String get contactTitle => 'Contact & Inquiries';
  @override String get contactDesc => 'If you have any questions or feedback regarding this privacy policy, you can contact our development team via our official GitHub repository.';
  @override String get acceptanceTitle => 'Acceptance of Terms';
  @override String get acceptanceDesc => 'By installing and using this app, you agree and are bound by all the conditions stated on this page.';
  @override String get serviceUseTitle => 'Service Usage';
  @override String get serviceUseDesc => 'This app is provided as a local ad blocker tool. You agree not to use this app for unlawful purposes, to disrupt third-party services, or to abuse the VpnService feature.';
  @override String get disclaimerTitle => 'Disclaimer';
  @override String get disclaimerDesc => 'This app is provided "as is" without any warranty. We are not responsible for functional breakages in target apps caused by blocking specific ad domains.';
  @override String get changesTitle => 'Changes to Policy';
  @override String get changesDesc => 'We reserve the right to update these policies and terms at any time. Changes will take effect immediately once we update this page in the next app release.';

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
