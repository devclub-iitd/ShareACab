import 'package:flutter/material.dart';
import 'package:shareacab/screens/chatscreen/chat_widgets/new_message.dart';
import 'package:shareacab/screens/chatscreen/chat_widgets/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  final String docId;
  ChatScreen(this.docId);
  static const routeName = '/chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState(){
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure();
    super.initState();
  }

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
              child: MessageScreen(widget.docId),
            ),
            NewMessage(widget.docId),
          ],
        ),
      ),
    );
  }
}
