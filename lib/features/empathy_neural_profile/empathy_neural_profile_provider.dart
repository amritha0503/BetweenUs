import 'package:flutter/foundation.dart';
import '../../services/openai_service.dart';
import 'empathy_neural_profile_service.dart';
import 'empathy_neural_profile_model.dart';

class EmpathyNeuralProfileProvider extends ChangeNotifier {
  final EmpathyNeuralProfileService _service;
  EmpathyNeuralProfile? profile;

  EmpathyNeuralProfileProvider(String apiKey)
      : _service = EmpathyNeuralProfileService(apiKey);

  /// 🧠 Load profile from Firestore
  Future<void> loadProfile(String userId) async {
    profile = await _service.fetchProfile(userId);

    profile ??= EmpathyNeuralProfile(
      userId: userId,
      toneScores: {},
      blindSpots: [],
      preferredTone: 'neutral',
      feedbackHistory: [],
    );

    notifyListeners();
  }

  /// 🔍 Analyze sentiment using OpenAI
  Future<String?> analyzeSentiment(String text) async {
    try {
      final sentiment = await _service.analyzeSentiment(text);
      return sentiment;
    } catch (e) {
      debugPrint('Error analyzing sentiment: $e');
      return null;
    }
  }

  /// 📊 Update tone score
  Future<void> updateTone(String tone) async {
    if (profile == null) return;

    profile!.toneScores[tone] = (profile!.toneScores[tone] ?? 0) + 1;
    await _service.saveProfile(profile!);
    notifyListeners();
  }

  /// 📝 Add feedback to history
  Future<void> addFeedback(String feedback) async {
    if (profile == null) return;

    profile!.feedbackHistory.add(feedback);
    await _service.saveProfile(profile!);
    notifyListeners();
  }

  /// ⚙️ Update preferred tone
  Future<void> setPreferredTone(String tone) async {
    if (profile == null) return;

    profile!.preferredTone = tone;
    await _service.saveProfile(profile!);
    notifyListeners();
  }

  /// ⚠️ Add blind spot
  Future<void> addBlindSpot(String issue) async {
    if (profile == null || profile!.blindSpots.contains(issue)) return;

    profile!.blindSpots.add(issue);
    await _service.saveProfile(profile!);
    notifyListeners();
  }
}
