import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../data/notifications/mappers/notification_mapper.dart';
import '../../../data/notifications/models/app_notification.dart';
import '../../../data/services/notification_service.dart';
import 'notification_tile.dart';
import 'notification_header.dart';

class NotificationList extends ConsumerWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(notificationFilterProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('Please log in to view notifications'));
    }

    final firestore = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'listifyprod',
    );

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifications = snapshot.data?.docs
                .map((doc) => NotificationMapper.fromFirestore(doc))
                .toList() ??
            [];

        // Apply filter
        final visibleNotifications = switch (filter) {
          NotificationFilter.all => notifications,
          NotificationFilter.unread => notifications.where((n) => !n.isRead).toList(),
        };

        if (notifications.isEmpty) {
          return const Center(child: Text('No notifications'));
        }

        if (visibleNotifications.isEmpty) {
          return const Center(child: Text('No unread notifications'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            // StreamBuilder automatically refreshes, but we can trigger a reload
            await NotificationService().fetchNotifications();
          },
          child: ListView.separated(
            itemCount: visibleNotifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = visibleNotifications[index];
              return NotificationTile(
                notification: notification,
                onTap: () async {
                  if (!notification.isRead) {
                    try {
                      await NotificationService().markAsRead(notification.id);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
