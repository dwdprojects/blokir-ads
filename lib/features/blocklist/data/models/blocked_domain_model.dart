import '../../domain/entities/blocked_domain_entity.dart';

class BlockedDomainModel extends BlockedDomainEntity {
  const BlockedDomainModel({
    required super.domain,
    required super.category,
    required super.isEnabled,
    super.isCustom,
  });

  factory BlockedDomainModel.fromJson(Map<String, dynamic> json) {
    return BlockedDomainModel(
      domain: json['domain'] as String,
      category: json['category'] as String,
      isEnabled: json['isEnabled'] as bool? ?? true,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'category': category,
      'isEnabled': isEnabled,
      'isCustom': isCustom,
    };
  }
}
