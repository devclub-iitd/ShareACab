import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Center(
        child: Text('Messages will be shown here', style: TextStyle(fontSize: 25.0),),
      ),
    );
  }
}