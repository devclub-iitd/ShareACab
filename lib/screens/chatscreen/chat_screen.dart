import 'package:flutter/material.dart';
import 'package:shareacab/screens/chatscreen/chat_widgets/new_message.dart';
import 'package:shareacab/screens/chatscreen/chat_widgets/message.dart';

class ChatScreen extends StatelessWidget {
  final String docId;
  ChatScreen(this.docId);
  static const routeName = '/chatScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Chat'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: MessageScreen(docId),
            ),
            NewMessage(docId),
          ],
        ),
      ),
    );
  }
}
