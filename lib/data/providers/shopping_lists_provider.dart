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
    // Don't assign state here directly
    loadItemsFromSupabase();
  }

  Future<void> loadItemsFromSupabase() async {
    final items = await service.getItemsFromSupabase();
    state = items!;
  }

  void toggleItem(String listId, String itemId) {
    state = [
      for (final list in state)
        if (list.id == listId)
          list.copyWith(
            items: [
              for (final item in list.items)
                if (item.id == itemId)
                  item.copyWith(isPurchased: !item.isPurchased)
                else
                  item
            ],
          )
        else
          list
    ];
  }
}

