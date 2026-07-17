import '../entities/blocker_status_entity.dart';

abstract class AdBlockerRepository {
  Future<bool> startBlocker({required List<String> targetPackages});
  Future<bool> stopBlocker();
  Future<BlockerStatusEntity> getStatus();
  Future<bool> requestPermission();
  Stream<String> get logStream;
  Stream<bool> get statusStream;
  Future<bool> addCustomDomain(String domain);
}
