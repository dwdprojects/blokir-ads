import '../entities/blocker_status_entity.dart';
import '../repositories/ad_blocker_repository.dart';

class GetBlockerStatusUsecase {
  GetBlockerStatusUsecase(this._repository);

  final AdBlockerRepository _repository;

  Future<BlockerStatusEntity> call() async => _repository.getStatus();
}
