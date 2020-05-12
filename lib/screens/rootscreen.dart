import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'messages.dart';
import 'userprofile.dart';
import 'notifications.dart';
import 'myrequests.dart';
import 'filter.dart';
import 'settings.dart';
import 'addroom.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading ? Loading():
    Scaffold(
      appBar: AppBar(
        title:  Text('ShareACab'),

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter),
              color: Theme.of(context).accentColor,
              onPressed: (){
                return Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Filter();
                }));
              }),
          IconButton(
              icon: Icon(Icons.settings),
              color: Theme.of(context).accentColor,
              onPressed: (){
                return Navigator.push(context, MaterialPageRoute(builder:(context){
                  return Settings();
                }));
              }),
          FlatButton.icon(
            icon: Icon(Icons.person),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('Logout'),

          ),
          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              setState(() => loading = true);
              try {
                await _auth.signOut();
                setState(() => loading = false);
              } catch (e) {
                setState(() {
                  error = e.message;
                  setState(() => loading = false);
                });
              }
            },
            label: Text('Logout'),
          )
        ],
      ),

      body: Center(
          child: Text(
            'ShareACab',
            style: TextStyle(fontSize: 25.0),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child:  IconButton(
            icon: Icon(
              Icons.add,
            ),
            iconSize: 40.0,
            onPressed: (){
              return Navigator.push(context, MaterialPageRoute(builder: (context){
                return CreateRoom();
              }));
            }),
      ),
      bottomNavigationBar: BottomNavBar(),

    );
  }
}


class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex=0;
  @override

  Widget build(BuildContext context) {

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      iconSize: 20.0,
      items: [
        BottomNavigationBarItem(
            icon: IconButton(icon: Icon(Icons.home), onPressed: (){
              return Navigator.push(context, MaterialPageRoute(builder: (context){
                return RootScreen();
              }));
            },),
            title:  Text('Home'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),


        BottomNavigationBarItem(
            icon: IconButton(icon: Icon(Icons.format_list_bulleted), onPressed: (){
              return Navigator.push(context, MaterialPageRoute(builder: (context){
                return MyRequests();
              }));
            },),
            title:  Text('My Request'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),

        BottomNavigationBarItem(
            icon: IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: (){
              return Navigator.push(context, MaterialPageRoute(builder: (context){
                return Messages();
              }));
            },),
            title:  Text('Messages'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),



        BottomNavigationBarItem(
            icon: IconButton(icon: Icon(Icons.notifications_none), onPressed: (){
              return Navigator.push(context, MaterialPageRoute(builder: (context){
                return Notifications();
              }));
            },),
            title:  Text('Notifications'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),


        BottomNavigationBarItem(
            icon: IconButton(icon: Icon(Icons.person_outline), onPressed: (){
              return Navigator.push(context, MaterialPageRoute(builder: (context){
                return MyProfile();
              }));
            },),
            title:  Text('My Profile'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
