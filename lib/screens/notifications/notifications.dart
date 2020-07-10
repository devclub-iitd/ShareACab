import 'package:flutter/material.dart';
import './widgets/notifslist.dart';
import './services/notifservices.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotifServices _notifServices = NotifServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _notifServices.removeAll();
              },
              icon: Icon(Icons.delete),
              label: Text('Remove All'))
        ],
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
