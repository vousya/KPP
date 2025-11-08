import 'package:flutter/material.dart';

import '../../widgets/main_header.dart';

import '../../data/auth/auth_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainHeader(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ElevatedButton(
            onPressed: () => AuthService.instance.signOut(),
            child: const Text('Sign Out'),
          ),
        ),
      ),
    );
  }
}
