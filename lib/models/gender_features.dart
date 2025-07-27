import 'package:flutter/material.dart';

class GenderFeatures {
  static Map<String, FeatureConfig> getMaleFeatures() {
    return {
      'ask_a_woman_chatbot': FeatureConfig(
        title: 'Ask a Woman',
        subtitle: 'Get insights from the feminine perspective',
        icon: Icons.chat_bubble_outline,
        color: Colors.pink,
      ),
      'empathy_neural_profile': FeatureConfig(
        title: 'Her Emotional Intelligence',
        subtitle: 'Understand feminine emotions better',
        icon: Icons.psychology,
        color: Colors.purple,
      ),
      'scenario_engine': FeatureConfig(
        title: 'Women\'s Scenarios',
        subtitle: 'Practice real situations with women',
        icon: Icons.book_outlined,
        color: Colors.indigo,
      ),
      'voice_of_her': FeatureConfig(
        title: 'Voice of Her',
        subtitle: 'Listen to women\'s stories',
        icon: Icons.mic_none_outlined,
        color: Colors.red,
      ),
      'mood_song_suggestion': FeatureConfig(
        title: 'Her Mood Music',
        subtitle: 'Songs that touch her heart',
        icon: Icons.music_note,
        color: Colors.orange,
      ),
    };
  }

  static Map<String, FeatureConfig> getFemaleFeatures() {
    return {
      'ask_a_woman_chatbot': FeatureConfig(
        title: 'Ask a Man',
        subtitle: 'Understand the masculine mindset',
        icon: Icons.chat_bubble_outline,
        color: Colors.blue,
      ),
      'empathy_neural_profile': FeatureConfig(
        title: 'His Emotional Intelligence',
        subtitle: 'Decode masculine emotions',
        icon: Icons.psychology,
        color: Colors.teal,
      ),
      'scenario_engine': FeatureConfig(
        title: 'Men\'s Scenarios',
        subtitle: 'Practice real situations with men',
        icon: Icons.book_outlined,
        color: Colors.indigo,
      ),
      'voice_of_her': FeatureConfig(
        title: 'Voice of Him',
        subtitle: 'Listen to men\'s perspectives',
        icon: Icons.mic_none_outlined,
        color: Colors.green,
      ),
      'mood_song_suggestion': FeatureConfig(
        title: 'His Mood Music',
        subtitle: 'Songs that move his soul',
        icon: Icons.music_note,
        color: Colors.cyan,
      ),
    };
  }

  static Map<String, FeatureConfig> getFeatures(String userGender) {
    return userGender == 'male' ? getMaleFeatures() : getFemaleFeatures();
  }
}

class FeatureConfig {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  FeatureConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
