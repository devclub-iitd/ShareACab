import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/groupscreen/group.dart';
import 'package:shareacab/services/trips.dart';
import 'package:intl/intl.dart';
import 'groupdetailscreen/groupdetails.dart';

class TripsList extends StatefulWidget {
  //final List<RequestDetails> trips;
  //TripsList(this.trips);
  @override
  _TripsListState createState() => _TripsListState();
}

class _TripsListState extends State<TripsList> {
  final RequestService _request = RequestService();

  Future getTrips() async {
    var firestore = Firestore.instance;
    var qn = await firestore.collection('group').where('end', isGreaterThan: Timestamp.now()).orderBy('end', descending: true).getDocuments();
    return qn.documents;
    //.where((doc) => doc['maxPoolers'] + 1 > doc['users'].length)
  }

  // MIGHT USE THIS CODE IN FUTURE, SO SAVING IT HERE
  // Future number(String docid) async {
  //   var mydoc = await Firestore.instance.collection('group').document(docid).collection('users').getDocuments();
  //   var mydoccount = mydoc.documents;
  //   return mydoccount.length;
  // }

  bool inGroup = false;

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
    return Container(
      child: FutureBuilder(
        future: getTrips(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading..'),
            );
          } else {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (ctx, index) {
                  final destination = snapshot.data[index].data['destination'];
                  final start = snapshot.data[index].data['start'].toDate();
                  final end = snapshot.data[index].data['end'].toDate();
                  final docId = snapshot.data[index].documentID;
                  final privacy = snapshot.data[index].data['p  rivacy'];
                  final numberOfMembers = snapshot.data[index].data['numberOfMembers'];
                  final data = snapshot.data[index];
                  return Hero(
                    tag: docId,
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetails(destination, docId, privacy, start, end, numberOfMembers, data)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                              left: 20,
                                              top: 20,
                                            ),
                                            child: snapshot.data[index].data['destination'] == 'New Delhi Railway Station' || snapshot.data[index].data['destination'] == 'Hazrat Nizamuddin Railway Station'
                                                ? Icon(
                                                    Icons.train,
                                                    color: Theme.of(context).accentColor,
                                                    size: 30,
                                                  )
                                                : snapshot.data[index].data['destination'] == 'Indira Gandhi International Airport'
                                                    ? Icon(
                                                        Icons.airplanemode_active,
                                                        color: Theme.of(context).accentColor,
                                                        size: 30,
                                                      )
                                                    : Icon(
                                                        Icons.directions_bus,
                                                        color: Theme.of(context).accentColor,
                                                        size: 30,
                                                      )),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            '${snapshot.data[index].data['destination']}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          child: snapshot.data[index].data['privacy'] == 'true'
                                              ? Padding(
                                                  padding: const EdgeInsets.only(right: 15.0),
                                                  child: Icon(
                                                    Icons.lock,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                )
                                              : !inGroup
                                                  ? FlatButton(
                                                      onPressed: () async {
                                                        try {
                                                          await showDialog(
                                                              context: ctx,
                                                              builder: (BuildContext ctx) {
                                                                return AlertDialog(
                                                                  title: Text('Join Group'),
                                                                  content: Text('Are you sure you want to join this group?'),
                                                                  actions: <Widget>[
                                                                    FlatButton(
                                                                      child: Text('Join', style: TextStyle(color: Theme.of(context).accentColor)),
                                                                      onPressed: () async {
                                                                        DocumentSnapshot temp = snapshot.data[index];
                                                                        await _request.joinGroup(temp.documentID);
                                                                        await Navigator.of(context).pop();
                                                                        // final snackBar = SnackBar(
                                                                        //   backgroundColor: Theme.of(context).primaryColor,
                                                                        //   content: Text(
                                                                        //     'Yayyy!! You joined the trip.',
                                                                        //     style: TextStyle(color: Theme.of(context).accentColor),
                                                                        //   ),
                                                                        //   duration: Duration(seconds: 1),
                                                                        // );
                                                                        // Scaffold.of(ctx).hideCurrentSnackBar();
                                                                        // Scaffold.of(ctx).showSnackBar(snackBar);
                                                                        await Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage()));
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child: Text('Cancel', style: TextStyle(color: Theme.of(context).accentColor)),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        } catch (e) {
                                                          print(e.toString());
                                                        }
                                                      },
                                                      child: Text('Join Now'),
                                                    )
                                                  : null,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 5,
                                      top: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Start : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data[index].data['start'].toDate())}',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'End : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data[index].data['end'].toDate())}',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[Text('Number of members in group: ${snapshot.data[index].data['numberOfMembers'].toString()}')],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
