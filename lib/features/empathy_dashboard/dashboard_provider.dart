import 'package:flutter/material.dart';
import 'dashboard_model.dart';
import 'dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  final _service = DashboardService();
  List<EmpathyScore> scores = [];
  bool loading = true;

  Future<void> fetchScores(String userId) async {
    loading = true;
    notifyListeners();
    scores = await _service.getWeeklyScores(userId);
    loading = false;
    notifyListeners();
  }
}
