import 'dart:typed_data';
import '../../domain/entities/installed_app_entity.dart';

class InstalledAppModel extends InstalledAppEntity {
  const InstalledAppModel({
    required super.packageName,
    required super.appName,
    required super.isBlocked,
    super.icon,
    super.versionName,
  });

  /// Factory dari Map yang dikirim native Android via MethodChannel
  factory InstalledAppModel.fromMap(Map<String, dynamic> map) {
    Uint8List? iconBytes;
    final rawIcon = map['icon'];
    if (rawIcon is Uint8List) {
      iconBytes = rawIcon;
    } else if (rawIcon is List) {
      iconBytes = Uint8List.fromList(rawIcon.cast<int>());
    }

    return InstalledAppModel(
      packageName: map['packageName'] as String? ?? '',
      appName: map['appName'] as String? ?? 'Unknown',
      versionName: map['versionName'] as String? ?? '',
      isBlocked: false,
      icon: iconBytes,
    );
  }

  InstalledAppModel copyWithBlocked(bool isBlocked) {
    return InstalledAppModel(
      packageName: packageName,
      appName: appName,
      isBlocked: isBlocked,
      icon: icon,
      versionName: versionName,
    );
  }
}
