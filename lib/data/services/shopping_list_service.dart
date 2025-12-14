import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this import
import '../../presentation/shopping/shopping_lists/widgets/shopping_list.dart';
import '../../presentation/shopping/shopping_list/widgets/shopping_item.dart';

class ShoppingService {
  // CHANGE: Connect to 'listifyprod'
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'listifyprod',
  );
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  // ... Keep the rest of your methods (fetchLists, createList, etc.) exactly the same
  // ... just copy the logic we wrote in the previous step.
  
  // For reference, here is the fetchLists method again so you can verify:
  Future<List<ShoppingList>> fetchLists() async {
    final uid = _userId;
    print('\n[ShoppingService] 🔍 FETCHING lists from "listifyprod" for: "$uid"');

    if (uid.isEmpty) return [];

    try {
      final snapshot = await _firestore
          .collection('shopping_lists')
          .where('userId', isEqualTo: uid)
          .get();

      print('[ShoppingService] 📄 Documents found: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) => _mapDocToList(doc)).toList();
    } catch (e) {
      print('[ShoppingService] 🔴 FETCH ERROR: $e');
      throw e;
    }
  }

  // ... helper _mapDocToList ...
  ShoppingList _mapDocToList(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      final itemsData = data['items'] as List<dynamic>? ?? [];

      final items = itemsData.map((item) {
        final map = item as Map<String, dynamic>;
        return ShoppingItem(
          id: map['id'] ?? '',
          title: map['title'] ?? '',
          subtitle: map['subtitle'] ?? '',
          isPurchased: map['isPurchased'] ?? false,
        );
      }).toList();

      return ShoppingList(
        id: doc.id,
        title: data['title'] ?? '',
        items: items,
      );
    } catch (e) {
      return ShoppingList(id: doc.id, title: 'Error List', items: []);
    }
  }
  
  // ... Include createList, updateList, deleteList from previous step ...
  Future<void> createList(String title) async {
    if (_userId.isEmpty) return;
    await _firestore.collection('shopping_lists').add({
      'title': title, 'userId': _userId, 'items': [],
    });
  }

  Future<void> updateList(ShoppingList list) async {
    try {
      print('\n[ShoppingService] 🔄 UPDATING list: "${list.id}"');
      print('[ShoppingService] Items count: ${list.items.length}');
      
      final itemsMap = list.items.map((item) => {
        'id': item.id,
        'title': item.title,
        'subtitle': item.subtitle,
        'isPurchased': item.isPurchased,
      }).toList();
      
      print('[ShoppingService] Items map: $itemsMap');
      
      await _firestore
          .collection('shopping_lists')
          .doc(list.id)
          .update({'items': itemsMap});
      
      print('[ShoppingService] ✅ UPDATE SUCCESS');
    } catch (e, stackTrace) {
      print('[ShoppingService] 🔴 UPDATE ERROR: $e');
      print('[ShoppingService] Stack trace: $stackTrace');
      rethrow;
    }
  }
  
  Future<void> deleteList(String id) async {
     await _firestore.collection('shopping_lists').doc(id).delete();
  }
}