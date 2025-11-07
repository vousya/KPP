// lib/presentation/login/phone_login_form.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/auth/auth_service.dart';
import '../../../data/auth/phone/phone_auth.dart';
import '../../../domain/validators/phone_validator.dart';

class PhoneLoginForm extends ConsumerStatefulWidget {
  final Function(bool) setLoading;
  const PhoneLoginForm({super.key, required this.setLoading});

  @override
  ConsumerState<PhoneLoginForm> createState() => _PhoneLoginFormState();
}

class _PhoneLoginFormState extends ConsumerState<PhoneLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(hintText: "+1234567890"),
              keyboardType: TextInputType.phone,
              validator: PhoneValidator.validate,
            ),
            if (_verificationId != null) ...[
              const SizedBox(height: 10),
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(hintText: "Verification Code"),
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verificationId == null ? _sendCode : _verifyCode,
              child: Text(_verificationId == null ? "Send Code" : "Verify Code"),
            ),
          ],
        ),
      ),
    );
  }

  // ── Send SMS Code ───────────────────────────────────────────────────
  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    widget.setLoading(true);

    await AuthService.instance.verifyPhoneNumber(
      phone: _phoneCtrl.text,
      onVerificationCompleted: (cred) => _signIn(cred),
      onVerificationFailed: (e) => _showError(e.message ?? 'Verification failed'),
      onCodeSent: (id, _) {
        setState(() => _verificationId = id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent')),
        );
      },
      onTimeout: (_) {},
    );

    widget.setLoading(false);
  }

  // ── Verify SMS Code ─────────────────────────────────────────────────
  Future<void> _verifyCode() async {
    if (_codeCtrl.text.isEmpty) {
      _showError('Please enter verification code');
      return;
    }
    widget.setLoading(true);

    try {
      final cred = PhoneAuth.createCredential(
        verificationId: _verificationId!,
        smsCode: _codeCtrl.text.trim(),
      );
      await _signIn(cred);
    } catch (e) {
      _showError(e.toString());
    } finally {
      widget.setLoading(false);
    }
  }

  // ── Sign In with Credential ─────────────────────────────────────────
  Future<void> _signIn(PhoneAuthCredential cred) async {
    final user = await AuthService.instance.signInWithPhoneCredential(cred);
    if (user != null && mounted) {
      context.go('/main');
    }
  }

  // ── Show Error SnackBar ─────────────────────────────────────────────
  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }
}