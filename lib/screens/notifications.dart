import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/shared/constants.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Notifications will be shown here',
              style: TextStyle(fontSize: 25.0),
            ),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  hintText: 'Just a blank Field to check state save'),
            ),
          ],
        ),
      ),
    );
  }
}