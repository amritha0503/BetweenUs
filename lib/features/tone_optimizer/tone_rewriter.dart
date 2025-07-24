import 'dart:convert';
import 'package:http/http.dart' as http;

class ToneRewriter {
  final String openAiApiKey;

  ToneRewriter(this.openAiApiKey);

  Future<String> suggestBetterVersion(String text) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAiApiKey',
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              "You are an emotional intelligence coach. Given a message, suggest a more empathetic or emotionally aware rewrite. Keep it short and keep the meaning."
        },
        {
          "role": "user",
          "content":
              "Rewrite this message in a more emotionally sensitive tone: \"$text\""
        }
      ],
      "temperature": 0.7,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final suggestion = data['choices'][0]['message']['content'].trim();
      return suggestion;
    } else {
      throw Exception("Failed to rewrite: ${response.body}");
    }
  }
}
