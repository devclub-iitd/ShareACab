import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareacab/screens/createtrip.dart';
import 'package:shareacab/screens/tripslist.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shareacab/screens/filter.dart';
import 'package:shareacab/screens/settings.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/models/alltrips.dart';
import '../main.dart';

class Dashboard extends StatefulWidget {
  final AuthService _auth;
  Dashboard(this._auth);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void _startCreatingTrip(BuildContext ctx) async {
   await Navigator.of(ctx).pushNamed (
     CreateTrip.routeName,
    );
   setState(() {

   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_list),
              iconSize: 30.0,
              onPressed: () {
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return Filter();
                }));
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return Settings();
                }));
              }),
          FlatButton.icon(
            textColor: getActionBarIconColor(),
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              ProgressDialog pr;
              pr = ProgressDialog(context,
                  type: ProgressDialogType.Normal,
                  isDismissible: false,
                  showLogs: false);
              pr.style(
                message: 'Logging out...',
                backgroundColor: Theme.of(context).backgroundColor,
                messageTextStyle:
                    TextStyle(color: Theme.of(context).accentColor),
              );
              await pr.show();
              await Future.delayed(Duration(seconds: 1)); // sudden logout will show ProgressDialog for a very short time making it not very nice to see :p
              try {
                await widget._auth.signOut();
                await pr.hide();
              } catch (err) {
                // show e.message
                await pr.hide();
                String errStr = err.message ?? err.toString();
                final snackBar = SnackBar(
                    content: Text(errStr), duration: Duration(seconds: 3));
                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            },
            label: Text('Logout'),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.87,
            width: double.infinity,
            child: TripsList(allTrips),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          splashColor: Theme.of(context).primaryColor,
          onPressed: () => _startCreatingTrip(context),
          child: Icon(Icons.add),
      ),
    );
  }
}
