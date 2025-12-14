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
    loadLists(); 
  }

  Future<void> loadLists() async {
    final lists = await service.fetchLists();
    state = lists;
  }

  // --- CREATE ---
  Future<void> createList(String title) async {
    await service.createList(title);
    await loadLists(); 
  }

  // --- DELETE (NEW) ---
  Future<void> deleteList(String id) async {
    // 1. Optimistic Update: Remove from UI immediately
    final previousState = state;
    state = state.where((list) => list.id != id).toList();

    try {
      // 2. Call API
      await service.deleteList(id);
    } catch (e) {
      // 3. Revert if API fails
      state = previousState;
      print("Delete failed: $e");
    }
  }

  // --- UPDATE ---
  Future<void> toggleItem(String listId, String itemId) async {
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

    try {
      await service.updateList(updatedList);
    } catch (e) {
      state = previousState;
    }
  }
}