import 'package:flutter/material.dart';

import 'widgets/shopping_service.dart';
import 'widgets/progress_bar.dart';
import 'widgets/shopping_controls.dart';
import 'widgets/shopping_item_card.dart';

import '../../widgets/main_header.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ShoppingService().getItems();

    return Scaffold(
      appBar: const MainHeader(),

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
