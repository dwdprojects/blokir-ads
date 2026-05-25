import '../entities/installed_app_entity.dart';
import '../repositories/app_selector_repository.dart';

class GetInstalledAppsUsecase {
  GetInstalledAppsUsecase(this._repository);

  final AppSelectorRepository _repository;

  Future<List<InstalledAppEntity>> call() async {
    final apps = await _repository.getInstalledApps();
    final blockedPackages = await _repository.getBlockedPackages();

    return apps
        .map((app) => app.copyWith(
              isBlocked: blockedPackages.contains(app.packageName),
            ))
        .toList()
      ..sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
  }
}
