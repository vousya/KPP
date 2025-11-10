import '../../presentation/shopping/shopping_lists/widgets/shopping_list.dart';
import '../../presentation/shopping/shopping_list/widgets/shopping_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShoppingService {
  final SupabaseClient supabase;

  ShoppingService({SupabaseClient? client})
      : supabase = client ?? Supabase.instance.client;

  Future<List<ShoppingList>?> getItemsFromSupabase() async {
    try {
      final response = await supabase.from('shopping_lists').select();
      print('Raw response from Supabase: $response');

      if (response == null) {
        print('Supabase returned null!');
        return [];
      }

      final data = response as List<dynamic>;
      print('Number of lists fetched: ${data.length}');

      return data.map((doc) {
        print('Processing doc: $doc');

        // Remove jsonDecode — items is already a List
        final itemsData = doc['items'] as List<dynamic>;
        final items = itemsData.map((item) {
          print('Processing item: $item');
          return ShoppingItem(
            id: item['id'],
            title: item['title'],
            subtitle: item['subtitle'],
            isPurchased: item['isPurchased'],
          );
        }).toList();

        return ShoppingList(
          id: doc['id'],
          title: doc['title'],
          items: items,
        );
      }).toList();
    } catch (e) {
      print('Error fetching shopping lists: $e');
      return null;
    }
  }

  Stream<List<ShoppingList>> subscribeToItems() {
    return supabase
        .from('shopping_lists')
        .stream(primaryKey: ['id'])
        .map((event) {
      return event.map((doc) {

        final itemsData = doc['items'] as List<dynamic>;
        final items = itemsData.map((item) {
          return ShoppingItem(
            id: item['id'],
            title: item['title'],
            subtitle: item['subtitle'],
            isPurchased: item['isPurchased'],
          );
        }).toList();

        return ShoppingList(
          id: doc['id'],
          title: doc['title'],
          items: items,
        );
      }).toList();
    });
  }
}
