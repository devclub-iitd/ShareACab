import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shareacab/screens/groupscreen/group.dart';
import 'dart:io';

import 'package:shareacab/services/trips.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shareacab/main.dart';
import 'package:flutter/scheduler.dart';

import 'package:shareacab/screens/notifications/services/notifservices.dart';
import './appbar.dart';

class GroupDetails extends StatefulWidget {
  final String destination;
  final docId;
  final privacy;
  final start;
  final end;
  final numberOfMembers;
  final data;

  GroupDetails(this.destination, this.docId, this.privacy, this.start, this.end, this.numberOfMembers, this.data);
  static bool inGroup = false;

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> with AutomaticKeepAliveClientMixin<GroupDetails> {
  final RequestService _request = RequestService();
  final NotifServices _notifServices = NotifServices();
  Future getUserDetails() async {
    final userDetails = FirebaseFirestore.instance.collection('group').doc(widget.docId).collection('users').snapshots();
    return userDetails;
  }

  String privacy;
  String start = '';
  String end = '';
  String destination = '';
  String presentNum = '';
  bool requestedToJoin;

  int present = 0;
  int max = 0;
  bool full = false;

  Timer _countdownTimer;
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    timeDilation = 1.0;
    final currentuser = Provider.of<User>(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('userdetails').doc(currentuser.uid).snapshots(),
        builder: (context, usersnapshot) {
          requestedToJoin = usersnapshot.hasData ? usersnapshot.data()['currentGroupJoinRequests'] != null && usersnapshot.data()['currentGroupJoinRequests'].contains(widget.docId) : false;
          if (usersnapshot.connectionState == ConnectionState.active) {
            var groupUID = usersnapshot.data()['currentGroup'];
            if (groupUID != null) {
              GroupDetails.inGroup = true;
            } else {
              GroupDetails.inGroup = false;
            }
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('group').doc(widget.docId).snapshots(),
                builder: (context, groupsnapshot) {
                  if (groupsnapshot.connectionState == ConnectionState.active) {
                    privacy = groupsnapshot.data()['privacy'];
                    destination = groupsnapshot.data()['destination'];
                    start = DateFormat('dd.MM.yyyy - kk:mm a').format(groupsnapshot.data()['start'].toDate());
                    end = DateFormat('dd.MM.yyyy - kk:mm a').format(groupsnapshot.data()['end'].toDate());
                    presentNum = groupsnapshot.data()['numberOfMembers'].toString();
                    present = int.parse(presentNum);
                    max = groupsnapshot.data()['maxpoolers'];
                    if (present >= max) {
                      full = true;
                    } else {
                      full = false;
                    }
                    return NestedScrollView(
                        controller: ScrollController(keepScrollOffset: true),
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              pinned: true,
                              floating: false,
                              expandedHeight: 120,
                              flexibleSpace: FlexibleSpaceBar(
                                title: AppBarTitle(widget.destination),
                              ),
                            ),
                          ];
                        },
                        body: Scaffold(
                          body: NestedScrollView(
                            controller: ScrollController(keepScrollOffset: true),
                            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                              return <Widget>[];
                            },
                            body: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Hero(
                                    tag: widget.docId,
                                    child: Card(
                                      color: Theme.of(context).colorScheme.secondary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                                      child: Container(
                                        height: 120,
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
                                                      ),
                                                      child: widget.destination == 'New Delhi Railway Station'
                                                          ? Icon(
                                                              Icons.train,
                                                              color: Theme.of(context).colorScheme.secondary,
                                                              size: 30,
                                                            )
                                                          : Icon(
                                                              Icons.airplanemode_active,
                                                              color: Theme.of(context).colorScheme.secondary,
                                                              size: 30,
                                                            )),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 5,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('Start : $start', style: TextStyle(fontSize: 15.0, color: getVisibleColorOnAccentColor(context))),
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
                                                    'End : $end',
                                                    style: TextStyle(fontSize: 15, color: getVisibleColorOnAccentColor(context)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Text(
                                                        'Number of members in group: '
                                                        '$presentNum',
                                                        style: TextStyle(color: getVisibleColorOnAccentColor(context)),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Text(
                                                      'Max Number of members: '
                                                      '$max',
                                                      style: TextStyle(color: getVisibleColorOnAccentColor(context)),
                                                    )
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
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('group').doc(widget.docId).collection('users').snapshots(),
                                      builder: (ctx, futureSnapshot) {
                                        if (futureSnapshot.connectionState == ConnectionState.waiting) {
                                          return Column(
                                            children: <Widget>[
                                              CircularProgressIndicator(),
                                            ],
                                          );
                                        }
                                        return ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: futureSnapshot.data.docs.length,
                                            itemBuilder: (ctx, index) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                                width: double.infinity,
                                                child: Card(
                                                  elevation: 4,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(futureSnapshot.data.docs[index].data()['name']),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(futureSnapshot.data.docs[index].data()['hostel']),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: IconButton(
                                                            onPressed: () async {
                                                              try {
                                                                if (Platform.isIOS) {
                                                                  await Clipboard.setData(ClipboardData(text: '${futureSnapshot.data.docs[index].data()['mobilenum'].toString()}')).then((result) {
                                                                    final snackBar = SnackBar(
                                                                      backgroundColor: Theme.of(context).primaryColor,
                                                                      content: Text(
                                                                        'Copied to Clipboard',
                                                                        style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                                                                      ),
                                                                      duration: Duration(seconds: 1),
                                                                    );
                                                                    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                                                                    ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                                                                  });
                                                                } else {
                                                                  await launch('tel://${futureSnapshot.data.docs[index].data()['mobilenum'].toString()}');
                                                                }
                                                              } catch (e) {
                                                                await Clipboard.setData(ClipboardData(text: '${futureSnapshot.data.docs[index].data()['mobilenum'].toString()}')).then((result) {
                                                                  final snackBar = SnackBar(
                                                                    backgroundColor: Theme.of(context).primaryColor,
                                                                    content: Text(
                                                                      'Copied to Clipboard',
                                                                      style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                                                                    ),
                                                                    duration: Duration(seconds: 1),
                                                                  );
                                                                  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                                                                  ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                                                                });
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.phone,
                                                              color: Theme.of(context).colorScheme.secondary,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          bottomNavigationBar: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                              padding: EdgeInsets.all(20),
                            ),

                            onPressed: () async {
                              try {
                                if (GroupDetails.inGroup) {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage()));
                                } else if (full) {
                                  null;
                                } else if (privacy == 'true' && !full) {
                                  requestedToJoin
                                      ? null
                                      // print('already req')
                                      : await showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              title: Text('Request To Join Group'),
                                              content: Text('Are you sure you want to request to join this group?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Request', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                                  onPressed: () async {
                                                    ProgressDialog pr;
                                                    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                                                    pr.style(
                                                      message: 'Requesting...',
                                                      backgroundColor: Theme.of(context).backgroundColor,
                                                      messageTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                                    );
                                                    await pr.show();
                                                    await Future.delayed(Duration(seconds: 1));
                                                    try {
                                                      await _notifServices.createRequest(widget.docId);
                                                      Navigator.of(context).pop();
                                                      await pr.hide();
                                                    } catch (e) {
                                                      await pr.hide();
                                                      print(e.toString());
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                } else if (privacy == 'false' && !full) {
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return AlertDialog(
                                          title: Text('Join Group'),
                                          content: Text('Are you sure you want to join this group?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Join', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                              onPressed: () async {
                                                ProgressDialog pr;
                                                pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                                                pr.style(
                                                  message: 'Joining Group...',
                                                  backgroundColor: Theme.of(context).backgroundColor,
                                                  messageTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                                );
                                                await pr.show();
                                                await Future.delayed(Duration(seconds: 1));
                                                try {
                                                  await _request.joinGroup(widget.docId);
                                                  GroupDetails.inGroup = true;
                                                  await _notifServices.groupJoin(usersnapshot.data()['name'], widget.docId);
                                                  await pr.hide();
                                                } catch (e) {
                                                  await pr.hide();
                                                  print(e.toString());
                                                }
                                                Navigator.of(context).pop();
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
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                }
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: privacy == 'true'
                                ? GroupDetails.inGroup
                                    ? Text(
                                        'My Group Page', // You are in a group and viewing a private group
                                        style: TextStyle(fontSize: 20, color: getVisibleColorOnAccentColor(context)),
                                      )
                                    : full
                                        ? Text('Group is full', style: TextStyle(fontSize: 20))
                                        : requestedToJoin
                                            ? Text(
                                                'Requested', // You are not in any group and requested to join
                                                style: TextStyle(fontSize: 20, color: getVisibleColorOnAccentColor(context)),
                                              )
                                            : Text(
                                                'Request to Join', // fresh visit to private group (and user is not in any group)
                                                style: TextStyle(fontSize: 20, color: getVisibleColorOnAccentColor(context)),
                                              )
                                : GroupDetails.inGroup
                                    ? Text(
                                        'My Group Page', // visiting a group page
                                        style: TextStyle(fontSize: 20, color: getVisibleColorOnAccentColor(context)),
                                      )
                                    : full
                                        ? Text('Group is full', style: TextStyle(fontSize: 20))
                                        : Text('Join Now', style: TextStyle(fontSize: 20)), // Visiting a public group page and not in any group
                          ),
                        ));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
