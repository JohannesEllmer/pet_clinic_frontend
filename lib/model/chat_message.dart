class ChatMessage {
  final String id;
  final String text;
  final bool fromUser;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.fromUser,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
    id: (j['id'] ?? '').toString(),
    text: (j['text'] ?? '').toString(),
    fromUser: (j['fromUser'] ?? true) == true,
    createdAt: DateTime.tryParse((j['createdAt'] ?? '').toString()) ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'text': text,
    'fromUser': fromUser,
  };
}
