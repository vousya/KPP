import '../../shopping_list/widgets/shopping_item.dart';

class ShoppingList {
  final String id;
  final String title;
  final List<ShoppingItem> items;

  ShoppingList({
    required this.id,
    required this.title,
    required this.items,
  });
}
