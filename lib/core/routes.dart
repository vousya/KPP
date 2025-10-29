import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../presentation/main/main_page.dart';
import '../presentation/login/login_page.dart';
import '../presentation/add_product/add_product_page.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

final GoRouter router = GoRouter(
  observers: [
    FirebaseAnalyticsObserver(analytics: analytics),
  ],
  routes: [
    GoRoute(
      path: '/',
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
  ],
);
