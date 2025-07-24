import 'package:flutter/material.dart';
import 'chat_message_model.dart';
import 'ask_a_woman_chatbot_service.dart';

class AskAWomanChatbotProvider extends ChangeNotifier {
  final AskAWomanChatbotService _service;

  AskAWomanChatbotProvider(String apiKey)
      : _service = AskAWomanChatbotService(apiKey);

  String? selectedEmotion;
  List<ChatMessage> messages = [];

  void selectEmotion(String emotion) {
    selectedEmotion = emotion;
    messages = [
      ChatMessage(
        text:
            "Hi! I'm here to chat as a woman feeling $emotion. Ask me anything.",
        sender: Sender.bot,
      ),
    ];
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    messages.add(ChatMessage(text: text, sender: Sender.user));
    notifyListeners();

    final botReply = await _service.getBotReply(
      text,
      selectedEmotion ?? "neutral",
    );
    messages.add(ChatMessage(text: botReply, sender: Sender.bot));
    notifyListeners();
  }
}
