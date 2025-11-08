import 'package:flutter/material.dart';

import '../../../widgets/main_header.dart';

import 'widgets/progress_bar.dart';
import 'widgets/shopping_controls.dart';
import 'widgets/shopping_item_card.dart';

import 'widgets/shopping_item.dart';

class ShoppingListPage extends StatelessWidget {
  final String listId;
  final String listTitle;
  final List<ShoppingItem> items;

  const ShoppingListPage({
    super.key,
    required this.listId,
    required this.listTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(),

      body: Column(
        children: [
          const ProgressBar(),
          const SizedBox(height: 20),
          const ShoppingControls(),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                return ShoppingItemCard(item: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
