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
