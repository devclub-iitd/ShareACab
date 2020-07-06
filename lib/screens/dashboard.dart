import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/createtrip.dart';
import 'package:shareacab/screens/groupscreen/group.dart';
import 'package:shareacab/screens/help.dart';
import 'package:shareacab/screens/tripslist.dart';
import 'package:shareacab/screens/filter.dart';
import 'package:shareacab/screens/settings.dart';
import 'package:shareacab/models/alltrips.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin<Dashboard> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
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

  final FirebaseAuth auth = FirebaseAuth.instance;
  var inGroupFetch = false;
  var UID;
  Future getCurrentUser() async {
    var user = await auth.currentUser();
    final userid = user.uid;
    setState(() {
      UID = userid;
    });
  }

  var currentGroup;
  @override
  void initState() {
    inGroupFetch = false;
    super.initState();
    getCurrentUser();
    // Firestore.instance.collection('userdetails').document(UID).get().then((value) {
    //   if (value.data['currentGroup'] != null) {
    //     setState(() {
    //       inGroup = true;
    //       inGroupFetch = true;
    //     });
    //   } else {
    //     setState(() {
    //       inGroup = false;
    //       inGroupFetch = true;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var fetched = false;
    super.build(context);
    final currentuser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          FlatButton.icon(
            textColor: getVisibleColorOnPrimaryColor(context),
            icon: Icon(
              Icons.filter_list,
              size: 30.0,
            ),
            onPressed: () async {
              _startFilter(context);
            },
            label: Text('Filter'),
          ),
          IconButton(
            icon: Icon(Icons.help),
            tooltip: 'Help',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Help()));
            },
          ),
          IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                return Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Settings(_auth);
                }));
              }),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: Firestore.instance.collection('userdetails').document(currentuser.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var temp = snapshot.data['currentGroup'];
            if (temp != null) {
              inGroup = true;
              inGroupFetch = true;
            } else {
              inGroup = false;
              inGroupFetch = true;
            }
            fetched = true;
          }
          if (snapshot.connectionState == ConnectionState.active && fetched == true) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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
              floatingActionButton: inGroupFetch
                  ? !inGroup
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 80),
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
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 80),
                          child: FloatingActionButton.extended(
                            splashColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage()));
                            },
                            icon: Icon(Icons.group),
                            label: Text('Group'),
                          ),
                        )
                  : null,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
