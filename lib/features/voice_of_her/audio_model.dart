import 'package:cloud_firestore/cloud_firestore.dart';

class VoiceOfHerModel {
  final String id;
  final String question;
  final String speaker;
  final String audioUrl;
  final String transcript;
  final DateTime date;

  VoiceOfHerModel({
    required this.id,
    required this.question,
    required this.speaker,
    required this.audioUrl,
    required this.transcript,
    required this.date,
  });

  factory VoiceOfHerModel.fromMap(Map<String, dynamic> data, String docId) {
    return VoiceOfHerModel(
      id: docId,
      question: data['question'],
      speaker: data['speaker'],
      audioUrl: data['audioUrl'],
      transcript: data['transcript'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
