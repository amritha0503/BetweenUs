import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'empathy_neural_profile_provider.dart';

class EmpathyNeuralProfileScreen extends StatefulWidget {
  const EmpathyNeuralProfileScreen({Key? key}) : super(key: key);

  @override
  _EmpathyNeuralProfileScreenState createState() =>
      _EmpathyNeuralProfileScreenState();
}

class _EmpathyNeuralProfileScreenState
    extends State<EmpathyNeuralProfileScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _sentiment;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmpathyNeuralProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empathy Neural Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to analyze sentiment',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) async {
                if (text.isNotEmpty) {
                  final sentiment = await provider.analyzeSentiment(text);
                  setState(() {
                    _sentiment = sentiment;
                  });
                } else {
                  setState(() {
                    _sentiment = null;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            if (_sentiment != null)
              Text(
                'Sentiment: $_sentiment',
                style: TextStyle(
                  fontSize: 18,
                  color: _sentiment == 'positive'
                      ? Colors.green
                      : _sentiment == 'negative'
                          ? Colors.red
                          : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
