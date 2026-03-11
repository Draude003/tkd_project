import 'package:flutter/material.dart';
import '../../../../../models/chat_message.dart';
import '../widgets/chat_list.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatList(messages: dummyMessages);
  }
}