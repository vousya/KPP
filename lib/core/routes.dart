import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers/auth_provider.dart';

import '../presentation/shopping/shopping_list/widgets/shopping_item.dart';

import '../presentation/shopping/add_product/add_product_page.dart';
import '../presentation/login/login_page.dart';
import '../presentation/shopping/shopping_list/shopping_list_page.dart';
import '../presentation/notifications/notification_page.dart';
import '../presentation/settings/settings_page.dart';
import '../presentation/shopping/shopping_lists/shopping_lists_page.dart';


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
        path: '/lists',
        builder: (context, state) => const ShoppingListsPage(),
      ),
      GoRoute(
        path: '/lists/:listId',
        builder: (context, state) {
          final listId = state.pathParameters['listId']!;
          
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final listTitle = extra['title'] as String? ?? 'Shopping List';
          final items = extra['items'] as List<ShoppingItem>? ?? [];

          return ShoppingListPage(
            listId: listId,
            listTitle: listTitle,
            items: items,
          );
        },
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

      if (loggedIn && goingToLogin) return '/lists';
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
