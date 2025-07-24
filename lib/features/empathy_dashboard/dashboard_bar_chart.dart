import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dashboard_model.dart';

class DashboardBarChart extends StatelessWidget {
  final List<EmpathyScore> scores;
  const DashboardBarChart(this.scores, {super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: scores.asMap().entries.map((entry) {
          int i = entry.key;
          var score = entry.value;
          return BarChartGroupData(x: i, barRods: [
            BarChartRodData(toY: score.empathyLevel, color: Colors.teal)
          ]);
        }).toList(),
      ),
    );
  }
}
