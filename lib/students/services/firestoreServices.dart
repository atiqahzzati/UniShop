import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  Future<Map<String, dynamic>> getItemDetails(String itemId) async {
    try {
      DocumentSnapshot itemSnapshot = await itemsCollection.doc(itemId).get();
      if (itemSnapshot.exists) {
        return itemSnapshot.data() as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      print("Error fetching item details: $e");
      return {};
    }
  }
}
