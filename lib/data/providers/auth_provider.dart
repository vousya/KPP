import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


final authServiceProvider = Provider<AuthService>((_) => AuthService.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});