import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_models/chat_message.dart';

class SenderBubble extends StatefulWidget {
  ChatMessage chatMessage;

  SenderBubble({@required this.chatMessage});
  @override
  _SenderBubbleState createState() => _SenderBubbleState();
}

class _SenderBubbleState extends State<SenderBubble> {
  @override
  Widget build(BuildContext context) {
     return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
      child: Align(
        alignment: (widget.chatMessage.sending == false ? Alignment.topLeft : Alignment.topRight),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: (widget.chatMessage.sending == false ? chatBubbleBackgroundColorReceiver : chatBubbleBackgroundColorSender),
              ),
              padding: EdgeInsets.all(2),
              child: Text(
                widget.chatMessage.name,
                style: TextStyle(color: getChatBubbleTextColor()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
