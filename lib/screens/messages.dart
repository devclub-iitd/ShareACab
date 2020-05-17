import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_modules/chat_page.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: !isSearching ? Text('Messages') : TextField(decoration: InputDecoration(hintText: 'Search'),), iconButton: IconButton(icon: Icon(Icons.search), onPressed: (){
      setState(() {
        isSearching = !isSearching;
      });
      }),),

      body:  ChatPage()
    );
  }
}
