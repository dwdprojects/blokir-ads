// ignore_for_file: prefer_initializing_formals

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
  }

  @override
  Future<void> removeDomain(String domain) async {
    final current = await _datasource.getBlocklist();
    final updated = current.where((d) => d.domain != domain).toList();
    await _datasource.saveBlocklist(updated);
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
          isCustom: d.isCustom,
        );
      }
      return d;
    }).toList();
    await _datasource.saveBlocklist(updated);
  }
}
