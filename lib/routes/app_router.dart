// ignore_for_file: duplicate_ignore, unnecessary_underscores

import 'package:flutter/material.dart';
import '../features/ad_blocker/presentation/pages/ad_blocker_home_page.dart';
import '../features/app_selector/presentation/pages/app_selector_page.dart';
import '../features/blocklist/presentation/pages/blocklist_page.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AdBlockerHomePage.routeName:
        return _fade(const AdBlockerHomePage());

      case AppSelectorPage.routeName:
        return _slide(const AppSelectorPage());

      case BlocklistPage.routeName:
        return _slide(const BlocklistPage());

      default:
        return _fade(const AdBlockerHomePage());
    }
  }

  static PageRouteBuilder<dynamic> _fade(Widget page) {
    return PageRouteBuilder(
      // ignore: unnecessary_underscores
      pageBuilder: (context, _, __) => page,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  static PageRouteBuilder<dynamic> _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => page,
      transitionsBuilder: (context, animation, _, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return SlideTransition(position: offset, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
