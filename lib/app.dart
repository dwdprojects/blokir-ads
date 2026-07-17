import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart';
import 'features/ad_blocker/presentation/cubit/ad_blocker_cubit.dart';
import 'features/app_selector/presentation/cubit/app_selector_cubit.dart';
import 'features/blocklist/presentation/cubit/blocklist_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'routes/app_router.dart';

import 'core/localization/app_strings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdBlockerCubit>(create: (_) => sl<AdBlockerCubit>()),
        BlocProvider<AppSelectorCubit>(create: (_) => sl<AppSelectorCubit>()),
        BlocProvider<BlocklistCubit>(create: (_) => sl<BlocklistCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          ThemeMode appThemeMode = ThemeMode.system;
          if (settingsState.themeMode == AppThemeMode.light) {
            appThemeMode = ThemeMode.light;
          } else if (settingsState.themeMode == AppThemeMode.dark) {
            appThemeMode = ThemeMode.dark;
          }

          return MaterialApp(
            title: AppStrings.of(context).appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appThemeMode,
            initialRoute: '/home',
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
