import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../empathy_neural_profile/empathy_neural_profile_model.dart';

class DashboardFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 📡 Update only tone awareness (called from Tone Optimizer)
  Future<void> updateToneAwareness({
    required String userId,
    required String tone,
  }) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('empathy_scores')
        .doc(today);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final existingData = snapshot.data()!;
      final toneMap =
          Map<String, dynamic>.from(existingData['toneAwareness'] ?? {});
      toneMap[tone] = (toneMap[tone] ?? 0) + 1;

      await docRef.update({'toneAwareness': toneMap});
    } else {
      await docRef.set({
        'date': today,
        'listening': 0,
        'supportiveness': 0,
        'empathyLevel': 0,
        'toneAwareness': {tone: 1},
      });
    }
  }

  /// 📥 Fetch daily empathy score
  Future<EmpathyScore?> fetchDailyEmpathyScore(
      String userId, DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('empathy_scores')
        .doc(dateStr)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    try {
      return EmpathyScore.fromMap(doc.data()!, dateStr);
    } catch (e) {
      // Log error if needed
      return null;
    }
  }

  /// 📊 Optional: Compute average tone awareness score (0-100)
  double computeToneAwarenessScore(Map<String, dynamic> toneMap) {
    if (toneMap.isEmpty) return 0;
    int total = 0;
    toneMap.forEach((_, value) {
      total += (value as int);
    });
    return (total / toneMap.length).clamp(0, 100).toDouble();
  }
}
