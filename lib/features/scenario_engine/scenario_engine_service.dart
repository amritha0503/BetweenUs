import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/firestore_service.dart';
import 'scenario_model.dart';

class ScenarioEngineService {
  final FirestoreService _firestore = FirestoreService();
  final String apiKey;

  ScenarioEngineService(this.apiKey);

  Future<List<Scenario>> fetchScenarios() async {
    final docs = await _firestore.getCollection('scenario_engine');
    return docs.where((doc) => doc != null).map((doc) {
      final id = doc.id;
      final data = doc.data() as Map<String, dynamic>;
      return Scenario.fromMap({'id': id, ...data});
    }).toList();
  }

  Future<String?> analyzeSentiment(String text) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': 'gpt-4',
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a helpful assistant that analyzes the sentiment of the user\'s message. Respond with one word: positive, negative, or neutral.'
        },
        {'role': 'user', 'content': text}
      ],
      'max_tokens': 10,
      'temperature': 0.0,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim().toLowerCase();
      } else {
        print('OpenAI API error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('OpenAI API exception: $e');
      return null;
    }
  }
}
