import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shopping_list_service.dart';
import '../../presentation/shopping/shopping_lists/widgets/shopping_list.dart';

final shoppingServiceProvider = Provider((ref) => ShoppingService());

final shoppingListsProvider =
    StateNotifierProvider<ShoppingListsNotifier, List<ShoppingList>>(
  (ref) => ShoppingListsNotifier(service: ref.watch(shoppingServiceProvider)),
);

class ShoppingListsNotifier extends StateNotifier<List<ShoppingList>> {
  final ShoppingService service;

  ShoppingListsNotifier({required this.service}) : super([]) {
    loadLists(); // Load immediately on start
  }

  // NEW: Call the Future method
  Future<void> loadLists() async {
    final lists = await service.fetchLists();
    state = lists;
  }

  // Create
  Future<void> createList(String title) async {
    await service.createList(title);
    await loadLists(); // Refresh data after creating
  }

  // Update
  Future<void> toggleItem(String listId, String itemId) async {
    // 1. Optimistic Update (Update UI immediately)
    final previousState = state;
    final listIndex = state.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return;

    final list = state[listIndex];
    final updatedItems = list.items.map((item) {
      return item.id == itemId
          ? item.copyWith(isPurchased: !item.isPurchased)
          : item;
    }).toList();
    final updatedList = list.copyWith(items: updatedItems);

    state = [
      for (final l in state)
        if (l.id == listId) updatedList else l
    ];

    // 2. Call API
    try {
      await service.updateList(updatedList);
    } catch (e) {
      // Revert if API fails
      state = previousState;
    }
  }
}