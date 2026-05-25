import 'package:equatable/equatable.dart';
import '../../domain/entities/installed_app_entity.dart';

abstract class AppSelectorState extends Equatable {
  const AppSelectorState();

  @override
  List<Object?> get props => [];
}

class AppSelectorInitial extends AppSelectorState {
  const AppSelectorInitial();
}

class AppSelectorLoading extends AppSelectorState {
  const AppSelectorLoading();
}

class AppSelectorLoaded extends AppSelectorState {
  const AppSelectorLoaded({
    required this.apps,
    required this.blockedPackages,
    this.searchQuery = '',
  });

  final List<InstalledAppEntity> apps;
  final List<String> blockedPackages;
  final String searchQuery;

  List<InstalledAppEntity> get filtered {
    if (searchQuery.isEmpty) return apps;
    final q = searchQuery.toLowerCase();
    return apps
        .where((a) =>
            a.appName.toLowerCase().contains(q) ||
            a.packageName.toLowerCase().contains(q))
        .toList();
  }

  int get blockedCount => blockedPackages.length;

  AppSelectorLoaded copyWith({
    List<InstalledAppEntity>? apps,
    List<String>? blockedPackages,
    String? searchQuery,
  }) {
    return AppSelectorLoaded(
      apps: apps ?? this.apps,
      blockedPackages: blockedPackages ?? this.blockedPackages,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [apps, blockedPackages, searchQuery];
}

class AppSelectorError extends AppSelectorState {
  const AppSelectorError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
