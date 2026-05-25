import 'package:equatable/equatable.dart';

class BlockerStatusEntity extends Equatable {
  const BlockerStatusEntity({
    required this.isActive,
    required this.blockedCount,
    required this.uptime,
    required this.targetPackages,
  });

  final bool isActive;
  final int blockedCount;
  final Duration uptime;
  final List<String> targetPackages;

  BlockerStatusEntity copyWith({
    bool? isActive,
    int? blockedCount,
    Duration? uptime,
    List<String>? targetPackages,
  }) {
    return BlockerStatusEntity(
      isActive: isActive ?? this.isActive,
      blockedCount: blockedCount ?? this.blockedCount,
      uptime: uptime ?? this.uptime,
      targetPackages: targetPackages ?? this.targetPackages,
    );
  }

  static BlockerStatusEntity get initial => const BlockerStatusEntity(
        isActive: false,
        blockedCount: 0,
        uptime: Duration.zero,
        targetPackages: [],
      );

  @override
  List<Object?> get props => [isActive, blockedCount, uptime, targetPackages];
}
