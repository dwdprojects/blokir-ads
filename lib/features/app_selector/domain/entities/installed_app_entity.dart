import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class InstalledAppEntity extends Equatable {
  const InstalledAppEntity({
    required this.packageName,
    required this.appName,
    required this.isBlocked,
    this.icon,
    this.versionName = '',
  });

  final String packageName;
  final String appName;
  final bool isBlocked;
  final Uint8List? icon;
  final String versionName;

  InstalledAppEntity copyWith({
    String? packageName,
    String? appName,
    bool? isBlocked,
    Uint8List? icon,
    String? versionName,
  }) {
    return InstalledAppEntity(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      isBlocked: isBlocked ?? this.isBlocked,
      icon: icon ?? this.icon,
      versionName: versionName ?? this.versionName,
    );
  }

  @override
  List<Object?> get props => [packageName, appName, isBlocked, versionName];
}
