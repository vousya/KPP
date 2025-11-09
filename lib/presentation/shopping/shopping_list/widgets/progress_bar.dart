import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shopping_lists/widgets/shopping_list.dart';

class ProgressBar extends ConsumerWidget {
  final ShoppingList list;

  const ProgressBar({super.key, required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = list.items.length;
    final purchasedItems = list.items.where((i) => i.isPurchased).length;

    final progressValue = totalItems == 0 ? 0.0 : purchasedItems / totalItems;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shopping Progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 10),
              Text('$purchasedItems/$totalItems Items Purchased'),
            ],
          ),
        ],
      ),
    );
  }
}
