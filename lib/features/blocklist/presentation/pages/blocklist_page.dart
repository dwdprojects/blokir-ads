// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/blocklist_cubit.dart';
import '../cubit/blocklist_state.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

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
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text('Blocklist Domain', style: context.textStyles.titleLarge),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: context.colors.primary,
            ),
            onPressed: _showAddDomainDialog,
            tooltip: 'Tambah domain',
          ),
          SizedBox(width: 8),
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
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        title: Text('Tambah Domain', style: context.textStyles.titleMedium),
        content: TextField(
          controller: _addController,
          style: context.textStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: 'contoh: ads.example.com',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: context.textStyles.labelLarge.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.background,
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            ),
            onPressed: () {
              final domain = _addController.text.trim();
              if (domain.isNotEmpty) {
                context.read<BlocklistCubit>().addCustomDomain(domain);
                Navigator.pop(ctx);
              }
            },
            child: Text('Tambah'),
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
      padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: controller,
        onChanged: context.read<BlocklistCubit>().search,
        style: context.textStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Cari domain...',
          prefixIcon: Icon(
            Icons.search,
            color: context.colors.textHint,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: context.colors.textHint,
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
        if (state is! BlocklistLoaded) return SizedBox.shrink();
        final categories = ['Semua', ...state.categories];

        return SizedBox(
          height: 44,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: .horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = categories[i];
              final isAll = cat == 'Semua';
              final isSelected = isAll
                  ? state.selectedCategory == null
                  : state.selectedCategory == cat;

              return FilterChip(
                label: Text(cat, style: context.textStyles.labelSmall),
                selected: isSelected,
                onSelected: (_) => context
                    .read<BlocklistCubit>()
                    .filterByCategory(isAll ? null : cat),
                selectedColor: context.colors.primary.withOpacity(0.18),
                checkmarkColor: context.colors.primary,
                backgroundColor: context.colors.surfaceVariant,
                side: BorderSide(
                  color: isSelected
                      ? context.colors.primary.withOpacity(0.5)
                      : context.colors.border,
                ),
                padding: EdgeInsets.symmetric(horizontal: 4),
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
          return LoadingWidget(message: 'Memuat blocklist...');
        }
        if (state is BlocklistError) {
          return Center(
            child: Text(state.message, style: context.textStyles.bodyMedium),
          );
        }
        if (state is BlocklistLoaded) {
          final domains = state.filtered;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Text(
                      '${domains.length} domain',
                      style: context.textStyles.bodySmall,
                    ),
                    Spacer(),
                    Text(
                      '${state.enabledCount} aktif · ${state.customCount} custom',
                      style: context.textStyles.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: domains.length,
                  separatorBuilder: (_, __) => SizedBox(height: 4),
                  itemBuilder: (context, i) {
                    final d = domains[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: .circular(10),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(d.domain, style: context.textStyles.bodyMedium),
                        subtitle: Text(
                          d.category,
                          style: context.textStyles.caption,
                        ),
                        leading: Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: d.isEnabled
                                ? context.colors.active
                                : context.colors.textHint,
                          ),
                        ),
                        trailing: d.isCustom
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: context.colors.inactive,
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
        return SizedBox.shrink();
      },
    );
  }
}
