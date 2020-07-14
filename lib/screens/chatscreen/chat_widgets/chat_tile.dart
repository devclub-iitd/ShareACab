import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_screen.dart';
import 'package:intl/intl.dart';

class ChatTile extends StatefulWidget {
  final Timestamp lastMessageAt;
  final String docId;
  final String destination;

  ChatTile(this.docId, this.destination, this.lastMessageAt);

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 0.15, color: Theme.of(context).accentColor),
      )),
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(widget.docId)));
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: widget.destination == 'New Delhi Railway Station' || widget.destination == 'Hazrat Nizamuddin Railway Station'
                ? Icon(
                    Icons.train,
                    color: getVisibleColorOnAccentColor(context),
                  )
                : widget.destination == 'Indira Gandhi International Airport'
                    ? Icon(
                        Icons.flight_takeoff,
                        color: getVisibleColorOnAccentColor(context),
                      )
                    : Icon(
                        Icons.directions_bus,
                        color: getVisibleColorOnAccentColor(context),
                      ),
          ),
        ),
        title: Text(
          widget.destination,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text(DateFormat.yMMMd().format(widget.lastMessageAt.toDate())),
      ),
    );
  }
}
