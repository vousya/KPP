// lib/presentation/login/google_login_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/auth_service.dart';

class GoogleLoginForm extends ConsumerStatefulWidget {
  final Function(bool) setLoading;
  const GoogleLoginForm({super.key, required this.setLoading});

  @override
  ConsumerState<GoogleLoginForm> createState() => _GoogleLoginFormState();
}

class _GoogleLoginFormState extends ConsumerState<GoogleLoginForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: GestureDetector(
          onTap: _signInWithGoogle,
          child: Image.asset(
            'assets/images/sign_in_with_google_dark.png',
            width: 212,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // ── Sign In with Google ─────────────────────────────────────────────
  Future<void> _signInWithGoogle() async {
    widget.setLoading(true);

    try {
      final user = await AuthService.instance.signInWithGoogle();
      if (user != null && mounted) {
        context.go('/main');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        widget.setLoading(false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}