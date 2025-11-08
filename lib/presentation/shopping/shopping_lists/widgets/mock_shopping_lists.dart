import '../../shopping_list/widgets/shopping_item.dart';
import 'shopping_list.dart';

final List<ShoppingList> mockedShoppingLists = [
  ShoppingList(
    id: '1',
    title: 'Weekly Groceries',
    items: [
      ShoppingItem(id: '1', title: 'Organic Eggs', subtitle: '1 Dozen', isPurchased: false),
      ShoppingItem(id: '2', title: 'Blueberries', subtitle: '2 lbs', isPurchased: false),
    ],
  ),
  ShoppingList(
    id: '2',
    title: 'Cooking Essentials',
    items: [
      ShoppingItem(id: '3', title: 'Olive Oil', subtitle: '1 Liter', isPurchased: false),
      ShoppingItem(id: '4', title: 'Canned Tomatoes', subtitle: '28 oz', isPurchased: true),
    ],
  ),
  ShoppingList(
    id: '3',
    title: 'Household',
    items: [
      ShoppingItem(id: '5', title: 'Dish Soap', subtitle: '1 Bottle', isPurchased: false),
      ShoppingItem(id: '6', title: 'Sponges', subtitle: 'Pack of 5', isPurchased: false),
    ],
  ),
];
