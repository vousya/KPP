// lib/presentation/notifications/widgets/notification_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/notification_service.dart';

enum NotificationFilter { all, unread }

final notificationFilterProvider = StateProvider<NotificationFilter>((ref) => NotificationFilter.all);

class NotificationHeader extends ConsumerWidget {
  const NotificationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(notificationFilterProvider);
    final service = NotificationService();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _FilterButton(
              label: 'All',
              isSelected: currentFilter == NotificationFilter.all,
              onTap: () {
                ref.read(notificationFilterProvider.notifier).state = NotificationFilter.all;
              },
            ),
            const SizedBox(width: 8),
            _FilterButton(
              label: 'Unread',
              isSelected: currentFilter == NotificationFilter.unread,
              onTap: () {
                ref.read(notificationFilterProvider.notifier).state = NotificationFilter.unread;
              },
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () async {
                try {
                  await service.markAllAsRead();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All notifications marked as read')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Mark all as read'),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        side: BorderSide(
          color: isSelected ? Colors.deepPurple : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.deepPurple : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
