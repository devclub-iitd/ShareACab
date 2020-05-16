import 'package:flutter/material.dart';
import 'addroom.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Dashboard will be shown here',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateRoom();
          }));
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
