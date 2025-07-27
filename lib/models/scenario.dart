class Scenario {
  final String id;
  final String title;
  final String description;
  final String situation;
  final List<ScenarioOption> options;
  final String category;
  final int difficulty;
  final String lessonLearned;

  Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.situation,
    required this.options,
    required this.category,
    this.difficulty = 1,
    required this.lessonLearned,
  });
}

class ScenarioOption {
  final String id;
  final String text;
  final String response;
  final bool isCorrect;
  final String explanation;
  final int points;

  ScenarioOption({
    required this.id,
    required this.text,
    required this.response,
    this.isCorrect = false,
    required this.explanation,
    this.points = 10,
  });
}
