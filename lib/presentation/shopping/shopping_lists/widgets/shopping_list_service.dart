import 'mock_shopping_lists.dart';
import 'shopping_list.dart';

class ShoppingService {
  List<ShoppingList> getItems() {
    return mockedShoppingLists;
  }
}