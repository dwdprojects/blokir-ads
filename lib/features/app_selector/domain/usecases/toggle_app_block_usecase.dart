import '../repositories/app_selector_repository.dart';

class ToggleAppBlockUsecase {
  ToggleAppBlockUsecase(this._repository);

  final AppSelectorRepository _repository;

  Future<List<String>> call({
    required String packageName,
    required bool block,
  }) async {
    final current = await _repository.getBlockedPackages();
    final updated = List<String>.from(current);

    if (block) {
      if (!updated.contains(packageName)) updated.add(packageName);
    } else {
      updated.remove(packageName);
    }

    await _repository.saveBlockedPackages(updated);
    return updated;
  }
}
