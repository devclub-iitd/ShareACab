import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("ShareACab"),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.filter),
              color: Theme.of(context).accentColor,
              onPressed: null),
          new IconButton(
              icon: Icon(Icons.settings),
              color: Theme.of(context).accentColor,
              onPressed: null)
        ],
      ),
      body: Center(
          child: Text(
        "ShareACab",
        style: TextStyle(fontSize: 25.0),
      )),
      floatingActionButton:  FloatingActionButton(onPressed: null ,
      child: new IconButton(icon: Icon(Icons.add, ), iconSize: 40.0, onPressed: null),),
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 20.0,
          items: [

        new BottomNavigationBarItem(
            icon: new IconButton(icon: Icon(Icons.home), onPressed: null),
            title: new Text("Home"),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        new BottomNavigationBarItem(
            icon: new IconButton(icon: Icon(Icons.format_list_bulleted), onPressed: null),
            title: new Text("My Request"),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        new BottomNavigationBarItem(

            icon: new IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: null),
            title: new Text("Messages"),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        new BottomNavigationBarItem(
            icon: new IconButton(icon: Icon(Icons.notifications_none), onPressed: null),
            title: new Text("Notifications"),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        new BottomNavigationBarItem(
            icon: new IconButton(icon: Icon(Icons.person_outline), onPressed: null),
            title: new Text("My Profile"),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      ],
      onTap: (index){
            setState(() {
              _currentIndex = index;

            });
      },
      ),
    );
  }
}
