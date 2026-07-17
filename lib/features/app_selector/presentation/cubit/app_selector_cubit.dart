// ignore_for_file: prefer_initializing_formals

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_installed_apps_usecase.dart';
import '../../domain/usecases/toggle_app_block_usecase.dart';
import 'app_selector_state.dart';

class AppSelectorCubit extends Cubit<AppSelectorState> {
  AppSelectorCubit({
    required GetInstalledAppsUsecase getInstalledApps,
    required ToggleAppBlockUsecase toggleAppBlock,
  }) : _getInstalledApps = getInstalledApps,
       _toggleAppBlock = toggleAppBlock,
       super(AppSelectorInitial());

  final GetInstalledAppsUsecase _getInstalledApps;
  final ToggleAppBlockUsecase _toggleAppBlock;

  Future<void> loadApps() async {
    emit(AppSelectorLoading());
    try {
      final apps = await _getInstalledApps();
      final blocked = apps
          .where((a) => a.isBlocked)
          .map((a) => a.packageName)
          .toList();
      emit(AppSelectorLoaded(apps: apps, blockedPackages: blocked));
    } catch (e) {
      emit(AppSelectorError('Gagal memuat daftar aplikasi: $e'));
    }
  }

  Future<void> toggleBlock(String packageName, bool block) async {
    final current = state;
    if (current is! AppSelectorLoaded) return;

    try {
      final updatedBlocked = await _toggleAppBlock(
        packageName: packageName,
        block: block,
      );
      final updatedApps = current.apps.map((app) {
        if (app.packageName == packageName) {
          return app.copyWith(isBlocked: block);
        }
        return app;
      }).toList();

      emit(
        current.copyWith(apps: updatedApps, blockedPackages: updatedBlocked),
      );
    } catch (e) {
      emit(AppSelectorError('Gagal menyimpan perubahan: $e'));
    }
  }

  void search(String query) {
    final current = state;
    if (current is AppSelectorLoaded) {
      emit(current.copyWith(searchQuery: query));
    }
  }
}
