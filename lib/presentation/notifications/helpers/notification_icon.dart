import 'package:flutter/material.dart';
import '../../../data/notifications/models/notification_type.dart';

IconData notificationIcon(NotificationType type) {
  switch (type) {
    case NotificationType.reminder:
      return Icons.notifications_active;
    case NotificationType.security:
      return Icons.security;
    case NotificationType.general:
      return Icons.info;
    case NotificationType.shared:
      return Icons.person_add;
    case NotificationType.activity:
      return Icons.edit;
  }
}
