import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'messages.dart';
import 'userprofile.dart';
import 'notifications.dart';
import 'myrequests.dart';
import 'filter.dart';
import 'settings.dart';
import 'addroom.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("ShareACab"),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.filter),
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.of(context).push( CupertinoPageRoute(builder: (BuildContext context) {
                  return Filter();
                }));
              }),
          new IconButton(
              icon: Icon(Icons.settings),
              color: Theme.of(context).accentColor,
              onPressed: (){
                Navigator.of(context).push( CupertinoPageRoute(builder: (BuildContext context) {
                  return Settings();
                }));
              })
        ],
      ),
      body: Center(
          child: Text(
        "ShareACab",
        style: TextStyle(fontSize: 25.0),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: new IconButton(
            icon: Icon(
              Icons.add,
            ),
            iconSize: 40.0,
            onPressed: (){
              Navigator.of(context).push( CupertinoPageRoute(builder: (BuildContext context) {
                return CreateRoom();
              }));
            }),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 20.0,
        items: [
           BottomNavigationBarItem(
              icon:  IconButton(icon: Icon(Icons.home), onPressed: null),
              title:  Text("Home"),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor),





           BottomNavigationBarItem(
              icon:  IconButton(
                  icon: Icon(Icons.format_list_bulleted), onPressed: (){
                    Navigator.of(context).push( CupertinoPageRoute(builder: (BuildContext context) {
                      return MyRequests();
                    }));
              }),
              title:  Text("My Request"),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor),




           BottomNavigationBarItem(
              icon:  IconButton(
                  icon: Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    Navigator.of(context).push(
                         CupertinoPageRoute(builder: (BuildContext context) {
                      return Messages();
                    }));
                  }),
              title:  Text("Messages"),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor),




           BottomNavigationBarItem(
              icon:  IconButton(
                  icon: Icon(Icons.notifications_none), onPressed: (){
                    Navigator.of(context).push( CupertinoPageRoute(builder: (BuildContext context) {
                      return Notifications();
                    }));
              }),
              title:  Text("Notifications"),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor),




           BottomNavigationBarItem(
              icon:  IconButton(
                  icon: Icon(Icons.person_outline),
                  onPressed: () {
                    Navigator.of(context).push(
                         CupertinoPageRoute(builder: (BuildContext context) {
                      return MyProfile();
                    }));
                  }),
              title:  Text("My Profile"),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
