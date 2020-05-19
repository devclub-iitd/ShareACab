import 'package:shareacab/models/requestdetails.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/screens/addroom.dart';
import 'package:shareacab/screens/tripslist.dart';
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

  final List<RequestDetails> _allRequests = [];

  void _addNewRequest(
      String rqDest,
      String rqFinalDest,
      DateTime startDate,
      TimeOfDay startTime,
      DateTime endDate,
      TimeOfDay endTime,
      bool privacy) {
    final newRq = RequestDetails(
        name: 'Name',
        id: DateTime.now().toString(),
        destination: rqDest,
        finalDestination: rqFinalDest,
        startDate: startDate,
        startTime: startTime,
        endDate: endDate,
        endTime: endTime,
        privacy: privacy
    );
    setState(() {
      _allRequests.add(newRq);
    });
  }
  void _startCreatingRequests(BuildContext ctx){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
      ),
      context: ctx,
      builder: (_) {

        return GestureDetector(
          onTap: () {},
          child: NewRequest(_addNewRequest),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

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
          body: Column(
          children: <Widget>[
    Container(
    margin: EdgeInsets.all(5),
    height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom)*0.84 ,
    width: double.infinity,
    child: TripsList(_allRequests),
    ),
    ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () => _startCreatingRequests(context),
          child: Icon(Icons.add)
      ),
    );
  }
}
