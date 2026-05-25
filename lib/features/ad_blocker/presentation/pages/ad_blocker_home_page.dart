// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../app_selector/presentation/cubit/app_selector_cubit.dart';
import '../../../app_selector/presentation/cubit/app_selector_state.dart';
import '../cubit/ad_blocker_cubit.dart';
import '../cubit/ad_blocker_state.dart';
import '../widgets/blocker_toggle_widget.dart';
import '../widgets/blocker_stats_widget.dart';
import '../widgets/live_log_terminal.dart';

class AdBlockerHomePage extends StatefulWidget {
  const AdBlockerHomePage({super.key});

  static const routeName = '/home';

  @override
  State<AdBlockerHomePage> createState() => _AdBlockerHomePageState();
}

class _AdBlockerHomePageState extends State<AdBlockerHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AdBlockerCubit>().loadStatus();
    context.read<AppSelectorCubit>().loadApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text('Blokir Ads', style: AppTextStyles.titleLarge),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.list_alt_rounded,
            color: AppColors.textSecondary,
          ),
          tooltip: 'Blocklist',
          onPressed: () => Navigator.pushNamed(context, '/blocklist'),
        ),
        IconButton(
          icon: const Icon(Icons.apps_rounded, color: AppColors.textSecondary),
          tooltip: 'Pilih Aplikasi',
          onPressed: () => Navigator.pushNamed(context, '/app-selector'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return BlocConsumer<AdBlockerCubit, AdBlockerState>(
      listener: (context, state) {
        if (state is AdBlockerPermissionRequired) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin VPN diperlukan untuk memblokir iklan'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        if (state is AdBlockerError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AdBlockerInitial) {
          return const Padding(
            padding: EdgeInsets.only(top: 120),
            child: LoadingWidget(message: 'Memuat status...'),
          );
        }

        final isActive = state is AdBlockerActive;
        final isLoading = state is AdBlockerLoading;
        final blockedCount = state is AdBlockerActive
            ? state.status.blockedCount
            : 0;
        final uptime = state is AdBlockerActive
            ? state.status.uptime
            : Duration.zero;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _StatusBadge(isActive: isActive),
              const SizedBox(height: 40),
              BlocBuilder<AppSelectorCubit, AppSelectorState>(
                builder: (context, selectorState) {
                  final targetPackages = selectorState is AppSelectorLoaded
                      ? selectorState.blockedPackages
                      : <String>[];

                  return BlockerToggleWidget(
                    isActive: isActive,
                    isLoading: isLoading,
                    onTap: () => context.read<AdBlockerCubit>().toggleBlocker(
                      targetPackages: targetPackages,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                isActive
                    ? 'Ketuk untuk menonaktifkan'
                    : 'Ketuk untuk mengaktifkan',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 40),
              BlocBuilder<AppSelectorCubit, AppSelectorState>(
                builder: (context, selectorState) {
                  final targetCount = selectorState is AppSelectorLoaded
                      ? selectorState.blockedCount
                      : 0;
                  return BlockerStatsWidget(
                    blockedCount: blockedCount,
                    uptime: uptime,
                    targetCount: targetCount,
                  );
                },
              ),
              const SizedBox(height: 32),
              if (!isActive) _NoAppWarning(),
              const SizedBox(height: 24),
              const LiveLogTerminalWidget(),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.active.withOpacity(0.12)
            : AppColors.inactive.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.active.withOpacity(0.4)
              : AppColors.inactive.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.active : AppColors.inactive,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? 'Perlindungan Aktif' : 'Perlindungan Tidak Aktif',
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? AppColors.active : AppColors.inactive,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoAppWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSelectorCubit, AppSelectorState>(
      builder: (context, state) {
        final count = state is AppSelectorLoaded ? state.blockedCount : 0;
        if (count > 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Belum ada aplikasi dipilih. Pilih aplikasi target agar blokir iklan berjalan.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
