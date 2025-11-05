import 'package:firebase_auth/firebase_auth.dart';
import 'email/email_auth.dart';
import 'phone/phone_auth.dart';
import 'google/google_auth.dart';
import 'sign_out.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  // Core
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // Email
  Future<User?> signInWithEmail({required String email, required String password}) =>
      EmailAuth.signIn(email: email, password: password);

  // Phone
  Future<void> verifyPhoneNumber({
    required String phone,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) onTimeout,
  }) =>
      PhoneAuth.verify(
        phone: phone,
        onVerificationCompleted: onVerificationCompleted,
        onVerificationFailed: onVerificationFailed,
        onCodeSent: onCodeSent,
        onTimeout: onTimeout,
      );

  Future<User?> signInWithPhoneCredential(PhoneAuthCredential credential) =>
      PhoneAuth.signInWithCredential(credential);

  // Google
  Future<User?> signInWithGoogle() => GoogleAuth.signIn();

  // Sign Out
  Future<void> signOut() => AuthSignOut.execute();
}