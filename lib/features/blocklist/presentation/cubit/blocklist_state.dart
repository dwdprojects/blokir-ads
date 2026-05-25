import 'package:equatable/equatable.dart';
import '../../domain/entities/blocked_domain_entity.dart';

abstract class BlocklistState extends Equatable {
  const BlocklistState();

  @override
  List<Object?> get props => [];
}

class BlocklistInitial extends BlocklistState {
  const BlocklistInitial();
}

class BlocklistLoading extends BlocklistState {
  const BlocklistLoading();
}

class BlocklistLoaded extends BlocklistState {
  const BlocklistLoaded({
    required this.domains,
    this.searchQuery = '',
    this.selectedCategory,
  });

  final List<BlockedDomainEntity> domains;
  final String searchQuery;
  final String? selectedCategory;

  List<BlockedDomainEntity> get filtered {
    var result = domains;
    if (selectedCategory != null) {
      result = result.where((d) => d.category == selectedCategory).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((d) => d.domain.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  List<String> get categories =>
      domains.map((d) => d.category).toSet().toList()..sort();

  int get enabledCount => domains.where((d) => d.isEnabled).length;
  int get customCount => domains.where((d) => d.isCustom).length;

  BlocklistLoaded copyWith({
    List<BlockedDomainEntity>? domains,
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
  }) {
    return BlocklistLoaded(
      domains: domains ?? this.domains,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
    );
  }

  @override
  List<Object?> get props => [domains, searchQuery, selectedCategory];
}

class BlocklistError extends BlocklistState {
  const BlocklistError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
