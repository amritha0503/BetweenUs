import 'package:cloud_firestore/cloud_firestore.dart';

class DemoScoreUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadDemoScores(String userId) async {
    final scores = [
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'listening': 0.6,
        'supportiveness': 0.5,
        'toneAwareness': 0.7,
        'empathyLevel': 0.6,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'listening': 0.7,
        'supportiveness': 0.6,
        'toneAwareness': 0.6,
        'empathyLevel': 0.65,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'listening': 0.5,
        'supportiveness': 0.7,
        'toneAwareness': 0.5,
        'empathyLevel': 0.55,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'listening': 0.8,
        'supportiveness': 0.9,
        'toneAwareness': 0.85,
        'empathyLevel': 0.88,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'listening': 0.7,
        'supportiveness': 0.8,
        'toneAwareness': 0.6,
        'empathyLevel': 0.7,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'listening': 0.65,
        'supportiveness': 0.75,
        'toneAwareness': 0.6,
        'empathyLevel': 0.68,
      },
      {
        'date': DateTime.now(),
        'listening': 0.75,
        'supportiveness': 0.7,
        'toneAwareness': 0.7,
        'empathyLevel': 0.72,
      },
    ];

    for (var score in scores) {
      final formattedDate = score['date'] as DateTime;
      final docId = formattedDate.toIso8601String().split('T')[0]; // yyyy-MM-dd
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('empathy_scores')
          .doc(docId)
          .set({
        'listening': score['listening'],
        'supportiveness': score['supportiveness'],
        'toneAwareness': score['toneAwareness'],
        'empathyLevel': score['empathyLevel'],
      });
    }

    print('✅ Demo empathy scores uploaded for userId: $userId');
  }
}
