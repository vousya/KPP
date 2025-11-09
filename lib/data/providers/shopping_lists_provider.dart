import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/shopping/shopping_lists/widgets/shopping_list_service.dart';
import '../../presentation/shopping/shopping_lists/widgets/shopping_list.dart';

final shoppingListsProvider =
    StateNotifierProvider<ShoppingListsNotifier, List<ShoppingList>>(
  (ref) => ShoppingListsNotifier(),
);

class ShoppingListsNotifier extends StateNotifier<List<ShoppingList>> {
  ShoppingListsNotifier() : super(ShoppingService.getItems());

  void toggleItem(String listId, String itemId) {
    state = [
      for (final list in state)
        if (list.id == listId)
          ShoppingList(
            id: list.id,
            title: list.title,
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
