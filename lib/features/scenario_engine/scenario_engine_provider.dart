import 'package:flutter/material.dart';
import 'scenario_model.dart';
import 'scenario_engine_service.dart';

class ScenarioEngineProvider extends ChangeNotifier {
  final ScenarioEngineService _service;
  List<Scenario> scenarios = [];
  int currentScenario = 0;
  String? selectedFeedback;

  ScenarioEngineProvider(String apiKey)
      : _service = ScenarioEngineService(apiKey);

  Future<void> loadScenarios() async {
    scenarios = await _service.fetchScenarios();
    currentScenario = 0;
    selectedFeedback = null;
    notifyListeners();
  }

  void selectChoice(ScenarioChoice choice) {
    selectedFeedback = choice.feedback;
    notifyListeners();
  }

  void nextScenario() {
    if (currentScenario < scenarios.length - 1) {
      currentScenario++;
      selectedFeedback = null;
      notifyListeners();
    }
  }
}
