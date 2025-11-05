import 'package:firebase_auth/firebase_auth.dart';
import '../core/analytics_wrapper.dart';

class PhoneAuth {
  // ── Verify Phone ─────────────────────────────────────────────────────
  static Future<void> verify({
    required String phone,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) onTimeout,
  }) =>
      AnalyticsWrapper.wrap(
        'phone_code_sent',
        {'phone': phone},
        () async {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phone.trim(),
            verificationCompleted: onVerificationCompleted,
            verificationFailed: onVerificationFailed,
            codeSent: onCodeSent,
            codeAutoRetrievalTimeout: onTimeout,
            timeout: const Duration(seconds: 60),
          );
        },
      );

  // ── Sign In with SMS Code ───────────────────────────────────────────
  static Future<User?> signInWithCredential(PhoneAuthCredential credential) =>
      AnalyticsWrapper.wrap(
        'phone_login',
        {},
        () async {
          final result = await FirebaseAuth.instance.signInWithCredential(credential);
          return result.user;
        },
      );

  // ── Create Credential (UI-safe helper) ─────────────────────────────
  static PhoneAuthCredential createCredential({
    required String verificationId,
    required String smsCode,
  }) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}