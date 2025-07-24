import 'dart:convert';
import 'package:http/http.dart' as http;

class AskAWomanChatbotService {
  final String _openAiApiKey;
  final String _openAiApiUrl = 'https://api.openai.com/v1/chat/completions';

  AskAWomanChatbotService(this._openAiApiKey);

  Future<String> getBotReply(String userMessage, String emotion) async {
    final prompt =
        "You are a woman feeling $emotion. Respond to the user message accordingly.\nUser: $userMessage\nWoman:";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_openAiApiKey',
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": prompt}
      ],
      "max_tokens": 150,
      "temperature": 0.7,
    });

    try {
      final response = await http.post(Uri.parse(_openAiApiUrl),
          headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        return reply.trim();
      } else {
        return "Sorry, I couldn't process your request at the moment.";
      }
    } catch (e) {
      return "Error occurred: \$e";
    }
  }
}
