// ignore_for_file: prefer_initializing_formals

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/installed_app_entity.dart';
import '../../domain/repositories/app_selector_repository.dart';
import '../datasources/installed_apps_datasource.dart';
import '../../../../core/constants/app_constants.dart';

class AppSelectorRepositoryImpl implements AppSelectorRepository {
  AppSelectorRepositoryImpl({
    required InstalledAppsDatasource datasource,
    required SharedPreferences prefs,
  }) : _datasource = datasource,
       _prefs = prefs;

  final InstalledAppsDatasource _datasource;
  final SharedPreferences _prefs;

  @override
  Future<List<InstalledAppEntity>> getInstalledApps() async {
    return _datasource.getInstalledApps();
  }

  @override
  Future<List<String>> getBlockedPackages() async {
    final raw = _prefs.getString(AppConstants.keyBlockedApps);
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw) as List);
  }

  @override
  Future<void> saveBlockedPackages(List<String> packages) async {
    await _prefs.setString(AppConstants.keyBlockedApps, jsonEncode(packages));
  }
}
