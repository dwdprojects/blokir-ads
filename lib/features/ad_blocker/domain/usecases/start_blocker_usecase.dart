import '../repositories/ad_blocker_repository.dart';

class StartBlockerUsecase {
  StartBlockerUsecase(this._repository);

  final AdBlockerRepository _repository;

  Future<bool> call({required List<String> targetPackages}) async {
    return _repository.startBlocker(targetPackages: targetPackages);
  }
}
