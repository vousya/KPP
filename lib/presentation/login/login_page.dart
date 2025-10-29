import 'package:flutter/material.dart';
import 'email_login_form.dart';
import 'phone_login_form.dart';
import 'login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isEmailLogin = true; // Toggle between email and phone login
  bool _loading = false;

  void setLoading(bool value) => setState(() => _loading = value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const LoginHeader(),

                const SizedBox(height: 20),
                // Toggle switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Email/Password"),
                    Switch(
                      value: !_isEmailLogin,
                      onChanged: (value) {
                        setState(() {
                          _isEmailLogin = !value;
                        });
                      },
                    ),
                    const Text("Phone"),
                  ],
                ),
                const SizedBox(height: 20),
                // Show form based on toggle
                _isEmailLogin
                    ? EmailLoginForm(setLoading: setLoading)
                    : PhoneLoginForm(setLoading: setLoading),
              ],
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
