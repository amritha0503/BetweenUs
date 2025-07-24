import 'package:flutter/material.dart';

class StoryTextField extends StatelessWidget {
  final TextEditingController controller;

  const StoryTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 6,
      decoration: const InputDecoration(
        labelText: "Your story...",
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Story cannot be empty" : null,
    );
  }
}
