import 'package:flutter/material.dart';
import 'scenario_model.dart';

class ScenarioChoiceTile extends StatelessWidget {
  final ScenarioChoice choice;
  final VoidCallback onTap;
  final bool selected;

  const ScenarioChoiceTile({
    super.key,
    required this.choice,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(choice.text),
      tileColor: selected ? Colors.purple[100] : null,
      onTap: onTap,
    );
  }
}
