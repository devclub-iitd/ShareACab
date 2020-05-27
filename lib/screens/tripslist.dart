import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/groupscreen/group.dart';
import 'package:shareacab/services/trips.dart';

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
    var qn = await firestore.collection('group').getDocuments();
    return qn.documents;
  }

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
          // will fix this later, it should have ConnectionState.waiting, but it was having issues.
          if (snapshot.connectionState == null) {
            return Center(
              child: Text('Loading..'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    child: Container(
                      height: 150,
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
                                    child: snapshot.data[index].data['destination'] == 'New Delhi Railway Station'
                                        ? Icon(
                                            Icons.train,
                                            color: Theme.of(context).accentColor,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons.airplanemode_active,
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
                                                  DocumentSnapshot temp = snapshot.data[index];
                                                  await _request.joinGroup(temp.documentID);
                                                  //print(temp.documentID);
                                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage()));
                                                } catch (e) {
                                                  print(e.toString());
                                                }
                                              },
                                              child: Text('Join Now'),
                                            )
                                          : FlatButton(
                                              onPressed: null,
                                              child: Text('Already in group'),
                                            ),
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
                                  'Start : ${DateFormat.yMMMd().format(DateTime.parse(snapshot.data[index].data['startDate']))} ${snapshot.data[index].data['startTime'].substring(10, 15)}',
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
                                  'End : ${DateFormat.yMMMd().format(DateTime.parse(snapshot.data[index].data['endDate']))} ${snapshot.data[index].data['endTime'].substring(10, 15)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[Text('Members')],
                              ),
                              Column(
                                children: <Widget>[Text('Going To')],
                              )
                            ],
                          ),
                        ],
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
