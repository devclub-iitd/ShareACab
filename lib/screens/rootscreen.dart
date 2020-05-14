import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shareacab/screens/dashboard.dart';
import 'messages.dart';
import 'userprofile.dart';
import 'notifications.dart';
import 'myrequests.dart';
import 'filter.dart';
import 'settings.dart';
import 'addroom.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';
  Widget choose;
  String _appBarTitle = '';
  bool justLoggedin = true;
  bool isHome = true;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(_appBarTitle == '' ? 'Dashboard' : _appBarTitle),
              actions: isHome
                  ? <Widget>[
                      IconButton(
                          icon: Icon(Icons.filter_list),
                          iconSize: 30.0,
                          //color: Theme.of(context).accentColor,
                          color: Colors.black,
                          onPressed: () {
                            return Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Filter();
                            }));
                          }),
                      IconButton(
                          icon: Icon(Icons.settings),
                          //color: Theme.of(context).accentColor,
                          color: Colors.black,
                          onPressed: () {
                            return Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Settings();
                            }));
                          }),
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
                    ]
                  : <Widget>[
                      IconButton(
                          icon: Icon(Icons.settings),
                          //color: Theme.of(context).accentColor,
                          color: Colors.black,
                          onPressed: () {
                            return Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Settings();
                            }));
                          }),
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
            floatingActionButton: isHome
                ? FloatingActionButton(
                    onPressed: () {
                      return Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateRoom();
                      }));
                    },
                    child: Icon(
                      Icons.add,
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  )
                : null,
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              height: 50.0,
              items: <Widget>[
                Icon(
                  Icons.home,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
                Icon(
                  Icons.format_list_bulleted,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
                Icon(
                  Icons.notifications_none,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
                Icon(
                  Icons.person,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
              ],
              animationDuration: Duration(milliseconds: 200),
              index: 0,
              animationCurve: Curves.bounceInOut,
              onTap: (index) {
                setState(() {
                  justLoggedin = false;
                  switch (index) {
                    case 0:
                      choose = Dashboard();
                      _appBarTitle = 'Dashboard';
                      isHome = true;
                      break;
                    case 1:
                      choose = MyRequests();
                      _appBarTitle = 'My Requests';
                      isHome = false;
                      break;
                    case 2:
                      choose = Messages();
                      _appBarTitle = 'Messages';
                      isHome = false;
                      break;
                    case 3:
                      choose = Notifications();
                      _appBarTitle = 'Notifications';
                      isHome = false;
                      break;
                    case 4:
                      choose = MyProfile();
                      _appBarTitle = 'My Profile';
                      isHome = false;
                      break;
                    // default:
                    //   0;
                    // choose = Dashboard();
                    // _appBarTitle = 'Share A Cab';
                    // isHome = true;
                  }
                });
              },
            ),
            body: justLoggedin
                ? Center(
                    child: Dashboard(),
                  )
                : Center(
                    child: choose,
                  ),
          );
  }
}
