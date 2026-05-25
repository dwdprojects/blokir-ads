// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/app_selector_cubit.dart';
import '../cubit/app_selector_state.dart';
import '../widgets/app_list_tile.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pilih Aplikasi', style: AppTextStyles.titleLarge),
        actions: [
          BlocBuilder<AppSelectorCubit, AppSelectorState>(
            builder: (context, state) {
              if (state is AppSelectorLoaded) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Chip(
                    label: Text(
                      '${state.blockedCount} diblokir',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.active,
                      ),
                    ),
                    backgroundColor: AppColors.active.withOpacity(0.12),
                    side: BorderSide(
                      color: AppColors.active.withOpacity(0.3),
                      width: 1,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(controller: _searchController),
          Expanded(
            child: BlocBuilder<AppSelectorCubit, AppSelectorState>(
              builder: (context, state) {
                if (state is AppSelectorLoading) {
                  return const LoadingWidget(
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
                  final apps = state.filtered;
                  if (apps.isEmpty) {
                    return _EmptyView(query: state.searchQuery);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24, top: 8),
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
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: context.read<AppSelectorCubit>().search,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Cari aplikasi...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textHint),
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
          const Icon(Icons.error_outline, color: AppColors.inactive, size: 56),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyles.bodyMedium, textAlign: .center),
          const SizedBox(height: 24),
          TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
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
          const Icon(Icons.apps_outlined, color: AppColors.textHint, size: 56),
          const SizedBox(height: 16),
          Text(
            query.isEmpty
                ? 'Tidak ada aplikasi ditemukan'
                : 'Tidak ada hasil untuk "$query"',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
