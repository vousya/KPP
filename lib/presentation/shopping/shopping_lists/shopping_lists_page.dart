import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Import your main provider to access the notifier actions
import '../../../data/providers/shopping_lists_provider.dart';
import '../../../widgets/main_header.dart';
import '../../../data/providers/filter_products_provider.dart';

class ShoppingListsPage extends ConsumerWidget {
  const ShoppingListsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep using your filter provider for viewing
    final shoppingLists = ref.watch(visibleListsProvider);

    return Scaffold(
      appBar: const MainHeader(),
      
      // NEW: Button to create a list
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: shoppingLists.isEmpty 
          ? const Center(child: Text("No lists found. Create one!"))
          : ListView.builder(
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      list.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      context.push(
                        '/lists/${list.id}',
                        extra: {
                          'title': list.title,
                          'items': list.items,
                        },
                      );
                    },
                    // MODIFIED: Added Delete button next to Arrow
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () => _showDeleteConfirmDialog(context, ref, list.id),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // --- DIALOG: CREATE NEW LIST ---
  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New List"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "List Title (e.g. Groceries)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                // Access the Notifier to create
                ref.read(shoppingListsProvider.notifier).createList(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // --- DIALOG: CONFIRM DELETE ---
  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref, String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete List?"),
        content: const Text("Are you sure you want to delete this list?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Access the Notifier to delete
              ref.read(shoppingListsProvider.notifier).deleteList(listId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}