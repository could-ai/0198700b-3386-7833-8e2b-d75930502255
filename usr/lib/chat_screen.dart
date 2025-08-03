import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(text: "Hi there!", isMe: false),
    Message(text: "Hello!", isMe: true),
    Message(text: "How are you?", isMe: false),
    Message(text: "I'm doing great, thanks! And you?", isMe: true),
  ];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.isNotEmpty) {
      setState(() {
        _messages.insert(0, Message(text: text, isMe: true));
        // Simulate a reply
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _messages.insert(0, Message(text: "I'm a bot, I can't reply yet.", isMe: false));
          });
        });
      });
    }
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    final align = message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = message.isMe ? Theme.of(context).colorScheme.primary : Colors.grey.shade300;
    final textColor = message.isMe ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}
