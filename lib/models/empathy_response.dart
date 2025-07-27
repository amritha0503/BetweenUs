class EmpathyResponse {
  final String questionId;
  final String question;
  final String userAnswer;
  final double score;
  final String category;
  final String feedback;

  EmpathyResponse({
    required this.questionId,
    required this.question,
    required this.userAnswer,
    required this.score,
    required this.category,
    required this.feedback,
  });
}
