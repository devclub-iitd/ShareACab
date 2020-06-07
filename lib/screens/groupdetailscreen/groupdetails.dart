import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
//import './appbar.dart';
import 'package:shareacab/services/trips.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/main.dart';

class GroupDetails extends StatelessWidget {
//  static const routeName = '/groupDetails';

  final String destination;
  final docId;
  final privacy;
  final start;
  final end;
  final numberOfMembers;
  final data;

  GroupDetails(this.destination, this.docId, this.privacy, this.start, this.end,
      this.numberOfMembers, this.data);

  final RequestService _request = RequestService();

  Future getUserDetails() async {
    final userDetails = await Firestore.instance
        .collection('group')
        .document(docId)
        .collection('users')
        .getDocuments();
    return userDetails.documents;
  }

  static bool inGroup = false;

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    Firestore.instance
        .collection('userdetails')
        .document(currentuser.uid)
        .get()
        .then((value) {
      if (value.data['currentGroup'] != null) {
        inGroup = true;
      } else {
        inGroup = false;
      }
    });
    timeDilation = 2.0;
    return Scaffold(
      body: FutureBuilder(
          future: getUserDetails(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold();
            }
            return NestedScrollView(
              controller: ScrollController(keepScrollOffset: true),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    //expandedHeight: 210,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      // background: Image.asset(
                      //   destination == 'New Delhi Railway Station' ? 'assets/images/train.jpg' : 'assets/images/plane.jpg',
                      //   fit: BoxFit.cover,
                      // ),
                      //title: AppBarTitle(destination),
                      // THE ABOVE WAS THROWING AN ERROR, WILL CHECK LATER
                      title: Text(destination),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: docId,
                      child: Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                        child: Container(
                          height: 150,
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
                                        child: destination ==
                                                'New Delhi Railway Station'
                                            ? Icon(
                                                Icons.train,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                size: 30,
                                              )
                                            : Icon(
                                                Icons.airplanemode_active,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                size: 30,
                                              )),
                                  ),
//                                            Flexible(
//                                              fit: FlexFit.tight,
//                                              flex: 4,
//                                              child: Padding(
//                                                padding: const EdgeInsets.only(top: 10.0),
//                                                child: Text(
//                                                  '${destination}',
//                                                  style: TextStyle(
//                                                    fontSize: 17,
//                                                    fontWeight: FontWeight.bold,
//                                                  ),
//                                                  textAlign: TextAlign.center,
//                                                ),
//                                              ),
//                                            ),
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      child: privacy == 'true'
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child: Icon(
                                                Icons.lock,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            )
                                          : !inGroup
                                              ? FlatButton(
                                                  onPressed: () async {
                                                    try {
                                                      DocumentSnapshot temp =
                                                          data;
                                                      await _request.joinGroup(
                                                          temp.documentID);
                                                      await Navigator.of(
                                                              context)
                                                          .pop();
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  },
                                                  child: Text('Join Now'),
                                                )
                                              : FlatButton(
                                                  onPressed: null,
                                                  child:
                                                      Text('Already in group'),
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
                                      'Start : ${DateFormat('dd.MM.yyyy - kk:mm a').format(start)}',
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
                                      'End : ${DateFormat('dd.MM.yyyy - kk:mm a').format(end)}',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('Number of members in group: '
                                          '${numberOfMembers}')
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 60),
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: futureSnapshot.data.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              width: double.infinity,
                              child: Card(
                                elevation: 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(futureSnapshot
                                          .data[index].data['name']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(futureSnapshot
                                          .data[index].data['hostel']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.phone)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: FlatButton(
        textColor: getVisibleColorOnAccentColor(context),
        onPressed: () async {
          try {
            if (privacy == true || inGroup) {
              null;
            } else {
              await _request.joinGroup(docId);
              inGroup = true;
            }
          } catch (e) {
            print(e.toString());
          }
        },
        padding: EdgeInsets.all(20),
        child: privacy == 'true'
            ? Text(
                'Request to Join',
                style: TextStyle(fontSize: 20),
              )
            : inGroup
                ? Text(
                    'Already in a Group',
                    style: TextStyle(fontSize: 20),
                  )
                : Text('Join Now', style: TextStyle(fontSize: 20)),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
