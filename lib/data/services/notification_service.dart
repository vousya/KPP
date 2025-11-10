import 'package:supabase_flutter/supabase_flutter.dart';
import '../notifications/mappers/notification_mapper.dart';
import '../notifications/models/app_notification.dart';

class NotificationService {
  final SupabaseClient _supabase;
  static const _table = 'notifications';

  NotificationService({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  Future<List<AppNotification>> getNotifications(String userId) async {
    
    final response = await _supabase
        .from(_table)
        .select()
        .eq('userId', userId)
        .order('createdAt', ascending: false);

    if (response == null) return [];

    if (response is List) {
      return response.map((e) {
        final Map<String, dynamic> json =
            (e is Map) ? Map<String, dynamic>.from(e) : <String, dynamic>{};
        return NotificationMapper.fromSupabase(json);
      }).toList();
    }

    throw Exception('Unexpected response type from Supabase: ${response.runtimeType}');
  }

  RealtimeChannel subscribeNotifications(
    String userId,
    void Function(AppNotification) onInsert,
  ) {
    final channel = _supabase.channel('notifications-user-$userId');

    channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: _table,
        filter: 'userId=eq.$userId',
      ),
      (payload, [ref]) {
        final newObj = payload['new'];
        if (newObj is Map) {
          final Map<String, dynamic> json = Map<String, dynamic>.from(newObj);
          onInsert(NotificationMapper.fromSupabase(json));
        } else {
          try {
            final Map<String, dynamic> json = Map<String, dynamic>.from(newObj);
            onInsert(NotificationMapper.fromSupabase(json));
          } catch (_) {
          }
        }
      },
    );

    channel.subscribe();
    return channel;
  }

  Future<void> addNotification(AppNotification n) async {
    await _supabase.from(_table).insert(NotificationMapper.toSupabase(n));
  }

  Future<void> deleteNotification(String id) async {
    await _supabase.from(_table).delete().eq('id', id);
  }

  Future<void> markAsRead(String id, {bool isRead = true}) async {
    await _supabase.from(_table).update({'isRead': isRead}).eq('id', id);
  }
}
