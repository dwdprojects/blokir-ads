// ignore_for_file: prefer_initializing_formals

import '../../../../core/utils/vpn_utils.dart';
import '../../domain/entities/blocked_domain_entity.dart';
import '../../domain/repositories/blocklist_repository.dart';
import '../datasources/blocklist_local_datasource.dart';
import '../models/blocked_domain_model.dart';

class BlocklistRepositoryImpl implements BlocklistRepository {
  BlocklistRepositoryImpl({required BlocklistLocalDatasource datasource})
    : _datasource = datasource;

  final BlocklistLocalDatasource _datasource;

  @override
  Future<List<BlockedDomainEntity>> getBlocklist() =>
      _datasource.getBlocklist();

  @override
  Future<void> addDomain(BlockedDomainEntity domain) async {
    final current = await _datasource.getBlocklist();
    final updated = [
      ...current,
      BlockedDomainModel(
        domain: domain.domain,
        category: domain.category,
        isEnabled: domain.isEnabled,
        isCustom: true,
      ),
    ];
    await _datasource.saveBlocklist(updated);
    
    if (domain.isEnabled) {
      await VpnUtils.addCustomDomain(domain.domain);
    } else {
      await VpnUtils.addCustomWhitelist(domain.domain);
    }
  }

  @override
  Future<void> removeDomain(String domain) async {
    final current = await _datasource.getBlocklist();
    final updated = current.where((d) => d.domain != domain).toList();
    await _datasource.saveBlocklist(updated);
    
    await VpnUtils.removeCustomDomain(domain);
  }

  @override
  Future<void> toggleDomain(String domain, bool enabled) async {
    final current = await _datasource.getBlocklist();
    final updated = current.map((d) {
      if (d.domain == domain) {
        return BlockedDomainModel(
          domain: d.domain,
          category: d.category,
          isEnabled: enabled,
          isCustom: d.isCustom, // Keep original isCustom state
        );
      }
      return d;
    }).toList();
    await _datasource.saveBlocklist(updated);
    
    if (enabled) {
      await VpnUtils.removeCustomWhitelist(domain);
      await VpnUtils.addCustomDomain(domain);
    } else {
      await VpnUtils.removeCustomDomain(domain);
      await VpnUtils.addCustomWhitelist(domain);
    }
  }
}
