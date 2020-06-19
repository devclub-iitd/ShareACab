import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Notification> notifications = [
    Notification(heading: 'Demo -1', message: 'This is one of the demo notifications and the message can be a very long text extending upto many lines and the card would adjust the size accordingly', type: 'Normal', dateTime: '20/05/2020'),
    Notification(heading: 'Warning', message: 'It has come to our notice that you are spamming different groups and disturbing the normal working of the app. We are thus giving you a warning. Any such behavior in future from your side may force us to ban you from using this app', type: 'Warning', dateTime: '20/05/2020'),
    Notification(heading: 'Demo -3', message: 'This is also another demo notifications', type: 'Normal', dateTime: '20/05/2020'),
    Notification(heading: 'Demo -3', message: 'This is also another demo notifications', type: 'Normal', dateTime: '20/05/2020'),
    Notification(heading: 'Demo -3', message: 'This is also another demo notifications', type: 'Normal', dateTime: '20/05/2020'),
    Notification(heading: 'Demo -3', message: 'This is also another demo notifications', type: 'Normal', dateTime: '20/05/2020'),
    Notification(heading: 'Demo -3', message: 'This is also another demo notifications', type: 'Normal', dateTime: '20/05/2020'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Notifications'),
          actions: <Widget>[],
        ),
        body: notifications.isEmpty
            ? Center(
                child: Text(
                  'No Notifications to show',
                  style: TextStyle(fontSize: 25.0),
                ),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: EdgeInsets.all(0.0),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListTile(
                      onTap: () {},
                      leading: notifications[index].type == 'Warning'
                          ? Icon(
                              Icons.warning,
                              color: warning(context),
                            )
                          : Icon(Icons.notifications),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${notifications[index].heading}',
                            style: TextStyle(color: notifications[index].type == 'Warning' ? warningHeading(context) : null, fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${notifications[index].dateTime}',
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '${notifications[index].message}',
                        style: TextStyle(fontSize: 15),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
                itemCount: notifications.length));
  }
}

class Notification {
  @required
  final String heading;
  @required
  final String message;
  @required
  @required
  final String type;
  @required
  final String dateTime;
  Notification({this.heading, this.message, this.type, this.dateTime});
}
