import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'groupdetailscreen/groupdetails.dart';
import 'groupscreen/group.dart';

class TripsList extends StatefulWidget {
  final bool inGroupFetch;
  final bool inGroup;
  final _dest;
  final _notPrivate;
  final _selectedDestination;
  final Function startCreatingTrip;
  TripsList(this._dest, this._selectedDestination, this._notPrivate,
      {this.inGroupFetch, this.inGroup, this.startCreatingTrip});
  @override
  _TripsListState createState() => _TripsListState();
}

class _TripsListState extends State<TripsList>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  AnimationController _hideFabController;
  bool flag;
  var requestsArray = [];

  @override
  void initState() {
    super.initState();
    _hideFabController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<User>(context);
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('userdetails')
                .doc(currentuser.uid)
                .snapshots(),
            builder: (_, usersnapshot) {
              if (usersnapshot.connectionState == ConnectionState.waiting) {
                Center(child: CircularProgressIndicator());
              }
              if (usersnapshot.connectionState == ConnectionState.active) {
                requestsArray = usersnapshot.data()['currentGroupJoinRequests'];
                requestsArray ??= [];
              }

              _controller.addListener(() {
                switch (_controller.position.userScrollDirection) {
                  // Scrolling up - forward the animation (value goes to 1)
                  case ScrollDirection.forward:
                    _hideFabController.forward();
                    break;
                  // Scrolling down - reverse the animation (value goes to 0)
                  case ScrollDirection.reverse:
                    _hideFabController.reverse();
                    break;
                  // Idle - keep FAB visibility unchanged
                  case ScrollDirection.idle:
                    break;
                }
              });
              return Container(
                child: StreamBuilder(
                  stream: widget._dest == true && widget._notPrivate == true
                      ? FirebaseFirestore.instance
                          .collection('group')
                          .where('end', isGreaterThan: Timestamp.now())
                          .where('destination',
                              isEqualTo: widget._selectedDestination)
                          .where('privacy', isEqualTo: false.toString())
                          .orderBy('end', descending: true)
                          .snapshots()
                      : widget._dest == true
                          ? FirebaseFirestore.instance
                              .collection('group')
                              .where('end', isGreaterThan: Timestamp.now())
                              .where('destination',
                                  isEqualTo: widget._selectedDestination)
                              .orderBy('end', descending: true)
                              .snapshots()
                          : widget._notPrivate == true
                              ? FirebaseFirestore.instance
                                  .collection('group')
                                  .where('end', isGreaterThan: Timestamp.now())
                                  .where('privacy', isEqualTo: false.toString())
                                  .orderBy('end', descending: true)
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('group')
                                  .where('end', isGreaterThan: Timestamp.now())
                                  .orderBy('end', descending: true)
                                  .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                        controller: _controller,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data == null
                            ? 0
                            : snapshot.data.docs.length,
                        itemBuilder: (ctx, index) {
                          final destination =
                              snapshot.data.docs[index].data()['destination'];
                          final start = snapshot.data.docs[index]
                              .data()['start']
                              .toDate();
                          final end =
                              snapshot.data.docs[index].data()['end'].toDate();
                          final docId = snapshot.data.docs[index].id;
                          final privacy =
                              snapshot.data.docs[index].data()['privacy'];
                          final numberOfMembers = snapshot.data.docs[index]
                              .data()['numberOfMembers'];
                          final data = snapshot.data.docs[index];
                          if (docId == usersnapshot.data()['currentGroup']) {
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GroupDetails(
                                              destination,
                                              docId,
                                              privacy,
                                              start,
                                              end,
                                              numberOfMembers,
                                              data)));
                                },
                                child: Card(
                                  shape: flag
                                      ? RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2.0),
                                        )
                                      : requestsArray.contains(docId)
                                          ? RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0)),
                                              side: BorderSide(
                                                  color: Colors.pink[300],
                                                  width: 2.0),
                                            )
                                          : RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0)),
                                            ),
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 5),
                                  child: Container(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 1,
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                      left: 20,
                                                      top: 20,
                                                    ),
                                                    child: snapshot.data.docs[index]
                                                                        .data()[
                                                                    'destination'] ==
                                                                'New Delhi Railway Station' ||
                                                            snapshot.data
                                                                        .docs[index]
                                                                        .data()[
                                                                    'destination'] ==
                                                                'Hazrat Nizamuddin Railway Station'
                                                        ? Icon(
                                                            Icons.train,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            size: 30,
                                                          )
                                                        : snapshot.data.docs[index]
                                                                        .data()[
                                                                    'destination'] ==
                                                                'Indira Gandhi International Airport'
                                                            ? Icon(
                                                                Icons
                                                                    .airplanemode_active,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                size: 30,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .directions_bus,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                size: 30,
                                                              )),
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 4,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                    '${snapshot.data.docs[index].data()['destination']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              snapshot.data.docs[index]
                                                          .data()['privacy'] ==
                                                      'true'
                                                  ? Flexible(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 25.0),
                                                        child: Icon(
                                                          Icons.lock,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                      ),
                                                    )
                                                  : Flexible(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 25.0),
                                                        child: Icon(
                                                          Icons.lock_open,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
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
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Start : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data.docs[index].data()['start'].toDate())}',
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
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'End : ${DateFormat('dd.MM.yyyy - kk:mm a').format(snapshot.data.docs[index].data()['end'].toDate())}',
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Text(
                                                          'Number of members in group: ${snapshot.data.docs[index].data()['numberOfMembers'].toString()}/${snapshot.data.docs[index].data()['maxpoolers'].toString()}')
                                                    ],
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
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FadeTransition(
          opacity: _hideFabController,
          child: ScaleTransition(
            scale: _hideFabController,
            child: widget.inGroupFetch
                ? !widget.inGroup
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 80),
                        child: FloatingActionButton(
                          onPressed: () => widget.startCreatingTrip(context),
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupPage()));
                          },
                          icon: Icon(Icons.group),
                          label: Text('Group'),
                        ),
                      )
                : null,
          ),
        ));
  }
}
