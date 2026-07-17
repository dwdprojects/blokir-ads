// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/app_selector_cubit.dart';
import '../cubit/app_selector_state.dart';
import '../widgets/app_list_tile.dart';
import '../../domain/entities/installed_app_entity.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

import '../../../../core/localization/app_strings.dart';

class AppSelectorPage extends StatefulWidget {
  const AppSelectorPage({super.key});

  static const routeName = '/app-selector';

  @override
  State<AppSelectorPage> createState() => _AppSelectorPageState();
}

class _AppSelectorPageState extends State<AppSelectorPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AppSelectorCubit>().loadApps();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: Text(strings.selectApp, style: context.textStyles.titleLarge),
          actions: [
            BlocBuilder<AppSelectorCubit, AppSelectorState>(
              builder: (context, state) {
                if (state is AppSelectorLoaded) {
                  return Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Chip(
                      label: Text(
                        '${state.blockedCount} ${strings.blocked}',
                        style: context.textStyles.labelSmall.copyWith(
                          color: context.colors.active,
                        ),
                      ),
                      backgroundColor: context.colors.active.withOpacity(0.12),
                      side: BorderSide(
                        color: context.colors.active.withOpacity(0.3),
                        width: 1,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _SearchBar(controller: _searchController),
            TabBar(
              indicatorColor: context.colors.primary,
              labelColor: context.colors.textPrimary,
              unselectedLabelColor: context.colors.textHint,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: context.colors.divider,
              labelStyle: context.textStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: context.textStyles.bodyMedium,
              tabs: [
                Tab(text: strings.allApps),
                Tab(text: strings.restrictedApps),
              ],
            ),
            Expanded(
              child: BlocBuilder<AppSelectorCubit, AppSelectorState>(
                builder: (context, state) {
                  if (state is AppSelectorLoading) {
                    return LoadingWidget(
                      message: 'Memuat daftar aplikasi...',
                    );
                  }
                  if (state is AppSelectorError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () => context.read<AppSelectorCubit>().loadApps(),
                    );
                  }
                  if (state is AppSelectorLoaded) {
                    final allApps = state.filtered;
                    final restrictedApps = allApps
                        .where((app) => state.blockedPackages.contains(app.packageName))
                        .toList();

                    return TabBarView(
                      children: [
                        _buildAppList(allApps, state.searchQuery),
                        _buildAppList(restrictedApps, state.searchQuery),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppList(List<InstalledAppEntity> apps, String query) {
    if (apps.isEmpty) {
      return _EmptyView(query: query);
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 24, top: 8),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return AppListTile(
          app: app,
          onToggle: (val) => context
              .read<AppSelectorCubit>()
              .toggleBlock(app.packageName, val),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: context.read<AppSelectorCubit>().search,
        style: context.textStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: strings.searchApp,
          prefixIcon: Icon(Icons.search, color: context.colors.textHint),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: context.colors.textHint),
                  onPressed: () {
                    controller.clear();
                    context.read<AppSelectorCubit>().search('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(Icons.error_outline, color: context.colors.inactive, size: 56),
          SizedBox(height: 16),
          Text(message, style: context.textStyles.bodyMedium, textAlign: .center),
          SizedBox(height: 24),
          TextButton(onPressed: onRetry, child: Text('Coba Lagi')),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(Icons.apps_outlined, color: context.colors.textHint, size: 56),
          SizedBox(height: 16),
          Text(
            query.isEmpty
                ? 'Tidak ada aplikasi ditemukan'
                : 'Tidak ada hasil untuk "$query"',
            style: context.textStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
