import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes.dart';

class PhoneLoginForm extends StatefulWidget {
  final Function(bool) setLoading;
  const PhoneLoginForm({super.key, required this.setLoading});

  @override
  State<PhoneLoginForm> createState() => _PhoneLoginFormState();
}

class _PhoneLoginFormState extends State<PhoneLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;

  // Send verification code to phone
  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    widget.setLoading(true);

    String status = "failed";
    String? errorMessage;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text.trim(),
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-sign in for test devices or instant verification
          await FirebaseAuth.instance.signInWithCredential(credential);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone login successful!')),
          );
          context.go('/main');
        },
        verificationFailed: (FirebaseAuthException e) async {
          await Sentry.captureException(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Phone verification failed')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() => _verificationId = verificationId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification code sent')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      status = "success";
      
    } catch (e, s) {
      await Sentry.captureException(e, stackTrace: s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      widget.setLoading(false);
      final now = DateTime.now().toString();

      await analytics.logEvent(
        name: "email_login",
        parameters: {
          "email": _phoneController.text.trim(),
          "time": now,
          "status": status,
          if (errorMessage != null) "error": errorMessage,
        },
      );
    }
  }

  // Verify code entered by user
  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter verification code')),
      );
      return;
    }

    widget.setLoading(true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone login successful!')),
      );
      context.go('/main');
    } on FirebaseAuthException catch (e, s) {
      await Sentry.captureException(e, stackTrace: s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Code verification failed')),
      );
    } finally {
      widget.setLoading(false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: "Phone Number (e.g., +1234567890)",
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter phone';
                // Remove spaces for validation
                final digitsOnly = value.replaceAll(RegExp(r'\s+'), '');
                if (!RegExp(r'^\+?\d{6,15}$').hasMatch(digitsOnly)) {
                  return 'Enter valid phone';
                }
                return null;
              },
            ),
            if (_verificationId != null) ...[
              const SizedBox(height: 10),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  hintText: "Verification Code",
                ),
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
}
