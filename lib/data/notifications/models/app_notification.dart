import 'notification_type.dart';

class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,  
    required this.userId,
    required this.type,
    required this.title,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
