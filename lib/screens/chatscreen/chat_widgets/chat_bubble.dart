import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.username, this.isMe, {this.key});

  final Key key;
  final String username;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            width: 160,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.black : Theme.of(context).accentTextTheme.subtitle1.color,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.black : Theme.of(context).accentTextTheme.subtitle1.color,
                  ),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        left: isMe ?null :140,
        right: isMe ? 140 : null,
        child: CircleAvatar(
        ),
      ),
    ],
      overflow: Overflow.visible,
    );
  }
}
