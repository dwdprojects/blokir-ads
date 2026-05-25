class AppConstants {
  AppConstants._();

  static const String appName = 'Blokir Ads';
  static const String appVersion = '1.0.0';

  // SharedPreferences keys
  static const String keyBlockedApps = 'blocked_apps';
  static const String keyBlockerActive = 'blocker_active';
  static const String keyCustomBlocklist = 'custom_blocklist';
  static const String keyAdsBlockedCount = 'ads_blocked_count';
  static const String keyTotalUptime = 'total_uptime_seconds';

  // VPN Method Channel
  static const String vpnChannelName = 'com.blokirads/vpn';
  static const String appsChannelName = 'com.blokirads/apps';
  static const String logsChannelName = 'com.blokirads/logs';

  static const String methodStartVpn = 'startVpn';
  static const String methodStopVpn = 'stopVpn';
  static const String methodGetStatus = 'getStatus';
  static const String methodRequestPermission = 'requestPermission';
  static const String methodAddCustomDomain = 'addCustomDomain';

  // Defaults
  static const int defaultBlockedCount = 0;
}
