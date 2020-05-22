import 'package:flutter/material.dart';
import 'package:shareacab/screens/chatscreen/chat_models/chat_message.dart';

// ignore: must_be_immutable
class SenderBubble extends StatefulWidget {
  ChatMessage chatMessage;

  SenderBubble({@required this.chatMessage});
  @override
  _SenderBubbleState createState() => _SenderBubbleState();
}

class _SenderBubbleState extends State<SenderBubble> {
  @override
  Widget build(BuildContext context) {
     return !widget.chatMessage.sending ?Container(
       margin:  const EdgeInsets.only(left: 10.0, ),
              child: Text(
                widget.chatMessage.name,
    )):Container();
  }
}
