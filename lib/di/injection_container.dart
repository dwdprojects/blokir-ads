// ignore_for_file: unused_import

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../core/constants/app_constants.dart';

// App Selector
import '../features/app_selector/data/datasources/installed_apps_datasource.dart';
import '../features/app_selector/data/repositories/app_selector_repository_impl.dart';
import '../features/app_selector/domain/repositories/app_selector_repository.dart';
import '../features/app_selector/domain/usecases/get_installed_apps_usecase.dart';
import '../features/app_selector/domain/usecases/toggle_app_block_usecase.dart';
import '../features/app_selector/presentation/cubit/app_selector_cubit.dart';

// Ad Blocker
import '../features/ad_blocker/data/datasources/vpn_service_datasource.dart';
import '../features/ad_blocker/data/repositories/ad_blocker_repository_impl.dart';
import '../features/ad_blocker/domain/repositories/ad_blocker_repository.dart';
import '../features/ad_blocker/domain/usecases/get_blocker_status_usecase.dart';
import '../features/ad_blocker/domain/usecases/start_blocker_usecase.dart';
import '../features/ad_blocker/domain/usecases/stop_blocker_usecase.dart';
import '../features/ad_blocker/presentation/cubit/ad_blocker_cubit.dart';

// Blocklist
import '../features/blocklist/data/datasources/blocklist_local_datasource.dart';
import '../features/blocklist/data/repositories/blocklist_repository_impl.dart';
import '../features/blocklist/domain/repositories/blocklist_repository.dart';
import '../features/blocklist/domain/usecases/blocklist_usecases.dart';
import '../features/blocklist/presentation/cubit/blocklist_cubit.dart';

// Settings
import '../features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // ─── App Selector ───────────────────────────────────────────
  sl.registerLazySingleton<InstalledAppsDatasource>(
    () => InstalledAppsDatasourceImpl(),
  );
  sl.registerLazySingleton<AppSelectorRepository>(
    () => AppSelectorRepositoryImpl(
      datasource: sl<InstalledAppsDatasource>(),
      prefs: sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetInstalledAppsUsecase(sl<AppSelectorRepository>()),
  );
  sl.registerLazySingleton(
    () => ToggleAppBlockUsecase(sl<AppSelectorRepository>()),
  );
  sl.registerFactory(
    () => AppSelectorCubit(
      getInstalledApps: sl<GetInstalledAppsUsecase>(),
      toggleAppBlock: sl<ToggleAppBlockUsecase>(),
    ),
  );

  // ─── Ad Blocker ─────────────────────────────────────────────
  sl.registerLazySingleton<VpnServiceDatasource>(
    () => VpnServiceDatasourceImpl(),
  );
  sl.registerLazySingleton<AdBlockerRepository>(
    () => AdBlockerRepositoryImpl(datasource: sl<VpnServiceDatasource>()),
  );
  sl.registerLazySingleton(
    () => GetBlockerStatusUsecase(sl<AdBlockerRepository>()),
  );
  sl.registerLazySingleton(
    () => StartBlockerUsecase(sl<AdBlockerRepository>()),
  );
  sl.registerLazySingleton(() => StopBlockerUsecase(sl<AdBlockerRepository>()));
  sl.registerFactory(
    () => AdBlockerCubit(
      getStatus: sl<GetBlockerStatusUsecase>(),
      startBlocker: sl<StartBlockerUsecase>(),
      stopBlocker: sl<StopBlockerUsecase>(),
      repository: sl<AdBlockerRepository>(),
    ),
  );

  // ─── Blocklist ───────────────────────────────────────────────
  sl.registerLazySingleton<BlocklistLocalDatasource>(
    () => BlocklistLocalDatasourceImpl(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<BlocklistRepository>(
    () => BlocklistRepositoryImpl(datasource: sl<BlocklistLocalDatasource>()),
  );
  sl.registerLazySingleton(
    () => GetBlocklistUsecase(sl<BlocklistRepository>()),
  );
  sl.registerLazySingleton(() => AddDomainUsecase(sl<BlocklistRepository>()));
  sl.registerLazySingleton(
    () => RemoveDomainUsecase(sl<BlocklistRepository>()),
  );
  sl.registerFactory(
    () => BlocklistCubit(
      getBlocklist: sl<GetBlocklistUsecase>(),
      addDomain: sl<AddDomainUsecase>(),
      removeDomain: sl<RemoveDomainUsecase>(),
    ),
  );

  // ─── Settings ───────────────────────────────────────────────
  sl.registerFactory(
    () => SettingsCubit(prefs: sl<SharedPreferences>()),
  );
}
