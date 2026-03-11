import 'package:flutter/material.dart';
import '../../../../models/chat_message.dart';

class ChatTile extends StatelessWidget {
  final ChatMessage message;
  const ChatTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: const Color.fromARGB(255, 0, 124, 161),
        child: Text(
          message.avatarInitial,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      title: Text(
        message.senderName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        message.isYou ? 'You: ${message.lastMessage}' : message.lastMessage,
        style: TextStyle(
          color: const Color.fromARGB(255, 66, 66, 66),
          fontSize: 13,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        message.time,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
      onTap: () {
        // TODO: navigate to conversation screen
      },
    );
  }
}
