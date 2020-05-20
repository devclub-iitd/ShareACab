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
import 'package:shareacab/models/requestdetails.dart';

class Dashboard extends StatefulWidget {
  final AuthService _auth;
  Dashboard(this._auth);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<RequestDetails> _listOfTrips = allTrips;
  bool _dest = false;
  bool _date = false;
  bool _time = false;
  String _selecteddest;
  DateTime _SD;
  TimeOfDay _ST;
  DateTime _ED;
  TimeOfDay _ET;

  void _filteredList(filtered, destination, date, time, dest, sdate, stime, edate, etime){
    _dest = destination;
    _date = date;
    _time = time;
    _selecteddest = dest;
    _SD = sdate;
    _ST = stime;
    _ED = edate;
    _ET = etime;
    _listOfTrips = filtered;
    setState(() {
    });
  }

  void _startFilter (BuildContext ctx){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
      ),
      backgroundColor: Theme.of(context).accentColor,
      context: ctx,
      builder: (_) {
        return GestureDetector (
          onTap: () {},
          child: Filter(_filteredList, _dest, _date, _time, _selecteddest, _SD, _ST, _ED, _ET),
          behavior: HitTestBehavior.opaque,
        );
      },);
  }

  void _startCreatingTrip(BuildContext ctx) async {
    await Navigator.of(ctx).pushNamed(
      CreateTrip.routeName,
    );
 setState(() {});
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
              onPressed: () {_startFilter(context);}
              ),

          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                return Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Settings();
                }));
              }),
          FlatButton.icon(
            textColor: getVisibleColorOnPrimaryColor(context),
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              ProgressDialog pr;
              pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
              pr.style(
                message: 'Logging out...',
                backgroundColor: Theme.of(context).backgroundColor,
                messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
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
                final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            },
            label: Text('Logout'),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.87,
              width: double.infinity,
              child: TripsList(_listOfTrips),
            ),
          ],
        ),
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
