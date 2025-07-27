class EmpathyNeuralProfile {
  String userId;
  Map<String, int> toneScores;
  List<String> blindSpots;
  String preferredTone;
  List<String> feedbackHistory;

  EmpathyNeuralProfile({
    required this.userId,
    required this.toneScores,
    required this.blindSpots,
    required this.preferredTone,
    required this.feedbackHistory,
  });

  factory EmpathyNeuralProfile.fromMap(
    String userId,
    Map<String, dynamic> data,
  ) {
    return EmpathyNeuralProfile(
      userId: userId,
      toneScores: Map<String, int>.from(data['toneScores'] ?? {}),
      blindSpots: List<String>.from(data['blindSpots'] ?? []),
      preferredTone: data['preferredTone'] ?? 'neutral',
      feedbackHistory: List<String>.from(data['feedbackHistory'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'toneScores': toneScores,
      'blindSpots': blindSpots,
      'preferredTone': preferredTone,
      'feedbackHistory': feedbackHistory,
    };
  }
}

// ✅ ADD THIS BELOW

class EmpathyScore {
  final String date;
  final int listening;
  final int supportiveness;
  final int empathyLevel;
  final Map<String, dynamic> toneAwareness;

  EmpathyScore({
    required this.date,
    required this.listening,
    required this.supportiveness,
    required this.empathyLevel,
    required this.toneAwareness,
  });

  factory EmpathyScore.fromMap(Map<String, dynamic> map, String date) {
    return EmpathyScore(
      date: date,
      listening: map['listening'] ?? 0,
      supportiveness: map['supportiveness'] ?? 0,
      empathyLevel: map['empathyLevel'] ?? 0,
      toneAwareness: Map<String, dynamic>.from(map['toneAwareness'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'listening': listening,
      'supportiveness': supportiveness,
      'empathyLevel': empathyLevel,
      'toneAwareness': toneAwareness,
    };
  }
}

// Add integration methods to work with the new EmpathyProfile system
extension EmpathyNeuralProfileExtension on EmpathyNeuralProfile {
  // Convert to the new EmpathyProfile format
  Map<String, double> get categoryScores {
    return {
      'Emotional Intelligence': (toneScores['empathy'] ?? 0).toDouble(),
      'Active Listening': (toneScores['listening'] ?? 0).toDouble(),
      'Non-Verbal Awareness': (toneScores['awareness'] ?? 0).toDouble(),
      'Conflict Resolution': (toneScores['conflict'] ?? 0).toDouble(),
    };
  }

  double get overallEmpathyScore {
    final scores = categoryScores.values;
    return scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
  }

  List<String> get strengths {
    return toneScores.entries
        .where((entry) => entry.value >= 80)
        .map((entry) => _mapToneToCategory(entry.key))
        .toList();
  }

  List<String> get improvementAreas {
    final areas = toneScores.entries
        .where((entry) => entry.value < 60)
        .map((entry) => _mapToneToCategory(entry.key))
        .toList();
    areas.addAll(blindSpots);
    return areas;
  }

  String _mapToneToCategory(String tone) {
    switch (tone) {
      case 'empathy':
        return 'Emotional Intelligence';
      case 'listening':
        return 'Active Listening';
      case 'awareness':
        return 'Non-Verbal Awareness';
      case 'conflict':
        return 'Conflict Resolution';
      default:
        return tone;
    }
  }
}
