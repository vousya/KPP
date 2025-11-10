// lib/presentation/notifications/widgets/notification_list.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/services/notification_service.dart';
import '../../../data/notifications/models/app_notification.dart';
import 'notification_tile.dart';

import '../../../data/providers/auth_provider.dart';

class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList> {
  late final NotificationService _service;

  final List<AppNotification> _notifications = [];
  RealtimeChannel? _channel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = NotificationService();

    _loadNotifications();
    _subscribeToRealtime();
  }

  Future<void> _loadNotifications() async {
    final userId = ref.read(authServiceProvider).currentUser?.uid;
    print(userId);

    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    final list = await _service.getNotifications(userId);

    setState(() {
      _notifications
        ..clear()
        ..addAll(list);
      _isLoading = false;
    });
  }

  void _subscribeToRealtime() {
    final userId = ref.read(authServiceProvider).currentUser?.uid;
    if (userId == null) return;

    _channel = _service.subscribeNotifications(
      userId,
      (notification) {
        setState(() {
          _notifications.insert(0, notification);
        });
      },
    );
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_notifications.isEmpty) {
      return const Center(
        child: Text(
          "No notifications yet",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _notifications.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final notification = _notifications[index];
        return NotificationTile(notification: notification);
      },
    );
  }
}
