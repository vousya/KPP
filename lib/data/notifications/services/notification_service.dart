import 'package:cloud_firestore/cloud_firestore.dart';
import '../mappers/notification_mapper.dart';
import '../models/app_notification.dart';
import '../../../mock_data/notification_service_mock.dart';

class NotificationService {
  static final _db = FirebaseFirestore.instance;
  static const _collection = 'notifications';

  // Hardcoded mode for testing
  static Future<List<AppNotification>> loadHardcoded() async {
    return hardcodedNotifications.map((json) {
      return AppNotification(
        id: json['id'],
        type: notificationTypeFromString[json['type']]!,
        title: json['title'],
        createdAt: json['createdAt'],
        isRead: json['isRead'] ?? false,
      );
    }).toList();
  }

  // Real Firestore (live updates)
  Stream<List<AppNotification>> streamNotifications(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map(NotificationMapper.fromFirestore)
            .toList());
  }

  // Add notification
  Future<void> addNotification(String userId, AppNotification n) async {
    await _db.collection(_collection).add({
      ...NotificationMapper.toFirestore(n),
      'userId': userId,
      'isRead': n.isRead,
    });
  }

  // Delete notification
  Future<void> deleteNotification(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  // Mark notification as read/unread
  Future<void> markAsRead(String id, {bool isRead = true}) async {
    await _db.collection(_collection).doc(id).update({'isRead': isRead});
  }
}
