import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareacab/screens/dashboard.dart';
import 'messages.dart';
import 'profile/userprofile.dart';
import 'notifications/notifications.dart';
import 'requests/myrequests.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';
  Widget choose;

  // String _appBarTitle = '';
  bool justLoggedin = true;
  bool isHome = true;

  int _selectedPage = 0;

  List<Widget> pagelist = <Widget>[];

  @override
  void initState() {
    pagelist.add(Dashboard(_auth));
    pagelist.add(MyRequests());
    pagelist.add(Messages());
    pagelist.add(Notifications());
    pagelist.add(MyProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            bottomNavigationBar:
            CurvedNavigationBar(
              color: Theme.of(context).bottomAppBarColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              height: 60.0,
              items: <Widget>[
                Icon(
                  FontAwesomeIcons.home,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                  //color: Colors.black,
                ),
                Icon(
                  Icons.format_list_bulleted,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
                Icon(
                  _selectedPage ==2 ?
                  Icons.chat_bubble : Icons.chat_bubble_outline,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
                Icon(
                  _selectedPage ==3 ?
                  Icons.notifications : Icons.notifications_none ,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
                Icon(
                  _selectedPage ==4 ?
                  Icons.person : Icons.person_outline ,
                  size: 20.0,
                  color: Theme.of(context).accentColor,
                ),
              ],
              animationDuration: Duration(milliseconds: 200),
              index: 0,
              animationCurve: Curves.bounceInOut,
              onTap: (index) {
                setState(() {
                  _selectedPage = index;
                });
              },
            ),

            // body: justLoggedin
            //     ? Center(
            //         child: Dashboard(),
            //       )
            //     : Center(
            //         child: choose,
            //       ),
            body: IndexedStack(
              index: _selectedPage,
              children: pagelist,
            ),
          );
  }
}
