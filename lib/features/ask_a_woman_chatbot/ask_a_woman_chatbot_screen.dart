import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ask_a_woman_chatbot_provider.dart';
import 'chat_message_model.dart';

class AskAWomanChatbotScreen extends StatelessWidget {
  final String apiKey;
  const AskAWomanChatbotScreen({super.key, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AskAWomanChatbotProvider(apiKey),
      child: Consumer<AskAWomanChatbotProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(title: const Text("Ask-A-Woman Chatbot")),
            body: provider.selectedEmotion == null
                ? EmotionSelection(onSelected: provider.selectEmotion)
                : ChatInterface(provider: provider),
          );
        },
      ),
    );
  }
}

class EmotionSelection extends StatelessWidget {
  final void Function(String) onSelected;
  const EmotionSelection({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final emotions = ["happy", "in pain", "angry", "calm", "anxious"];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Select the woman's emotion:",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ...emotions.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                onPressed: () => onSelected(e),
                child: Text(e[0].toUpperCase() + e.substring(1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInterface extends StatefulWidget {
  final AskAWomanChatbotProvider provider;
  const ChatInterface({super.key, required this.provider});

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: provider.messages.length,
            itemBuilder: (context, i) {
              final msg = provider.messages[i];
              return Align(
                alignment: msg.sender == Sender.user
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg.sender == Sender.user
                        ? Colors.purple[100]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(msg.text),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    provider.sendMessage(_controller.text.trim());
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
