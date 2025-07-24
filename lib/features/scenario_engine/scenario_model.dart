class Scenario {
  final String id;
  final String prompt;
  final List<ScenarioChoice> choices;

  Scenario({
    required this.id,
    required this.prompt,
    required this.choices,
  });

  factory Scenario.fromMap(Map<String, dynamic> data) {
    return Scenario(
      id: data['id'] ?? '',
      prompt: data['prompt'] ?? '',
      choices: (data['choices'] as List<dynamic>? ?? [])
          .map((choice) => ScenarioChoice.fromMap(choice))
          .toList(),
    );
  }
}

class ScenarioChoice {
  final String text;
  final String feedback; // e.g. "This sounds dismissive", "Empathetic!"
  final String tone; // e.g. "Aggressive", "Empathetic", "Neutral"

  ScenarioChoice({
    required this.text,
    required this.feedback,
    required this.tone,
  });

  factory ScenarioChoice.fromMap(Map<String, dynamic> data) {
    return ScenarioChoice(
      text: data['text'] ?? '',
      feedback: data['feedback'] ?? '',
      tone: data['tone'] ?? '',
    );
  }
}
