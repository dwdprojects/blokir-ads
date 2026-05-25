// ignore_for_file: prefer_initializing_formals

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/blocked_domain_entity.dart';
import '../../domain/usecases/blocklist_usecases.dart';
import 'blocklist_state.dart';

class BlocklistCubit extends Cubit<BlocklistState> {
  BlocklistCubit({
    required GetBlocklistUsecase getBlocklist,
    required AddDomainUsecase addDomain,
    required RemoveDomainUsecase removeDomain,
  }) : _getBlocklist = getBlocklist,
       _addDomain = addDomain,
       _removeDomain = removeDomain,
       super(const BlocklistInitial());

  final GetBlocklistUsecase _getBlocklist;
  final AddDomainUsecase _addDomain;
  final RemoveDomainUsecase _removeDomain;

  Future<void> loadBlocklist() async {
    emit(const BlocklistLoading());
    try {
      final domains = await _getBlocklist();
      emit(BlocklistLoaded(domains: domains));
    } catch (e) {
      emit(BlocklistError('Gagal memuat blocklist: $e'));
    }
  }

  Future<void> addCustomDomain(String domain) async {
    final entity = BlockedDomainEntity(
      domain: domain.trim().toLowerCase(),
      category: 'Custom',
      isEnabled: true,
      isCustom: true,
    );
    await _addDomain(entity);
    await loadBlocklist();
  }

  Future<void> removeDomain(String domain) async {
    await _removeDomain(domain);
    await loadBlocklist();
  }

  void search(String query) {
    final current = state;
    if (current is BlocklistLoaded) {
      emit(current.copyWith(searchQuery: query));
    }
  }

  void filterByCategory(String? category) {
    final current = state;
    if (current is BlocklistLoaded) {
      emit(
        current.copyWith(
          selectedCategory: category,
          clearCategory: category == null,
        ),
      );
    }
  }
}
