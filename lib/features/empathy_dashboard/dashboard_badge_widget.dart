import 'package:flutter/material.dart';
import 'dashboard_badge_utils.dart';

class DashboardBadgeWidget extends StatelessWidget {
  final double avgScore;
  const DashboardBadgeWidget(this.avgScore, {super.key});

  @override
  Widget build(BuildContext context) {
    final badge = getEmpathyBadge(avgScore);
    return Text("🏅 $badge", style: TextStyle(fontSize: 18));
  }
}
