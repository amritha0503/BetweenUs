enum Sender { user, bot }

class ChatMessage {
  final String text;
  final Sender sender;

  ChatMessage({required this.text, required this.sender});
}
