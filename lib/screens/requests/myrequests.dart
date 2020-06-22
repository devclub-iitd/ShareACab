import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/groupdetailscreen/ended_group_details.dart';

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  Future getOldTrips(String uid) async {
    var qn = await Firestore.instance.collection('group').where('users', arrayContains: uid).orderBy('end', descending: true).getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ended rides'),
      ),
      body: Container(
          child: FutureBuilder(
        future: getOldTrips(currentuser.uid),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EndedGroupDetails(destination, docId, privacy, start, end, numberOfMembers, data)));
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
                                          'Started : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data[index].data['start'].toDate())}',
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
                                          'Ended : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data[index].data['end'].toDate())}',
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
                                          children: <Widget>[Text('Number of poolers: ${snapshot.data[index].data['numberOfMembers'].toString()}')],
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
      )),
    );
  }
}
