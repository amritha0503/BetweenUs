import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardToneChart extends StatelessWidget {
  final Map<String, dynamic> toneMap;

  const DashboardToneChart(this.toneMap, {super.key});

  @override
  Widget build(BuildContext context) {
    final total = toneMap.values.fold<num>(0, (a, b) => a + b);
    if (total == 0) return const Center(child: Text("No tone data yet."));

    final sections = toneMap.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.key} (${percentage.toStringAsFixed(1)}%)',
        radius: 50,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 30,
        sectionsSpace: 4,
      ),
    );
  }
}
