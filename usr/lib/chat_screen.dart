import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final _messagesStream = Supabase.instance.client
      .from('messages')
      .stream(primaryKey: ['id']).order('created_at', ascending: false);

  void _handleSubmitted(String text) async {
    _textController.clear();
    if (text.isNotEmpty) {
      try {
        await Supabase.instance.client
            .from('messages')
            .insert({'text': text, 'right_me': true});
      } catch (e) {
        // Handle error, maybe show a snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ));
        }
      }
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
              decoration:
                  const InputDecoration.collapsed(hintText: "Send a message"),
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
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet. Start chatting!'));
                }

                final messages =
                    snapshot.data!.map((map) => Message.fromMap(map)).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) {
                    final message = messages[index];
                    return _buildMessage(message);
                  },
                  itemCount: messages.length,
                );
              },
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
    final align =
        message.rightMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = message.rightMe
        ? Theme.of(context).colorScheme.primary
        : Colors.grey.shade300;
    final textColor = message.rightMe ? Colors.white : Colors.black;

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
