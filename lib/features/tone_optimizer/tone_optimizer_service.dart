import 'dart:convert';
import 'package:http/http.dart' as http;

/// ✅ Class to analyze the tone of a message using OpenAI
class ToneOptimizerService {
  final String apiKey;

  ToneOptimizerService(this.apiKey);

  Future<String> analyzeTone(String text) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You are an assistant that classifies the tone of user input. Respond with a single word tone label like: Validating, Blaming, Dismissive, Encouraging, Neutral, Aggressive, Supportive, etc."
          },
          {"role": "user", "content": text}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tone = data['choices'][0]['message']['content'].trim();
      return tone;
    } else {
      throw Exception('Failed to analyze tone: ${response.body}');
    }
  }
}
