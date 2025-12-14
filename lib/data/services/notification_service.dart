import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../notifications/mappers/notification_mapper.dart';
import '../notifications/models/app_notification.dart';

class NotificationService {
  // Connect to 'listifyprod'
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'listifyprod',
  );
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==========================================
  // R - READ (One-time Fetch)
  // ==========================================
  Future<List<AppNotification>> fetchNotifications() async {
    final userId = _auth.currentUser?.uid;
    print('\n[NotificationService] 🔍 FETCHING notifications for: "$userId"');
    
    if (userId == null) {
      print('[NotificationService] ⚠️ User ID is null.');
      return [];
    }

    try {
      // Use .get() instead of .snapshots()
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      print('[NotificationService] 📄 Documents found: ${snapshot.docs.length}');
      
      return snapshot.docs
          .map((doc) => NotificationMapper.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('[NotificationService] 🔴 FETCH ERROR: $e');
      
      // If Firestore asks for an Index, it will print the link here
      if (e.toString().contains('index')) {
         print('[NotificationService] 💡 TIP: Click the link in the error above to create the index!');
      }
      return [];
    }
  }

  // ==========================================
  // C - CREATE
  // ==========================================
  Future<void> addNotification(AppNotification n) async {
    try {
      await _firestore.collection('notifications').add(NotificationMapper.toFirestore(n));
      print('[NotificationService] ✅ Notification added');
    } catch (e) {
      print('[NotificationService] 🔴 Add failed: $e');
    }
  }

  // ==========================================
  // U - UPDATE (Mark as Read)
  // ==========================================
  Future<void> markAsRead(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).update({'isRead': true});
      print('[NotificationService] ✅ Marked as read: $id');
    } catch (e) {
      print('[NotificationService] 🔴 Update failed: $e');
      rethrow;
    }
  }

  // ==========================================
  // U - UPDATE (Mark All as Read)
  // ==========================================
  Future<void> markAllAsRead() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      print('[NotificationService] ⚠️ User ID is null.');
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
      print('[NotificationService] ✅ Marked all as read: ${snapshot.docs.length} notifications');
    } catch (e) {
      print('[NotificationService] 🔴 Mark all as read failed: $e');
      rethrow;
    }
  }

  // ==========================================
  // D - DELETE
  // ==========================================
  Future<void> deleteNotification(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).delete();
      print('[NotificationService] ✅ Deleted: $id');
    } catch (e) {
      print('[NotificationService] 🔴 Delete failed: $e');
    }
  }
}