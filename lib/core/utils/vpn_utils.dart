import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class VpnUtils {
  VpnUtils._();

  static const MethodChannel _channel =
      MethodChannel(AppConstants.vpnChannelName);
  
  static const EventChannel _logChannel =
      EventChannel(AppConstants.logsChannelName);

  static Stream<String> get logStream =>
      _logChannel.receiveBroadcastStream().cast<String>();

  static Future<bool> requestVpnPermission() async {
    try {
      final result = await _channel
          .invokeMethod<bool>(AppConstants.methodRequestPermission);
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> startVpn({required List<String> targetPackages}) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppConstants.methodStartVpn,
        {'targetPackages': targetPackages},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> stopVpn() async {
    try {
      final result =
          await _channel.invokeMethod<bool>(AppConstants.methodStopVpn);
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getVpnStatus() async {
    try {
      final result = await _channel
          .invokeMethod<Map<dynamic, dynamic>>(AppConstants.methodGetStatus);
      if (result == null) return {'isActive': false, 'blockedCount': 0};
      return Map<String, dynamic>.from(result);
    } on PlatformException {
      return {'isActive': false, 'blockedCount': 0};
    }
  }

  static Future<bool> addCustomDomain(String domain) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppConstants.methodAddCustomDomain,
        {'domain': domain},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
