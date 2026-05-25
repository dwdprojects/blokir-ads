// ignore_for_file: prefer_initializing_formals

import '../../domain/entities/blocker_status_entity.dart';
import '../../domain/repositories/ad_blocker_repository.dart';
import '../datasources/vpn_service_datasource.dart';

class AdBlockerRepositoryImpl implements AdBlockerRepository {
  AdBlockerRepositoryImpl({required VpnServiceDatasource datasource})
    : _datasource = datasource;

  final VpnServiceDatasource _datasource;

  @override
  Future<bool> requestPermission() => _datasource.requestPermission();

  @override
  Stream<String> get logStream => _datasource.logStream;

  @override
  Future<bool> startBlocker({required List<String> targetPackages}) =>
      _datasource.startVpn(targetPackages: targetPackages);

  @override
  Future<bool> stopBlocker() => _datasource.stopVpn();

  @override
  Future<bool> addCustomDomain(String domain) =>
      _datasource.addCustomDomain(domain);

  @override
  Future<BlockerStatusEntity> getStatus() => _datasource.getStatus();
}
