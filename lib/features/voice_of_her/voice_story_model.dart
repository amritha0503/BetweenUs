import 'package:cloud_firestore/cloud_firestore.dart';

class VoiceStory {
  final String id;
  final String title;
  final String description;
  final String audioUrl;
  final String lesson;
  final DateTime? date; // Added date support (optional for now)

  VoiceStory({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.lesson,
    this.date,
  });

  /// Converts Firestore document into a VoiceStory model
  factory VoiceStory.fromMap(String id, Map<String, dynamic> data) {
    return VoiceStory(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      audioUrl: data['audioUrl'] ?? '',
      lesson: data['lesson'] ?? '',
      date: (data['date'] is Timestamp)
          ? (data['date'] as Timestamp).toDate()
          : null,
    );
  }

  /// Useful if you want to upload VoiceStory via admin interface
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'audioUrl': audioUrl,
      'lesson': lesson,
      'date': date != null ? Timestamp.fromDate(date!) : null,
    };
  }
}
