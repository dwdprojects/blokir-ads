// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/blocklist_cubit.dart';
import '../cubit/blocklist_state.dart';

class BlocklistPage extends StatefulWidget {
  const BlocklistPage({super.key});

  static const routeName = '/blocklist';

  @override
  State<BlocklistPage> createState() => _BlocklistPageState();
}

class _BlocklistPageState extends State<BlocklistPage> {
  final _searchController = TextEditingController();
  final _addController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BlocklistCubit>().loadBlocklist();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Blocklist Domain', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
            onPressed: _showAddDomainDialog,
            tooltip: 'Tambah domain',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(controller: _searchController),
          _CategoryFilter(),
          Expanded(child: _BlocklistContent()),
        ],
      ),
    );
  }

  void _showAddDomainDialog() {
    _addController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        title: Text('Tambah Domain', style: AppTextStyles.titleMedium),
        content: TextField(
          controller: _addController,
          style: AppTextStyles.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'contoh: ads.example.com',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            ),
            onPressed: () {
              final domain = _addController.text.trim();
              if (domain.isNotEmpty) {
                context.read<BlocklistCubit>().addCustomDomain(domain);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Tambah'),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: controller,
        onChanged: context.read<BlocklistCubit>().search,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Cari domain...',
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textHint,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textHint,
                    size: 18,
                  ),
                  onPressed: () {
                    controller.clear();
                    context.read<BlocklistCubit>().search('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocklistCubit, BlocklistState>(
      builder: (context, state) {
        if (state is! BlocklistLoaded) return const SizedBox.shrink();
        final categories = ['Semua', ...state.categories];

        return SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: .horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = categories[i];
              final isAll = cat == 'Semua';
              final isSelected = isAll
                  ? state.selectedCategory == null
                  : state.selectedCategory == cat;

              return FilterChip(
                label: Text(cat, style: AppTextStyles.labelSmall),
                selected: isSelected,
                onSelected: (_) => context
                    .read<BlocklistCubit>()
                    .filterByCategory(isAll ? null : cat),
                selectedColor: AppColors.primary.withOpacity(0.18),
                checkmarkColor: AppColors.primary,
                backgroundColor: AppColors.surfaceVariant,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.5)
                      : AppColors.border,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              );
            },
          ),
        );
      },
    );
  }
}

class _BlocklistContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocklistCubit, BlocklistState>(
      builder: (context, state) {
        if (state is BlocklistLoading) {
          return const LoadingWidget(message: 'Memuat blocklist...');
        }
        if (state is BlocklistError) {
          return Center(
            child: Text(state.message, style: AppTextStyles.bodyMedium),
          );
        }
        if (state is BlocklistLoaded) {
          final domains = state.filtered;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Text(
                      '${domains.length} domain',
                      style: AppTextStyles.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      '${state.enabledCount} aktif · ${state.customCount} custom',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: domains.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, i) {
                    final d = domains[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: .circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(d.domain, style: AppTextStyles.bodyMedium),
                        subtitle: Text(
                          d.category,
                          style: AppTextStyles.caption,
                        ),
                        leading: Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: d.isEnabled
                                ? AppColors.active
                                : AppColors.textHint,
                          ),
                        ),
                        trailing: d.isCustom
                            ? IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.inactive,
                                  size: 18,
                                ),
                                onPressed: () => context
                                    .read<BlocklistCubit>()
                                    .removeDomain(d.domain),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
