import '../../services/firestore_service.dart';
import 'voice_story_model.dart';

class VoiceOfHerService {
  final FirestoreService _firestore = FirestoreService();

  /// Fetches all stories from the "voice_of_her" collection in Firestore.
  /// Returns a list of [VoiceStory] objects.
  Future<List<VoiceStory>> fetchStories() async {
    try {
      final docs = await _firestore.getCollection('voice_of_her');
      return docs.map((doc) => VoiceStory.fromMap(doc.id, doc.data())).toList();
    } catch (e, stacktrace) {
      print('Error fetching voice stories: $e');
      print(stacktrace);
      return [];
    }
  }

  /// Fetches the story for today's date (used for notification + daily voice).
  Future<VoiceStory?> fetchTodayStory() async {
    try {
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);

      final docs = await _firestore.queryCollection(
        'voice_of_her',
        where: [
          {'field': 'date', 'isEqualTo': todayOnly},
        ],
      );

      if (docs.isEmpty) return null;

      return VoiceStory.fromMap(docs.first.id, docs.first.data());
    } catch (e, stacktrace) {
      print('Error fetching today\'s voice story: $e');
      print(stacktrace);
      return null;
    }
  }
}
