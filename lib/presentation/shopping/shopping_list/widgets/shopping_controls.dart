import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shopping_lists/widgets/shopping_list.dart';
import '../widgets/add_edit_item_dialog.dart';

final listFilterProvider =
    StateProvider.family<ShoppingFilter, String>((ref, listId) {
  return ShoppingFilter.all;
});

final searchQueryProvider =
    StateProvider.family<String, String>((ref, listId) {
  return '';
});

enum ShoppingFilter { all, purchased, unpurchased }

class ShoppingControls extends ConsumerStatefulWidget {
  final ShoppingList list;

  const ShoppingControls({super.key, required this.list});

  @override
  ConsumerState<ShoppingControls> createState() => _ShoppingControlsState();
}

class _ShoppingControlsState extends ConsumerState<ShoppingControls> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(listFilterProvider(widget.list.id));
    final searchQuery = ref.watch(searchQueryProvider(widget.list.id));

    // Sync controller with provider
    if (_searchController.text != searchQuery) {
      _searchController.text = searchQuery;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _TabButton(
                      text: 'All',
                      isSelected: currentFilter == ShoppingFilter.all,
                      onTap: () => ref
                          .read(listFilterProvider(widget.list.id).notifier)
                          .state = ShoppingFilter.all,
                    ),
                    const SizedBox(width: 10),
                    _TabButton(
                      text: 'Purchased',
                      isSelected: currentFilter == ShoppingFilter.purchased,
                      onTap: () => ref
                          .read(listFilterProvider(widget.list.id).notifier)
                          .state = ShoppingFilter.purchased,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(searchQueryProvider(widget.list.id).notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search shopping items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddEditItemDialog(
                    listId: widget.list.id,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const _TabButton({
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
