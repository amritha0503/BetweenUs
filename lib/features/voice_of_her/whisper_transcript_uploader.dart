import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> generateTranscriptUsingWhisper(File audioFile) async {
  final url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');
  final request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer YOUR_OPENAI_API_KEY'
    ..fields['model'] = 'whisper-1'
    ..files.add(await http.MultipartFile.fromPath('file', audioFile.path));

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final json = response.body;
    return json; // parse json['text'] if needed
  } else {
    print('Failed to generate transcript: ${response.statusCode}');
    return null;
  }
}
