import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    AutomaticKeepAliveClientMixin;
    return Scaffold(
      body:  Center(
          child:  Column(
            children: <Widget>[
              Text(
                'Notifs will be shown here',
                style: TextStyle(fontSize: 25.0),
              ),
              TextFormField(
                onChanged: (val) {
                },
              ),
            ],
          )),
    );
  }
}
