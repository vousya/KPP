import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/shopping_list_service.dart';
import '../../../widgets/main_header.dart';

class ShoppingListsPage extends StatelessWidget {
  const ShoppingListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingLists = ShoppingService().getItems();

    return Scaffold(
      appBar: const MainHeader(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final list = shoppingLists[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                list.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate using GoRouter with path parameter
                context.push(
                  '/lists/${list.id}',
                  extra: {
                    'title': list.title,
                    'items': list.items,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
