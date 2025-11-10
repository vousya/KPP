import '../models/app_notification.dart';
import '../models/notification_type.dart';

/// String → Enum
const notificationTypeFromString = {
  "reminder": NotificationType.reminder,
  "security": NotificationType.security,
  "general": NotificationType.general,
  "shared": NotificationType.shared,
  "activity": NotificationType.activity,
};

/// Enum → String
final notificationTypeToString = {
  for (var t in NotificationType.values) t: t.name,
};

class NotificationMapper {
  /// Convert Supabase JSON → AppNotification
  static AppNotification fromSupabase(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? "",
      type: notificationTypeFromString[json['type']] ?? NotificationType.general,
      title: json['title'] as String? ?? "",
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  /// Convert AppNotification → Supabase JSON
  static Map<String, dynamic> toSupabase(AppNotification n) {
    return {
      'id': n.id,
      'userId': n.userId,
      'type': notificationTypeToString[n.type],
      'title': n.title,
      'createdAt': n.createdAt.toIso8601String(),
      'isRead': n.isRead,
    };
  }
}
