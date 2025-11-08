import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/add_product/add_product_page.dart';
import '../presentation/login/login_page.dart';
import '../presentation/main/main_page.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/notifications/notification_page.dart';
import '../presentation/settings/settings_page.dart';


final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/product',
        builder: (context, state) => const AddEditProductPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authState.valueOrNull != null;
      final goingToLogin = state.matchedLocation == '/login';

      if (loggedIn && goingToLogin) return '/main';
      if (!loggedIn && !goingToLogin) return '/login';
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.stream),
    ),
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
