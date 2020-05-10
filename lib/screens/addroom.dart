import 'package:flutter/material.dart';

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Room"),
      ),
      body: Center(
        child: Text("Creation form will appear here", style: TextStyle(fontSize: 25.0),),
      ),
    );
  }
}
