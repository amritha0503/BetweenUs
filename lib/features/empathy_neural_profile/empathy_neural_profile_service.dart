import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../services/openai_service.dart';
import 'empathy_neural_profile_model.dart';

class EmpathyNeuralProfileService {
  final OpenAIService _openAIService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EmpathyNeuralProfileService(String apiKey)
      : _openAIService = OpenAIService(apiKey);

  // 🔍 Analyze sentiment using OpenAI
  Future<String?> analyzeSentiment(String text) async {
    try {
      final sentiment = await _openAIService.analyzeSentiment(text);
      return sentiment;
    } catch (e) {
      debugPrint('Error analyzing sentiment: $e');
      return null;
    }
  }

  // 🔁 Save empathy profile to Firestore
  Future<void> saveProfile(EmpathyNeuralProfile profile) async {
    try {
      await _firestore
          .collection('empathy_profiles')
          .doc(profile.userId)
          .set(profile.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }
  }

  // 📥 Fetch empathy profile from Firestore
  Future<EmpathyNeuralProfile?> fetchProfile(String userId) async {
    try {
      final doc =
          await _firestore.collection('empathy_profiles').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return EmpathyNeuralProfile.fromMap(userId, doc.data()!);
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
    return null;
  }
}
