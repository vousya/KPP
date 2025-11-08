// lib/presentation/notifications/widgets/notification_header.dart
import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Row(
          children: [
            _filterButton('All'),
            const SizedBox(width: 8),
            _filterButton('Unread'),
            const SizedBox(width: 16),
            TextButton(onPressed: () {}, child: const Text('Mark all as read')),
          ],
        ),
      ],
    );
  }

  Widget _filterButton(String label) => OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: Text(label),
      );
}