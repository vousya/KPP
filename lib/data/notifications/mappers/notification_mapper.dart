import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_notification.dart';
import '../models/notification_type.dart';

// String → Enum
const notificationTypeFromString = {
  "reminder": NotificationType.reminder,
  "security": NotificationType.security,
  "general": NotificationType.general,
  "shared": NotificationType.shared,
  "activity": NotificationType.activity,
};

// Enum → String
final notificationTypeToString = {
  for (var t in NotificationType.values) t: t.name,
};

class NotificationMapper {
  // Convert Firestore document → AppNotification
  static AppNotification fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return AppNotification(
      id: doc.id,
      type: notificationTypeFromString[data['type']] ?? NotificationType.general,
      title: data['title'] ?? "",
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  // Convert AppNotification → Firestore map
  static Map<String, dynamic> toFirestore(AppNotification n) {
    return {
      'type': notificationTypeToString[n.type],
      'title': n.title,
      'createdAt': n.createdAt,
      'isRead': n.isRead,
    };
  }
}
