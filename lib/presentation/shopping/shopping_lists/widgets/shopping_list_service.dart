import '../../../../mock_data/mock_shopping_lists.dart';
import 'shopping_list.dart';

class ShoppingService {
  static List<ShoppingList> getItems() {
    return mockedShoppingLists;
  }
}