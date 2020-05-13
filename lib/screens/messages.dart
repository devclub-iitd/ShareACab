import 'package:flutter/material.dart';
import 'package:shareacab/chatscreen/chat_modules/chat_page.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChatPage(),

    );
  }
}