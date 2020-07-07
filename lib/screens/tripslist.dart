import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'groupdetailscreen/groupdetails.dart';

class TripsList extends StatefulWidget {
  @override
  _TripsListState createState() => _TripsListState();
}

class _TripsListState extends State<TripsList> {
  bool flag;
  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('userdetails').document(currentuser.uid).snapshots(),
        builder: (_, usersnapshot) {
          return Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('group').where('end', isGreaterThan: Timestamp.now()).orderBy('end', descending: true).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  CircularProgressIndicator();
                }

                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data == null ? 0 : snapshot.data.documents.length,
                    itemBuilder: (ctx, index) {
                      final destination = snapshot.data.documents[index].data['destination'];
                      final start = snapshot.data.documents[index].data['start'].toDate();
                      final end = snapshot.data.documents[index].data['end'].toDate();
                      final docId = snapshot.data.documents[index].documentID;
                      final privacy = snapshot.data.documents[index].data['privacy'];
                      final numberOfMembers = snapshot.data.documents[index].data['numberOfMembers'];
                      final data = snapshot.data.documents[index];
                      if (docId == usersnapshot.data['currentGroup']) {
                        flag = true;
                      } else {
                        flag = false;
                      }
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
                              shape: flag
                                  ? RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)), side: BorderSide(color: Theme.of(context).accentColor, width: 2.0))
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                    ),
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
                                                child: snapshot.data.documents[index].data['destination'] == 'New Delhi Railway Station' || snapshot.data.documents[index].data['destination'] == 'Hazrat Nizamuddin Railway Station'
                                                    ? Icon(
                                                        Icons.train,
                                                        color: Theme.of(context).accentColor,
                                                        size: 30,
                                                      )
                                                    : snapshot.data.documents[index].data['destination'] == 'Indira Gandhi International Airport'
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
                                                '${snapshot.data.documents[index].data['destination']}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          snapshot.data.documents[index].data['privacy'] == 'true'
                                              ? Flexible(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25.0),
                                                    child: Icon(
                                                      Icons.lock,
                                                      color: Theme.of(context).accentColor,
                                                    ),
                                                  ),
                                                )
                                              : Flexible(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 25.0),
                                                    child: Icon(
                                                      Icons.lock_open,
                                                      color: Theme.of(context).accentColor,
                                                    ),
                                                  ),
                                                ),
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
                                              'Start : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data.documents[index].data['start'].toDate())}',
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
                                              'End : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data.documents[index].data['end'].toDate())}',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[Text('Number of members in group: ${snapshot.data.documents[index].data['numberOfMembers'].toString()}')],
                                              ),
                                            ],
                                          ),
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
              },
            ),
          );
        });
  }
}
