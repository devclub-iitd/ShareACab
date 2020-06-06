import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/createtrip.dart';
import 'package:shareacab/screens/groupscreen/group.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // List<RequestDetails> _listOfTrips = allTrips;
  List<RequestDetails> filtered = allTrips;
  bool _dest = false;
  bool _date = false;
  bool _time = false;
  String _selecteddest;
  DateTime _SD;
  TimeOfDay _ST;
  DateTime _ED;
  TimeOfDay _ET;

  //String groupID = null;
  bool inGroup = false;

  void _filteredList(filtered, destination, date, time, dest, sdate, stime, edate, etime) {
    _dest = destination;
    _date = date;
    _time = time;
    _selecteddest = dest;
    _SD = sdate;
    _ST = stime;
    _ED = edate;
    _ET = etime;
    // _listOfTrips = filtered;
    setState(() {});
  }

  @override
  void initState() {
    // _listOfTrips = filtered;

    super.initState();
  }

  void _startFilter(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Filter(_filteredList, _dest, _date, _time, _selecteddest, _SD, _ST, _ED, _ET);
      },
    );
  }

  void _startCreatingTrip(BuildContext ctx) async {
    await Navigator.of(ctx).pushNamed(
      CreateTrip.routeName,
    );
    setState(() {});
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // _listOfTrips = filtered;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    Firestore.instance.collection('userdetails').document(currentuser.uid).get().then((value) {
      if (value.data['currentGroup'] != null) {
        setState(() {
          inGroup = true;
        });
      } else {
        setState(() {
          inGroup = false;
        });
      }
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_list),
              tooltip: 'Filter',
              iconSize: 30.0,
              onPressed: () {
                _startFilter(context);
              }),
          IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Settings',
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
                scaffoldKey.currentState.showSnackBar(snackBar);
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
            inGroup
                ? Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: Text('Already in group. Press the button below.'),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.all(5),
              height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.87,
              width: double.infinity,
              child: RefreshIndicator(
                child: TripsList(),
                onRefresh: refreshList,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: !inGroup
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
              child: FloatingActionButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () => _startCreatingTrip(context),
                child: Tooltip(
                  message: 'Create Group',
                  verticalOffset: -60,
                  child: Icon(Icons.add),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
              child: FloatingActionButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage()));
                },
                child: Tooltip(
                  message: 'Group Details',
                  verticalOffset: -60,
                  child: Icon(Icons.group),
                ),
              ),
            ),
    );
  }
}
