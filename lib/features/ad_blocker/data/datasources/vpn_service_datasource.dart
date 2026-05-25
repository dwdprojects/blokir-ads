import '../../../../core/utils/vpn_utils.dart';
import '../../domain/entities/blocker_status_entity.dart';

abstract class VpnServiceDatasource {
  Future<bool> startVpn({required List<String> targetPackages});
  Future<bool> stopVpn();
  Future<BlockerStatusEntity> getStatus();
  Future<bool> requestPermission();
  Stream<String> get logStream;
  Future<bool> addCustomDomain(String domain);
}

class VpnServiceDatasourceImpl implements VpnServiceDatasource {
  const VpnServiceDatasourceImpl();

  @override
  Future<bool> requestPermission() => VpnUtils.requestVpnPermission();

  @override
  Future<bool> startVpn({required List<String> targetPackages}) =>
      VpnUtils.startVpn(targetPackages: targetPackages);

  @override
  Future<bool> stopVpn() => VpnUtils.stopVpn();

  @override
  Future<BlockerStatusEntity> getStatus() async {
    final raw = await VpnUtils.getVpnStatus();
    return BlockerStatusEntity(
      isActive: raw['isActive'] as bool? ?? false,
      blockedCount: raw['blockedCount'] as int? ?? 0,
      uptime: Duration(seconds: raw['uptimeSeconds'] as int? ?? 0),
      targetPackages:
          List<String>.from(raw['targetPackages'] as List? ?? []),
    );
  }

  @override
  Stream<String> get logStream => VpnUtils.logStream;

  @override
  Future<bool> addCustomDomain(String domain) =>
      VpnUtils.addCustomDomain(domain);
}
