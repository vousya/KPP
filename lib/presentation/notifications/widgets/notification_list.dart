import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/notifications/models/app_notification.dart';
import 'notification_tile.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final NotificationService _service = NotificationService();
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    // Load data when widget starts
    _notificationsFuture = _service.fetchNotifications();
  }

  // Optional: Pull to Refresh functionality
  Future<void> _refresh() async {
    setState(() {
      _notificationsFuture = _service.fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppNotification>>(
      future: _notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final notifications = snapshot.data ?? [];

        if (notifications.isEmpty) {
          return const Center(child: Text("No notifications"));
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              return NotificationTile(notification: notifications[index]);
            },
          ),
        );
      },
    );
  }
}