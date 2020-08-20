import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/rootscreen.dart';
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _notifServices.removeAll();
                },
                icon: Icon(
                  Icons.delete,
                  color: getVisibleColorOnPrimaryColor(context),
                ),
                label: Text(
                  'Remove All',
                  style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                ))
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
      ),
    );
  }
}
