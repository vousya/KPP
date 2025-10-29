import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes.dart';

class EmailLoginForm extends StatefulWidget {
  final Function(bool) setLoading;
  const EmailLoginForm({super.key, required this.setLoading});

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    widget.setLoading(true);

    String status = "failed";
    String? errorMessage;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      status = "success";

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login successful!')));
      context.go('/main');
    } on FirebaseAuthException catch (e, s) {
      errorMessage = e.message ?? 'Login failed';
      await Sentry.captureException(e, stackTrace: s);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      widget.setLoading(false);
      final now = DateTime.now().toString();

      await analytics.logEvent(
        name: "email_login",
        parameters: {
          "email": _emailController.text.trim(),
          "time": now,
          "status": status,
          if (errorMessage != null) "error": errorMessage,
        },
      );
    }
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
              controller: _emailController,
              decoration: const InputDecoration(hintText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter email';
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Enter valid email';
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter password';
                if (value.length < 6) return 'Password must be 6+ chars';
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
