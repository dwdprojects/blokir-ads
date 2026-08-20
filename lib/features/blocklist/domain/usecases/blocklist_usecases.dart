import '../entities/blocked_domain_entity.dart';
import '../repositories/blocklist_repository.dart';

class GetBlocklistUsecase {
  GetBlocklistUsecase(this._repository);
  final BlocklistRepository _repository;

  Future<List<BlockedDomainEntity>> call() => _repository.getBlocklist();
}

class AddDomainUsecase {
  AddDomainUsecase(this._repository);
  final BlocklistRepository _repository;

  Future<void> call(BlockedDomainEntity domain) =>
      _repository.addDomain(domain);
}

class RemoveDomainUsecase {
  RemoveDomainUsecase(this._repository);
  final BlocklistRepository _repository;

  Future<void> call(String domain) => _repository.removeDomain(domain);
}

class ToggleDomainUsecase {
  ToggleDomainUsecase(this._repository);
  final BlocklistRepository _repository;

  Future<void> call(String domain, {required bool isEnabled}) =>
      _repository.toggleDomain(domain, isEnabled);
}
