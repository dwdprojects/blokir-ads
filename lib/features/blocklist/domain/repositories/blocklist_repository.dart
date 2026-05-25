import '../entities/blocked_domain_entity.dart';

abstract class BlocklistRepository {
  Future<List<BlockedDomainEntity>> getBlocklist();
  Future<void> addDomain(BlockedDomainEntity domain);
  Future<void> removeDomain(String domain);
  Future<void> toggleDomain(String domain, bool enabled);
}
