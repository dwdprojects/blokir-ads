// ignore_for_file: prefer_initializing_formals

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/blocklist_constants.dart';
import '../models/blocked_domain_model.dart';

abstract class BlocklistLocalDatasource {
  Future<List<BlockedDomainModel>> getBlocklist();
  Future<void> saveBlocklist(List<BlockedDomainModel> domains);
}

class BlocklistLocalDatasourceImpl implements BlocklistLocalDatasource {
  BlocklistLocalDatasourceImpl({required SharedPreferences prefs})
    : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<List<BlockedDomainModel>> getBlocklist() async {
    final customRaw = _prefs.getString(AppConstants.keyCustomBlocklist);
    final customList = customRaw != null
        ? (jsonDecode(customRaw) as List)
              .map(
                (e) => BlockedDomainModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList()
        : <BlockedDomainModel>[];

    final builtIn = _buildDefaultList();

    // Merge: built-in first, custom appended
    final merged = [...builtIn];
    for (final custom in customList) {
      if (!merged.any((d) => d.domain == custom.domain)) {
        merged.add(custom);
      }
    }
    return merged;
  }

  @override
  Future<void> saveBlocklist(List<BlockedDomainModel> domains) async {
    final customOnly = domains.where((d) => d.isCustom).toList();
    await _prefs.setString(
      AppConstants.keyCustomBlocklist,
      jsonEncode(customOnly.map((d) => d.toJson()).toList()),
    );
  }

  List<BlockedDomainModel> _buildDefaultList() {
    return BlocklistConstants.domainsByCategory.entries
        .expand(
          (entry) => entry.value.map(
            (domain) => BlockedDomainModel(
              domain: domain,
              category: entry.key,
              isEnabled: true,
              isCustom: false,
            ),
          ),
        )
        .toList();
  }
}
