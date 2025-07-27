import 'empathy_response.dart';

class EmpathyProfile {
  final String userId;
  final double emotionalIntelligence;
  final double activeListening;
  final double nonVerbalAwareness;
  final double conflictResolution;
  final double empathyScore;
  final Map<String, double> categoryScores;
  final List<String> strengths;
  final List<String> improvementAreas;
  final DateTime lastUpdated;

  EmpathyProfile({
    required this.userId,
    required this.emotionalIntelligence,
    required this.activeListening,
    required this.nonVerbalAwareness,
    required this.conflictResolution,
    required this.empathyScore,
    required this.categoryScores,
    required this.strengths,
    required this.improvementAreas,
    required this.lastUpdated,
  });

  String get overallGrade {
    if (empathyScore >= 90) return 'Excellent';
    if (empathyScore >= 80) return 'Very Good';
    if (empathyScore >= 70) return 'Good';
    if (empathyScore >= 60) return 'Fair';
    return 'Needs Improvement';
  }

  factory EmpathyProfile.fromResponses(List<EmpathyResponse> responses) {
    // Calculate scores based on responses
    final categoryScores = <String, double>{};
    final responsesByCategory = <String, List<EmpathyResponse>>{};

    // Group responses by category
    for (var response in responses) {
      responsesByCategory
          .putIfAbsent(response.category, () => [])
          .add(response);
    }

    // Calculate category scores
    for (var entry in responsesByCategory.entries) {
      final totalScore = entry.value.fold(0.0, (sum, r) => sum + r.score);
      final avgScore = totalScore / entry.value.length;
      categoryScores[entry.key] = avgScore;
    }

    final emotionalIntelligence =
        categoryScores['Emotional Intelligence'] ?? 0.0;
    final activeListening = categoryScores['Active Listening'] ?? 0.0;
    final nonVerbalAwareness = categoryScores['Non-Verbal Awareness'] ?? 0.0;
    final conflictResolution = categoryScores['Conflict Resolution'] ?? 0.0;

    final empathyScore = (emotionalIntelligence +
            activeListening +
            nonVerbalAwareness +
            conflictResolution) /
        4;

    // Determine strengths and improvement areas
    final strengths = <String>[];
    final improvementAreas = <String>[];

    categoryScores.forEach((category, score) {
      if (score >= 80) {
        strengths.add(category);
      } else if (score < 60) {
        improvementAreas.add(category);
      }
    });

    return EmpathyProfile(
      userId: 'current_user',
      emotionalIntelligence: emotionalIntelligence,
      activeListening: activeListening,
      nonVerbalAwareness: nonVerbalAwareness,
      conflictResolution: conflictResolution,
      empathyScore: empathyScore,
      categoryScores: categoryScores,
      strengths: strengths,
      improvementAreas: improvementAreas,
      lastUpdated: DateTime.now(),
    );
  }
}
