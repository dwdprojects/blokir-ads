// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../app_selector/presentation/cubit/app_selector_cubit.dart';
import '../../../app_selector/presentation/cubit/app_selector_state.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../cubit/ad_blocker_cubit.dart';
import '../cubit/ad_blocker_state.dart';
import '../widgets/blocker_toggle_widget.dart';
import '../widgets/blocker_stats_widget.dart';
import '../widgets/live_log_terminal.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

import '../../../../core/localization/app_strings.dart';

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
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 80,
      floating: true,
      backgroundColor: context.colors.background,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const .fromLTRB(20, 0, 20, 16),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: .circular(8),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 30,
                height: 30,
                fit: .cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  padding: const .all(6),
                  decoration: BoxDecoration(
                    gradient: context.colors.primaryGradient,
                    borderRadius: .circular(8),
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(AppStrings.of(context).appName, style: context.textStyles.titleLarge),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_rounded,
            color: context.colors.textSecondary,
          ),
          tooltip: 'Settings',
          onPressed: () => Navigator.pushNamed(context, '/settings'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final strings = AppStrings.of(context);
    final isGlobal = context.select<SettingsCubit, bool>(
      (c) => c.state.isGlobalProtection,
    );

    return BlocConsumer<AdBlockerCubit, AdBlockerState>(
      listener: (context, state) {
        if (state is AdBlockerPermissionRequired) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Izin VPN diperlukan'),
              backgroundColor: context.colors.warning,
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
            padding: .only(top: 120),
            child: LoadingWidget(message: 'Loading...'),
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

        final screenHeight = MediaQuery.sizeOf(context).height;
        final isCompact = screenHeight < 720;
        final spacingTop = isCompact ? 14.0 : 18.0;
        final spacingToggle = isCompact ? 16.0 : 24.0;
        final spacingStats = isCompact ? 16.0 : 24.0;
        final spacingCard = isCompact ? 12.0 : 16.0;
        final spacingTerminal = isCompact ? 14.0 : 18.0;
        final spacingBottom = isCompact ? 20.0 : 28.0;

        return Padding(
          padding: const .symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: spacingTop),
              _StatusBadge(isActive: isActive),
              SizedBox(height: spacingToggle),
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
                      isGlobalMode: isGlobal,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                isActive
                    ? strings.tapToDeactivate
                    : strings.tapToActivate,
                style: context.textStyles.bodySmall,
              ),
              SizedBox(height: spacingStats),
              BlocBuilder<AppSelectorCubit, AppSelectorState>(
                builder: (context, selectorState) {
                  final targetCount = selectorState is AppSelectorLoaded
                      ? selectorState.blockedCount
                      : 0;
                  return BlockerStatsWidget(
                    blockedCount: blockedCount,
                    uptime: uptime,
                    targetCount: targetCount,
                    isGlobalMode: isGlobal,
                  );
                },
              ),
              SizedBox(height: spacingCard),
              _ProtectionStatusCard(isGlobal: isGlobal),
              SizedBox(height: spacingTerminal),
              const LiveLogTerminalWidget(),
              SizedBox(height: spacingBottom),
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
      padding: const .symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? context.colors.active.withOpacity(0.12)
            : context.colors.inactive.withOpacity(0.1),
        borderRadius: .circular(20),
        border: Border.all(
          color: isActive
              ? context.colors.active.withOpacity(0.4)
              : context.colors.inactive.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: .circle,
              color: isActive ? context.colors.active : context.colors.inactive,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? AppStrings.of(context).protectionActive : AppStrings.of(context).protectionInactive,
            style: context.textStyles.labelSmall.copyWith(
              color: isActive ? context.colors.active : context.colors.inactive,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtectionStatusCard extends StatelessWidget {
  const _ProtectionStatusCard({required this.isGlobal});

  final bool isGlobal;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    if (isGlobal) {
      return Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: context.colors.primary.withOpacity(0.08),
          borderRadius: .circular(12),
          border: Border.all(color: context.colors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.security_rounded,
              color: context.colors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    strings.globalProtectionMode,
                    style: context.textStyles.labelLarge.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.globalProtectionActiveDesc,
                    style: context.textStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<AppSelectorCubit, AppSelectorState>(
      builder: (context, state) {
        final count = state is AppSelectorLoaded ? state.blockedCount : 0;
        if (count > 0) return const SizedBox.shrink();

        return Container(
          padding: const .all(16),
          decoration: BoxDecoration(
            color: context.colors.warning.withOpacity(0.08),
            borderRadius: .circular(12),
            border: Border.all(color: context.colors.warning.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: context.colors.warning,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  strings.noAppSelectedWarning,
                  style: context.textStyles.bodySmall.copyWith(
                    color: context.colors.warning,
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
