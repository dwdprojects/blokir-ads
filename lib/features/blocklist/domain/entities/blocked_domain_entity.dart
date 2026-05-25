import 'package:equatable/equatable.dart';

class BlockedDomainEntity extends Equatable {
  const BlockedDomainEntity({
    required this.domain,
    required this.category,
    required this.isEnabled,
    this.isCustom = false,
  });

  final String domain;
  final String category;
  final bool isEnabled;
  final bool isCustom;

  BlockedDomainEntity copyWith({
    String? domain,
    String? category,
    bool? isEnabled,
    bool? isCustom,
  }) {
    return BlockedDomainEntity(
      domain: domain ?? this.domain,
      category: category ?? this.category,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [domain, category, isEnabled, isCustom];
}
