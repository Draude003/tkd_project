import 'package:flutter/material.dart';
import '../../../../models/chat_message.dart';
import 'chat_tile.dart';

class ChatList extends StatelessWidget {
  final List<ChatMessage> messages;
  const ChatList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) => ChatTile(message: messages[index]),
    );
  }
}
