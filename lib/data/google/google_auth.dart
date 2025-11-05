// lib/data/auth/google/google_auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/analytics_wrapper.dart';

class GoogleAuth {
  static final _google = GoogleSignIn();

  static Future<User?> signIn() => AnalyticsWrapper.wrap(
        'google_login',
        {},
        () async {
          final googleUser = await _google.signIn();
          if (googleUser == null) throw FirebaseAuthException(code: 'ABORTED');

          final auth = await googleUser.authentication;
          final cred = GoogleAuthProvider.credential(
            accessToken: auth.accessToken,
            idToken: auth.idToken,
          );
          final result = await FirebaseAuth.instance.signInWithCredential(cred);
          return result.user;
        },
      );
}