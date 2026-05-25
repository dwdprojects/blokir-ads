// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/blocker_status_entity.dart';
import '../../domain/usecases/get_blocker_status_usecase.dart';
import '../../domain/usecases/start_blocker_usecase.dart';
import '../../domain/usecases/stop_blocker_usecase.dart';
import '../../domain/repositories/ad_blocker_repository.dart';
import 'ad_blocker_state.dart';

class AdBlockerCubit extends Cubit<AdBlockerState> {
  AdBlockerCubit({
    required GetBlockerStatusUsecase getStatus,
    required StartBlockerUsecase startBlocker,
    required StopBlockerUsecase stopBlocker,
    required AdBlockerRepository repository,
  }) : _getStatus = getStatus,
       _startBlocker = startBlocker,
       _stopBlocker = stopBlocker,
       _repository = repository,
       super(const AdBlockerInitial());

  final GetBlockerStatusUsecase _getStatus;
  final StartBlockerUsecase _startBlocker;
  final StopBlockerUsecase _stopBlocker;
  final AdBlockerRepository _repository;
  Timer? _uptimeTimer;
  int _uptimeSeconds = 0;

  Stream<String> get logStream => _repository.logStream;

  Future<void> loadStatus() async {
    emit(const AdBlockerLoading());
    try {
      final status = await _getStatus();
      _emit(status);
    } catch (e) {
      emit(AdBlockerError('Gagal memuat status: $e'));
    }
  }

  Future<void> toggleBlocker({required List<String> targetPackages}) async {
    final current = state;
    final isActive = current is AdBlockerActive || current is AdBlockerLoading;

    emit(const AdBlockerLoading());

    try {
      if (isActive) {
        await _stopBlocker();
        _stopUptimeTimer();
        final status = await _getStatus();
        _emit(status);
      } else {
        final hasPermission = await _repository.requestPermission();
        if (!hasPermission) {
          emit(const AdBlockerPermissionRequired());
          return;
        }
        final started = await _startBlocker(targetPackages: targetPackages);
        if (started) {
          _startUptimeTimer();
        }
        final status = await _getStatus();
        _emit(status);
      }
    } catch (e) {
      emit(AdBlockerError('Operasi gagal: $e'));
    }
  }

  Future<void> blockCustomDomain(String domain) async {
    try {
      final success = await _repository.addCustomDomain(domain);
      if (success) {
        // Optimistically reload status if needed, though logs will reflect it
      }
    } catch (e) {
      // Ignore or show error
    }
  }

  void _emit(BlockerStatusEntity status) {
    if (status.isActive) {
      emit(AdBlockerActive(status: status));
    } else {
      emit(AdBlockerInactive(status: status));
    }
  }

  void _startUptimeTimer() {
    _uptimeSeconds = 0;
    _uptimeTimer?.cancel();
    _uptimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _uptimeSeconds++;
      final current = state;
      if (current is AdBlockerActive) {
        emit(
          AdBlockerActive(
            status: current.status.copyWith(
              uptime: Duration(seconds: _uptimeSeconds),
            ),
          ),
        );
      }
    });
  }

  void _stopUptimeTimer() {
    _uptimeTimer?.cancel();
    _uptimeTimer = null;
    _uptimeSeconds = 0;
  }

  @override
  Future<void> close() {
    _stopUptimeTimer();
    return super.close();
  }
}
