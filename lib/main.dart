// lib/main.dart
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Commented out if you migrated to Firebase

import 'firebase_options.dart';
import 'core/routes.dart';

Future<void> main() async {
  // 1. Initialize Bindings First
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Initialize Supabase (Optional: Only if you still use it for something)
  // If you fully migrated to Firebase, you can remove this block.
  /* 
  await Supabase.initialize(
    url: 'https://cbhvhxfotdidsdcwmtou.supabase.co', 
    anonKey: 'sb_publishable_KXXNQJii_5y8YElNyZ3MGw_nYGKVTvb', 
  );
  */

  // 4. Initialize Sentry and Run App
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://be01b873dd4dc7402ce0ee0bb8edf9df@o4510257259282432.ingest.de.sentry.io/4510257261117520';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      // Helpful for debugging Web Zone issues
      options.debug = false; 
    },
    appRunner: () => runApp(
      // 5. ProviderScope must be at the top to hold state
      ProviderScope(
        child: DevicePreview(
          enabled: !kReleaseMode,
          // SentryWidget is optional, removed to simplify the tree and avoid zone conflicts
          builder: (context) => const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Shopping Manager',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // DevicePreview configuration
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}