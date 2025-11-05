// lib/data/auth/email/email_auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../core/analytics_wrapper.dart';

class EmailAuth {
  static Future<User?> signIn({
    required String email,
    required String password,
  }) =>
      AnalyticsWrapper.wrap(
        'email_login',
        {'email': email},
        () async {
          final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
          return cred.user;
        },
      );
}