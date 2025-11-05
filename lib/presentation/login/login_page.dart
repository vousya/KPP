import 'package:flutter/material.dart';
import 'email_login_form.dart';
import 'phone_login_form.dart';
import 'google_login_form.dart';
import 'login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isEmail = true;
  bool _loading = false;

  void _setLoading(bool v) => setState(() => _loading = v);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Email/Password"),
                    Switch(
                      value: !_isEmail,
                      onChanged: (v) => setState(() => _isEmail = !v),
                    ),
                    const Text("Phone"),
                  ],
                ),
                const SizedBox(height: 20),
                _isEmail
                    ? EmailLoginForm(setLoading: _setLoading)
                    : PhoneLoginForm(setLoading: _setLoading),

                GoogleLoginForm(setLoading: _setLoading),
              ],
            ),
          ),
          if (_loading)
            Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}