import 'mock_shopping_items.dart';
import 'shopping_item.dart';

class ShoppingService {
  List<ShoppingItem> getItems() {
    return mockedShoppingItems;
  }
}
