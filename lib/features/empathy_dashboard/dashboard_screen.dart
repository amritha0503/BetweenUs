import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_provider.dart';
import 'dashboard_bar_chart.dart';
import 'dashboard_donut_chart.dart';
import 'dashboard_badge_widget.dart';
import 'dashboard_tone_chart.dart'; // ✅ NEW chart for tone awareness

class EmpathyDashboardScreen extends StatefulWidget {
  final String userId;
  const EmpathyDashboardScreen({required this.userId, super.key});

  @override
  State<EmpathyDashboardScreen> createState() => _EmpathyDashboardScreenState();
}

class _EmpathyDashboardScreenState extends State<EmpathyDashboardScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    provider.fetchScores(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final scores = provider.scores;
        if (scores.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No empathy data yet 😔")),
          );
        }

        final latest = scores.last;
        final avg = scores.map((s) => s.empathyLevel).reduce((a, b) => a + b) /
            scores.length;

        return Scaffold(
          appBar: AppBar(title: const Text("Empathy Dashboard")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              // 👉 Allows scrolling
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("📊 Weekly Progress",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 200, child: DashboardBarChart(scores)),
                  const SizedBox(height: 20),
                  const Text("🍩 Trait Breakdown",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 150, child: DashboardDonutChart(latest)),
                  const SizedBox(height: 20),
                  DashboardBadgeWidget(avg),
                  const SizedBox(height: 20),
                  if (latest.toneAwareness.isNotEmpty) ...{
                    const Text("🎯 Tone Awareness Breakdown",
                        style: TextStyle(fontSize: 18)),
                    SizedBox(
                        height: 200,
                        child: DashboardToneChart(latest.toneAwareness)),
                  },
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
