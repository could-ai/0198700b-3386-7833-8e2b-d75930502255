class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.createdAt,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'].toString(),
      text: map['text'],
      isMe: map['is_me'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
