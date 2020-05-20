import 'package:flutter/material.dart';

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests'),
      ),
      body: Center(
        child: Text(
          'Requests will be shown here',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }
}
