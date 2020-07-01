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
          GestureDetector(
            onTap: () async {
              await _notifServices.removeAll();
            },
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(color: Colors.white),
                ),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    Text('Remove All'),
                  ],
                )),
          )
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
