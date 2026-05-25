import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart';
import 'features/ad_blocker/presentation/cubit/ad_blocker_cubit.dart';
import 'features/app_selector/presentation/cubit/app_selector_cubit.dart';
import 'features/blocklist/presentation/cubit/blocklist_cubit.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdBlockerCubit>(create: (_) => sl<AdBlockerCubit>()),
        BlocProvider<AppSelectorCubit>(create: (_) => sl<AppSelectorCubit>()),
        BlocProvider<BlocklistCubit>(create: (_) => sl<BlocklistCubit>()),
      ],
      child: MaterialApp(
        title: 'Blokir Ads',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/home',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
