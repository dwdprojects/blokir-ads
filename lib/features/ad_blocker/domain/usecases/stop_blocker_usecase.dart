import '../repositories/ad_blocker_repository.dart';

class StopBlockerUsecase {
  StopBlockerUsecase(this._repository);

  final AdBlockerRepository _repository;

  Future<bool> call() async => _repository.stopBlocker();
}
