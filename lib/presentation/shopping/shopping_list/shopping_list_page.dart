import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/main_header.dart';
import 'widgets/progress_bar.dart';
import 'widgets/shopping_controls.dart';
import 'widgets/shopping_item_card.dart';
import '../../../data/providers/shopping_lists_provider.dart';


class ShoppingListPage extends ConsumerWidget {
  final String listId;
  final String listTitle;

  const ShoppingListPage({
    super.key,
    required this.listId,
    required this.listTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(shoppingListsProvider).firstWhere((l) => l.id == listId);
    final filter = ref.watch(listFilterProvider(listId));

    // Apply filter
    final visibleItems = switch (filter) {
      ShoppingFilter.all => list.items,
      ShoppingFilter.purchased => list.items.where((i) => i.isPurchased).toList(),
      ShoppingFilter.unpurchased => list.items.where((i) => !i.isPurchased).toList(),
    };


    return Scaffold(
      appBar: MainHeader(),
      body: Column(
        children: [
          ProgressBar(list: list),
          const SizedBox(height: 20),
          ShoppingControls(list: list),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: visibleItems.length,
              itemBuilder: (_, index) {
                final item = visibleItems[index];
                return ShoppingItemCard(item: item, listId: list.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
