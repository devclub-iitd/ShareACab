import 'package:shareacab/screens/chatscreen/chat_models/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';

// ignore: must_be_immutable
class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;

  ChatBubble({@required this.chatMessage});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.only(top: 13.0),
      padding: EdgeInsets.only(left: 1, right: 1, top: 10, bottom: 10),
      child: Align(
        alignment: (!widget.chatMessage.sending ? Alignment.topLeft : Alignment.topRight),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: (!widget.chatMessage.sending ? chatBubbleBackgroundColorReceiver : chatBubbleBackgroundColorSender),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                widget.chatMessage.message,
                style: TextStyle(color: getChatBubbleTextColor()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
