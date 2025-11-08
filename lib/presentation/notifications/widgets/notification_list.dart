// lib/presentation/notifications/widgets/notification_list.dart
import 'package:flutter/material.dart';
import '../../../data/notifications/services/notification_service.dart';
import '../../../data/notifications/models/app_notification.dart';
import 'notification_tile.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppNotification>>(
      future: NotificationService.loadHardcoded(), // load your hardcoded list
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load notifications'));
        }

        final notifications = snapshot.data ?? [];

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final notification = notifications[index];
            return NotificationTile(notification: notification);
          },
        );
      },
    );
  }
}
