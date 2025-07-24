import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_model.dart';

class DashboardService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<EmpathyScore>> getWeeklyScores(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('empathy_scores')
        .orderBy(FieldPath.documentId)
        .limit(7)
        .get();

    return snapshot.docs
        .map((doc) => EmpathyScore.fromMap(doc.data(), doc.id))
        .toList();
  }
}
