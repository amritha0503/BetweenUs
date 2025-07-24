class EmpathyScore {
  final double listening; // 👂 Ability to listen with focus
  final double supportiveness; // 🫂 Offering help or encouragement
  final Map<String, dynamic>
      toneAwareness; // 🗣️ Sensitivity to tone used, changed to Map
  final double empathyLevel; // 💖 Overall emotional understanding
  final DateTime date; // 📅 When the score was recorded

  EmpathyScore({
    required this.listening,
    required this.supportiveness,
    required this.toneAwareness,
    required this.empathyLevel,
    required this.date,
  });

  /// 🔁 Converts Firestore data + key to EmpathyScore object
  factory EmpathyScore.fromMap(Map<String, dynamic> data, String dateStr) {
    return EmpathyScore(
      listening: (data['listening'] ?? 0).toDouble(),
      supportiveness: (data['supportiveness'] ?? 0).toDouble(),
      toneAwareness: Map<String, dynamic>.from(data['toneAwareness'] ?? {}),
      empathyLevel: (data['empathyLevel'] ?? 0).toDouble(),
      date: DateTime.tryParse(dateStr) ?? DateTime.now(), // fallback to now
    );
  }

  /// 📤 Converts EmpathyScore to Map (useful for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'listening': listening,
      'supportiveness': supportiveness,
      'toneAwareness': toneAwareness,
      'empathyLevel': empathyLevel,
      'date': date.toIso8601String(),
    };
  }
}
