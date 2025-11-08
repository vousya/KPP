import 'package:flutter/material.dart';

import '../../widgets/main_header.dart';

import 'widgets/notification_header.dart';
import 'widgets/notification_list.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NotificationHeader(),
            SizedBox(height: 24),
            Expanded(
              child: NotificationList(),
            ),
          ],
        ),
      ),
    );
  }
}
