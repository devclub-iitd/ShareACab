import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/groupscreen/group.dart';
import 'package:shareacab/services/trips.dart';
import 'package:shareacab/screens/groupdetailscreen/groupdetails.dart';

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
    var qn = await firestore.collection('group').orderBy('created', descending: true).getDocuments();
    return qn.documents;
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
          // will fix this later, it should have ConnectionState.waiting, but it was having issues.
          if (snapshot.connectionState == null) {
            return Center(
              child: Text('Loading..'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      final destination = snapshot.data[index].data['destination'];
                      //final startDate = DateTime.parse(snapshot.data[index].data['startDate']);
                      //final startTime = snapshot.data[index].data['startTime'];
                      //final endDate = DateTime.parse(snapshot.data[index].data['endDate']);
                      //final endTime = snapshot.data[index].data['endTime'];
                      final start = snapshot.data[index].data['start'].toDate();
                      final end = snapshot.data[index].data['end'].toDate();
                      final docId = snapshot.data[index].documentID;
                      final privacy = snapshot.data[index].data['privacy'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetails(destination, start, end, docId, privacy)));
                    },
                    child: Card(
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
                                    'Start : ${snapshot.data[index].data['start'].toDate()}',
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
                                    'End : ${snapshot.data[index].data['end'].toDate()}',
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
                                  children: <Widget>[Text('Number of members in group: ${snapshot.data[index].data['numberOfMembers'].toString()}')],
                                ),
                              ],
                            ),
                          ],
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
