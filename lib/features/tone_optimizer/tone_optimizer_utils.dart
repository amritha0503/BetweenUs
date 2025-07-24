import 'package:flutter/material.dart';

class ToneFeedback {
  final String label;
  final Color color;
  final String emoji;

  ToneFeedback(this.label, this.color, this.emoji);
}

class ToneUtils {
  static ToneFeedback getToneFeedback(String tone) {
    switch (tone.toLowerCase()) {
      case 'validating':
        return ToneFeedback('Validating', Colors.green, '💚');
      case 'supportive':
        return ToneFeedback('Supportive', Colors.teal, '🫂');
      case 'neutral':
        return ToneFeedback('Neutral', Colors.grey, '😐');
      case 'dismissive':
        return ToneFeedback('Dismissive', Colors.orange, '🚫');
      case 'blaming':
        return ToneFeedback('Blaming', Colors.red, '❌');
      case 'aggressive':
        return ToneFeedback('Aggressive', Colors.redAccent, '⚠️');
      default:
        return ToneFeedback('Unknown', Colors.black, '❓');
    }
  }
}
