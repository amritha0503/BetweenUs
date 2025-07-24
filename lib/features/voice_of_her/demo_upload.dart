import 'package:cloud_firestore/cloud_firestore.dart';

class DemoUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadSampleStories() async {
    final stories = [
      {
        "title": "Respect at Work",
        "description":
            "A woman shares her story of being unheard and dismissed in the workplace.",
        "lesson": "Respect is the foundation of empathy.",
        "audioUrl": "https://your-audio-link.com/audio1.mp3",
      },
      {
        "title": "The Silent Tears",
        "description":
            "An emotional journey of a girl dealing with depression silently.",
        "lesson": "Listening without judgment can save lives.",
        "audioUrl": "https://your-audio-link.com/audio2.mp3",
      },
      {
        "title": "A Girl in STEM",
        "description":
            "A student shares how she was underestimated in her engineering class.",
        "lesson": "Encouragement builds confidence.",
        "audioUrl": "https://your-audio-link.com/audio3.mp3",
      },
      {
        "title": "Voice in a Marriage",
        "description":
            "A woman speaks about the emotional gap in her relationship.",
        "lesson": "Emotional support matters as much as responsibilities.",
        "audioUrl": "https://your-audio-link.com/audio4.mp3",
      },
      {
        "title": "Teen Joke Gone Wrong",
        "description":
            "A teenage girl recalls being constantly mocked by classmates.",
        "lesson": "Teasing isn't always funny to everyone.",
        "audioUrl": "https://your-audio-link.com/audio5.mp3",
      },
      {
        "title": "Public Transport Panic",
        "description":
            "A girl narrates her anxiety experience during a crowded bus ride.",
        "lesson": "Situational awareness helps make people feel safe.",
        "audioUrl": "https://your-audio-link.com/audio6.mp3",
      },
      {
        "title": "Judged by Clothes",
        "description":
            "She recalls being told her outfit was 'too bold' for an interview.",
        "lesson": "Competence is not defined by appearance.",
        "audioUrl": "https://your-audio-link.com/audio7.mp3",
      },
      {
        "title": "Ignored in Meetings",
        "description":
            "A software engineer explains how her suggestions were sidelined.",
        "lesson": "Every voice in the room deserves value.",
        "audioUrl": "https://your-audio-link.com/audio8.mp3",
      },
      {
        "title": "Emotional Labor at Home",
        "description":
            "A mother shares how she manages emotions for the whole family.",
        "lesson": "Appreciation is as vital as action.",
        "audioUrl": "https://your-audio-link.com/audio9.mp3",
      },
      {
        "title": "The Courage to Speak",
        "description": "A survivor talks about opening up about abuse.",
        "lesson": "Empathy gives people the strength to speak their truth.",
        "audioUrl": "https://your-audio-link.com/audio10.mp3",
      },
    ];

    for (var story in stories) {
      await _firestore.collection('voice_of_her').add(story);
    }

    print("✅ Uploaded 10 empathy stories to Firestore!");
  }
}
