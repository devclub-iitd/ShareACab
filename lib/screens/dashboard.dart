import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shareacab/screens/filter.dart';
import 'package:shareacab/screens/settings.dart';
import 'package:shareacab/services/auth.dart';
import '../main.dart';
import 'addroom.dart';

class Dashboard extends StatefulWidget {
  final AuthService _auth;

  Dashboard(this._auth);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
              await pr.show();
              await Future.delayed(Duration(seconds: 1)); // sudden logout will show ProgressDialog for a very short time making it not very nice to see :p

              try {
                await widget._auth.signOut();
                await pr.hide();
              } catch(err) {
                // show e.message
                await pr.hide();
                String errStr = err.message ?? err.toString();
                final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            },
            label: Text('Logout'),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Dashboard will be shown here',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateRoom();
          }));
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
