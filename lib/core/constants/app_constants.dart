class AppConstants {
  AppConstants._();

  static const String appName = 'Blokir Ads';
  static const String appVersion = 'v1.1.0#2';

  // SharedPreferences keys
  static String keyBlockedApps = 'blocked_apps';
  static String keyBlockerActive = 'blocker_active';
  static String keyCustomBlocklist = 'custom_blocklist';
  static String keyAdsBlockedCount = 'ads_blocked_count';
  static String keyTotalUptime = 'total_uptime_seconds';

  // VPN Method Channel
  static String vpnChannelName = 'com.blokirads/vpn';
  static String appsChannelName = 'com.blokirads/apps';
  static String logsChannelName = 'com.blokirads/logs';
  static String statusChannelName = 'com.blokirads/status';

  static String methodStartVpn = 'startVpn';
  static String methodStopVpn = 'stopVpn';
  static String methodGetStatus = 'getStatus';
  static String methodRequestPermission = 'requestPermission';
  static String methodAddCustomDomain = 'addCustomDomain';

  // Defaults
  static const int defaultBlockedCount = 0;
}
