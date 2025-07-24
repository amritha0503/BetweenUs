import 'package:flutter/material.dart';

class ToneDropdown extends StatelessWidget {
  final String? selectedTone;
  final Function(String?) onChanged;

  const ToneDropdown(
      {super.key, required this.selectedTone, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tones = [
      'Supportive',
      'Dismissive',
      'Blaming',
      'Neutral',
      'Validating'
    ];

    return DropdownButtonFormField<String>(
      value: selectedTone,
      items: tones
          .map((tone) => DropdownMenuItem(value: tone, child: Text(tone)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: "Tone of the other person"),
      validator: (value) => value == null ? "Select a tone" : null,
    );
  }
}
