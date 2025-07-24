import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/openai_service.dart';

class TestOpenAIScreen extends StatefulWidget {
  const TestOpenAIScreen({super.key});

  @override
  State<TestOpenAIScreen> createState() => _TestOpenAIScreenState();
}

class _TestOpenAIScreenState extends State<TestOpenAIScreen> {
  String? _response;
  bool _loading = false;

  Future<void> _testAPI() async {
    setState(() => _loading = true);

    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _response = 'Error: OPENAI_API_KEY is not set in .env';
        _loading = false;
      });
      return;
    }

    final service = OpenAIService(apiKey);
    final result = await service.analyzeSentiment("You always ignore me");

    setState(() {
      _response = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test OpenAI")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _testAPI,
                    child: const Text("Test OpenAI Sentiment"),
                  ),
                  const SizedBox(height: 20),
                  if (_response != null)
                    Text(
                      "Response: $_response",
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
      ),
    );
  }
}
