import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import '../core/analytics_wrapper.dart';

class GoogleAuth {
  static final _googleSignIn = GoogleSignIn();

  static Future<User?> signIn() => AnalyticsWrapper.wrap(
        'google_login',
        {},
        () async {
          try {
            if (kIsWeb) {
              // ── WEB: Use Firebase signInWithPopup (no plugin needed) ──
              final GoogleAuthProvider googleProvider = GoogleAuthProvider();
              googleProvider.addScope('email');
              googleProvider.addScope('profile');

              final UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithPopup(googleProvider);

              return userCredential.user;
            } else {
              // ── MOBILE: Use google_sign_in plugin ──
              final googleUser = await _googleSignIn.signIn();
              if (googleUser == null) {
                throw FirebaseAuthException(
                  code: 'ABORTED',
                  message: 'Sign in aborted by user',
                );
              }

              final auth = await googleUser.authentication;
              final cred = GoogleAuthProvider.credential(
                accessToken: auth.accessToken,
                idToken: auth.idToken,
              );

              final result =
                  await FirebaseAuth.instance.signInWithCredential(cred);
              return result.user;
            }
          } on FirebaseAuthException catch (e) {
            // Re-throw known exceptions
            rethrow;
          } catch (e) {
            // Wrap unexpected errors
            throw FirebaseAuthException(
              code: 'UNKNOWN',
              message: 'Google sign-in failed: $e',
            );
          }
        },
      );
}