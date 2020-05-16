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
  bool justLoggedin = true;
  bool isHome = true;

  int _selectedPage = 0;

  List<Widget> pagelist = <Widget>[];

  @override
  void initState() {
    pagelist.add(Dashboard());
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
      appBar: isHome ? AppBar(title: Text('Share A Cab'),actions: <Widget>[
        IconButton(icon: Icon(Icons.filter_list), onPressed: (){
          return Navigator.push(context, MaterialPageRoute(builder: (context){
            return Filter();
          }));
        }),
        IconButton(icon: Icon(Icons.settings), onPressed: (){
          return Navigator.push(context, MaterialPageRoute(builder: (context){
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

      ],) : null,
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
            _selectedPage = index;
            switch (index) {
              case 0:
                choose = Dashboard();
                isHome = true;
                break;
              case 1:
                choose = MyRequests();
                isHome = false;
                break;
              case 2:
                choose = Messages();
                isHome = false;
                break;
              case 3:
                choose = Notifications();
                isHome = false;
                break;
              case 4:
                choose = MyProfile();
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
      // body: justLoggedin
      //     ? Center(
      //         child: Dashboard(),
      //       )
      //     : Center(
      //         child: choose,
      //       ),
      body: justLoggedin
          ? Center(
        child: Dashboard(),
      )
          : IndexedStack(
        index: _selectedPage,
        children: pagelist,
      ),
    );
  }
}