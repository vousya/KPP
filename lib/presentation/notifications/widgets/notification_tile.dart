// lib/presentation/notifications/widgets/notification_tile.dart
import 'package:flutter/material.dart';
import '../../../data/notifications/models/notification_type.dart';
import '../../../data/notifications/models/app_notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  const NotificationTile({Key? key, required this.notification}) : super(key: key);

  bool get isUnread => !notification.isRead;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _bgColor(notification.type),
        child: Icon(
          _icon(notification.type),
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      // subtitle removed for now
      trailing: isUnread
          ? const Icon(Icons.circle, color: Colors.blue, size: 10)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  // Map NotificationType → Material icon
  IconData _icon(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return Icons.notifications_active;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.general:
        return Icons.info;
      case NotificationType.shared:
        return Icons.group_add;
      case NotificationType.activity:
        return Icons.edit;
    }
  }

  // Map NotificationType → avatar background color
  Color _bgColor(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return Colors.blue;
      case NotificationType.security:
        return Colors.red;
      case NotificationType.general:
        return Colors.grey;
      case NotificationType.shared:
        return Colors.purple;
      case NotificationType.activity:
        return Colors.green;
    }
  }
}
