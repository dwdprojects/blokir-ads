import '../entities/installed_app_entity.dart';

abstract class AppSelectorRepository {
  Future<List<InstalledAppEntity>> getInstalledApps();
  Future<List<String>> getBlockedPackages();
  Future<void> saveBlockedPackages(List<String> packages);
}
