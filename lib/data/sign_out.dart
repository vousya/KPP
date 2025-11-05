// lib/data/auth/common/sign_out.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AuthSignOut {
  static Future<void> execute() async {
    await Future.wait([
      FirebaseAuth.instance.signOut(),
      GoogleSignIn().signOut(),
    ]);
    await FirebaseAnalytics.instance.logEvent(name: 'sign_out');
  }
}