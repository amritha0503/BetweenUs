import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dashboard_model.dart';

class DashboardDonutChart extends StatelessWidget {
  final EmpathyScore latest;
  const DashboardDonutChart(this.latest, {super.key});

  @override
  Widget build(BuildContext context) {
    final toneAwarenessTotal = latest.toneAwareness.values.fold<num>(0, (a, b) => a + b);
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
              value: latest.listening, title: '👂', color: Colors.blue),
          PieChartSectionData(
              value: latest.supportiveness, title: '🤝', color: Colors.green),
          if (toneAwarenessTotal > 0)
            PieChartSectionData(
                value: toneAwarenessTotal.toDouble(), title: '🗣', color: Colors.orange),
          PieChartSectionData(
              value: latest.empathyLevel, title: '🧠', color: Colors.purple),
        ],
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}
