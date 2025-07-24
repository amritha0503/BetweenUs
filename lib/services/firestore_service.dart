import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetches all documents from a collection and returns them
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getCollection(
    String path,
  ) async {
    try {
      final snapshot = await _db.collection(path).get();
      return snapshot.docs;
    } catch (e) {
      print('Error fetching collection: $e');
      return [];
    }
  }

  // Sets a document in a collection with given data
  Future<void> setDocument(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(docId).set(data);
    } catch (e) {
      print('Error setting document: $e');
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> queryCollection(
    String collectionPath, {
    List<Map<String, dynamic>>? where,
  }) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          _db.collection(collectionPath);
      Query<Map<String, dynamic>> query = collection;

      if (where != null) {
        for (var condition in where) {
          final field = condition['field'];
          final isEqualTo = condition['isEqualTo'];
          query = query.where(field, isEqualTo: isEqualTo);
        }
      }

      final snapshot = await query.get();
      return snapshot.docs;
    } catch (e) {
      print('Error querying collection: $e');
      return [];
    }
  }
  // Queries a collection with optional filters and returns documents
}
