class ChatSession {
  final int id;
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String avatar;

  ChatSession({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatar,
  });
}
