import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/groupdetailscreen/ended_group_details.dart';
import 'package:shareacab/screens/rootscreen.dart';

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests>
    with AutomaticKeepAliveClientMixin<MyRequests> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future getOldTrips() async {
    var user = auth.currentUser;
    final userid = user.uid;
    var qn = await FirebaseFirestore.instance
        .collection('group')
        .where('users', arrayContains: userid)
        .orderBy('end', descending: true)
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentuser = Provider.of<User>(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RootScreen()));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ended rides'),
        ),
        body: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userdetails')
                    .doc(currentuser.uid)
                    .snapshots(),
                builder: (context, usersnapshot) {
                  return FutureBuilder(
                    future: getOldTrips(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data == null
                                ? 0
                                : snapshot.data.length,
                            itemBuilder: (ctx, index) {
                              final destination =
                                  snapshot.data()[index].data()['destination'];
                              final start = snapshot
                                  .data()[index]
                                  .data()['start']
                                  .toDate();
                              final end =
                                  snapshot.data()[index].data()['end'].toDate();
                              final docId = snapshot.data()[index].id;
                              final privacy =
                                  snapshot.data()[index].data()['privacy'];
                              final numberOfMembers = snapshot
                                  .data()[index]
                                  .data()['numberOfMembers'];
                              final data = snapshot.data()[index];
                              return Hero(
                                tag: Text(docId),
                                child: (docId !=
                                        usersnapshot.data()['currentGroup'])
                                    ? Card(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        elevation: 0.0,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EndedGroupDetails(
                                                            destination,
                                                            docId,
                                                            privacy,
                                                            start,
                                                            end,
                                                            numberOfMembers,
                                                            data)));
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0))),
                                            elevation: 5,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 5),
                                            child: Container(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Flexible(
                                                          fit: FlexFit.tight,
                                                          flex: 1,
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 20,
                                                                top: 20,
                                                              ),
                                                              child: snapshot.data()[index].data()[
                                                                              'destination'] ==
                                                                          'New Delhi Railway Station' ||
                                                                      snapshot.data()[index].data()[
                                                                              'destination'] ==
                                                                          'Hazrat Nizamuddin Railway Station'
                                                                  ? Icon(
                                                                      Icons
                                                                          .train,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                      size: 30,
                                                                    )
                                                                  : snapshot.data()[index].data()[
                                                                              'destination'] ==
                                                                          'Indira Gandhi International Airport'
                                                                      ? Icon(
                                                                          Icons
                                                                              .airplanemode_active,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary,
                                                                          size:
                                                                              30,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .directions_bus,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary,
                                                                          size:
                                                                              30,
                                                                        )),
                                                        ),
                                                        Flexible(
                                                          fit: FlexFit.tight,
                                                          flex: 4,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            child: Text(
                                                              '${snapshot.data()[index].data()['destination']}',
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Started : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data()[index].data()['start'].toDate())}',
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Ended : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data()[index].data()['end'].toDate())}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Column(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Number of poolers: ${snapshot.data()[index].data()['numberOfMembers'].toString()}')
                                                            ],
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
                                      )
                                    : Card(),
                              );
                            });
                      }
                    },
                  );
                })),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
