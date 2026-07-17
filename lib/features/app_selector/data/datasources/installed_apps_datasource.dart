import 'package:flutter/services.dart';
import '../models/installed_app_model.dart';

abstract class InstalledAppsDatasource {
  Future<List<InstalledAppModel>> getInstalledApps();
}

/// Datasource menggunakan MethodChannel ke Android native
/// untuk mendapatkan daftar installed apps dengan icon.
class InstalledAppsDatasourceImpl implements InstalledAppsDatasource {
  InstalledAppsDatasourceImpl();

  static const _channel = MethodChannel('com.blokirads/apps');

  @override
  Future<List<InstalledAppModel>> getInstalledApps() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
      if (result == null) return [];

      return result.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return InstalledAppModel.fromMap(map);
      }).toList();
    } on PlatformException catch (e) {
      throw Exception('Gagal memuat apps: ${e.message}');
    }
  }
}
