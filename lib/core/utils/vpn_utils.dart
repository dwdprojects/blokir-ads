import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class VpnUtils {
  VpnUtils._();

  static final MethodChannel _channel =
      MethodChannel(AppConstants.vpnChannelName);
  
  static final EventChannel _logChannel =
      EventChannel(AppConstants.logsChannelName);
      
  static final EventChannel _statusChannel =
      EventChannel(AppConstants.statusChannelName);

  static Stream<String> get logStream =>
      _logChannel.receiveBroadcastStream().cast<String>();
      
  static Stream<bool> get statusStream =>
      _statusChannel.receiveBroadcastStream().cast<bool>();

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

  static Future<bool> removeCustomDomain(String domain) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppConstants.methodRemoveCustomDomain,
        {'domain': domain},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> addCustomWhitelist(String domain) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppConstants.methodAddCustomWhitelist,
        {'domain': domain},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> removeCustomWhitelist(String domain) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppConstants.methodRemoveCustomWhitelist,
        {'domain': domain},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
