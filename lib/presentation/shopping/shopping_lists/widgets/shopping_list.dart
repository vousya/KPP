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

  ShoppingList copyWith({
    String? id,
    String? title,
    List<ShoppingItem>? items,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }
}
