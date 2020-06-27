import 'package:flutter/material.dart';
import './widgets/notifslist.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: NotifsList(),
            )
          ],
        ),
      ),
    );
  }
}
