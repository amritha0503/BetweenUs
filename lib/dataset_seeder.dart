import 'package:flutter/material.dart';
import 'services/firestore_service.dart';

class DatasetSeeder {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> seedEmpathyNeuralProfile() async {
    final collection = 'empathy_neural_profiles';
    final userId = 'test_user'; // Use a test user ID or generate dynamically
    final data = {
      'userId': userId,
      'toneScores': {'happy': 5, 'sad': 2, 'neutral': 3},
      'blindSpots': ['impatience', 'overthinking'],
      'preferredTone': 'friendly',
      'feedbackHistory': ['Great listener', 'Needs improvement in empathy'],
    };
    await _firestoreService.setDocument(collection, userId, data);
  }

  Future<void> seedScenarioEngine() async {
    final collection = 'scenario_engine';
    final scenarios = [
      {
        'id': 'scenario1',
        'prompt': 'How would you respond to a friend in pain?',
        'choices': [
          {'text': 'Offer support', 'feedback': 'Good choice'},
          {'text': 'Ignore', 'feedback': 'Not recommended'},
        ],
      },
      {
        'id': 'scenario2',
        'prompt': 'How to handle anger in a conversation?',
        'choices': [
          {'text': 'Stay calm', 'feedback': 'Good choice'},
          {'text': 'Raise voice', 'feedback': 'Not recommended'},
        ],
      },
    ];
    for (var scenario in scenarios) {
      final id = scenario['id'] as String;
      await _firestoreService.setDocument(collection, id, scenario);
    }
  }

  Future<void> seedVoiceOfHer() async {
    final collection = 'voice_of_her';
    final stories = [
      {
        'id': 'story1',
        'title': 'Overcoming Challenges',
        'content': 'Story content here...',
      },
      {
        'id': 'story2',
        'title': 'Finding Strength',
        'content': 'Story content here...',
      },
    ];
    for (var story in stories) {
      final id = story['id'] as String;
      await _firestoreService.setDocument(collection, id, story);
    }
  }

  Future<void> seedAskAWomanChatbot() async {
    final collection = 'ask_a_woman_chatbot';
    final emotions = [
      {
        'id': 'happy',
        'responses': ['That\'s wonderful!', 'Glad to hear that!'],
      },
      {
        'id': 'angry',
        'responses': ['Take a deep breath.', 'Let\'s calm down.'],
      },
    ];
    for (var emotion in emotions) {
      final id = emotion['id'] as String;
      await _firestoreService.setDocument(collection, id, emotion);
    }
  }

  Future<void> seedAll() async {
    await seedEmpathyNeuralProfile();
    await seedScenarioEngine();
    await seedVoiceOfHer();
    await seedAskAWomanChatbot();
  }
}
