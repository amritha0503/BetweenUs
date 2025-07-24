import 'package:flutter/material.dart';

class EmotionDropdown extends StatelessWidget {
  final String? selectedEmotion;
  final Function(String?) onChanged;

  const EmotionDropdown(
      {super.key, required this.selectedEmotion, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final emotions = ['Happy', 'Sad', 'Angry', 'Anxious', 'Calm'];

    return DropdownButtonFormField<String>(
      value: selectedEmotion,
      items: emotions
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: "Emotion you felt"),
      validator: (value) => value == null ? "Select an emotion" : null,
    );
  }
}
