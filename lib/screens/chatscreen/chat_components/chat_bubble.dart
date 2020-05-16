import 'package:shareacab/screens/chatscreen/chat_models/chat_message.dart';
import 'package:shareacab/screens/chatscreen/chat_modules/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';

// ignore: must_be_immutable
class ChatBubble extends StatefulWidget{
  ChatMessage chatMessage;
  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.Receiver ? Alignment
            .topLeft : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.chatMessage.type == MessageType.Receiver ? Colors.grey : Colors.grey),
//            HERE, BOTH RECEIVER MESSAGE COLOR AND SENDER MESSAGE COLOR NEEDS TO BE CHANGED
//            (SUITABLE COLORS FOR DIFFERENT THEMES MUST BE DECIDED)
          ),
          padding: EdgeInsets.all(16),
          child: Text(widget.chatMessage.message),
        ),
      ),
    );
  }
}