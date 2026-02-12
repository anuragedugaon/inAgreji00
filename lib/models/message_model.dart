class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  bool isFading;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isFading = false,
  });

  Message.user(String text)
      : this(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        );

  Message.ai(String text)
      : this(
          text: text,
          isUser: false,
          timestamp: DateTime.now(),
        );
}
