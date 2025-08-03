class Message {
  final String id;
  final String text;
  final bool rightMe;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.text,
    required this.rightMe,
    required this.createdAt,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'].toString(),
      text: map['text'],
      rightMe: map['right_me'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
