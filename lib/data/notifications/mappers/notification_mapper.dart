import 'package:cloud_firestore/cloud_firestore.dart'; // Add this
import '../models/app_notification.dart';
import '../models/notification_type.dart';

const notificationTypeFromString = {
  "reminder": NotificationType.reminder,
  "security": NotificationType.security,
  "general": NotificationType.general,
  "shared": NotificationType.shared,
  "activity": NotificationType.activity,
};

final notificationTypeToString = {
  for (var t in NotificationType.values) t: t.name,
};

class NotificationMapper {
  /// Convert Firestore Data -> AppNotification
  static AppNotification fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return AppNotification(
      id: doc.id, // Firestore ID comes from the document itself
      userId: data['userId'] as String? ?? "",
      type: notificationTypeFromString[data['type']] ?? NotificationType.general,
      title: data['title'] as String? ?? "",
      // Firestore Timestamp -> DateTime
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  /// Convert AppNotification -> Firestore Map
  static Map<String, dynamic> toFirestore(AppNotification n) {
    return {
      'userId': n.userId,
      'type': notificationTypeToString[n.type],
      'title': n.title,
      // DateTime -> Firestore Timestamp
      'createdAt': Timestamp.fromDate(n.createdAt),
      'isRead': n.isRead,
    };
  }
}