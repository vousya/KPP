import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/shopping/shopping_lists/widgets/shopping_list.dart';
import 'shopping_lists_provider.dart'; // your StateNotifier provider

// --- Filter Enum ---
enum ShoppingFilter { all, purchased, unpurchased }

// --- Filter State Provider ---
final filterProvider = StateProvider<ShoppingFilter>((ref) => ShoppingFilter.all);

// --- Computed Provider (filtered view only) ---
final visibleListsProvider = Provider<List<ShoppingList>>((ref) {
  final lists = ref.watch(shoppingListsProvider);
  final filter = ref.watch(filterProvider);

  List<ShoppingList> output = [];

  for (final list in lists) {
    final filteredItems = switch (filter) {
      ShoppingFilter.all => list.items,
      ShoppingFilter.purchased =>
          list.items.where((item) => item.isPurchased).toList(),
      ShoppingFilter.unpurchased =>
          list.items.where((item) => !item.isPurchased).toList(),
    };

    output.add(list.copyWith(items: filteredItems));
  }

  return output;
});
