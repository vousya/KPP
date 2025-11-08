// lib/presentation/main/widgets/shopping_item_card.dart
import 'package:flutter/material.dart';
import 'shopping_item.dart';

typedef ItemToggleCallback = void Function(ShoppingItem updated);
typedef ItemActionCallback = void Function(ShoppingItem item);

class ShoppingItemCard extends StatelessWidget {
  final ShoppingItem item;
  final ItemToggleCallback? onTogglePurchased;
  final ItemActionCallback? onEdit;
  final ItemActionCallback? onDelete;

  const ShoppingItemCard({
    Key? key,
    required this.item,
    this.onTogglePurchased,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Checkbox(
              value: item.isPurchased,
              onChanged: (bool? newValue) {
                final updated = item.copyWith(isPurchased: newValue ?? false);
                if (onTogglePurchased != null) onTogglePurchased!(updated);
              },
              activeColor: Colors.deepPurple,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration:
                          item.isPurchased ? TextDecoration.lineThrough : null,
                      color: item.isPurchased ? Colors.grey : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration:
                          item.isPurchased ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.grey),
              onPressed: () {
                if (onEdit != null) onEdit!(item);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                if (onDelete != null) onDelete!(item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
