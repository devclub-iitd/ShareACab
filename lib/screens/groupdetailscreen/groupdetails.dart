import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:shareacab/services/trips.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shareacab/main.dart';
import 'package:flutter/scheduler.dart';

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

class _GroupDetailsState extends State<GroupDetails> with AutomaticKeepAliveClientMixin<GroupDetails>{
  final RequestService _request = RequestService();

  Future getUserDetails() async {
    final userDetails = await Firestore.instance.collection('group').document(widget.docId).collection('users').getDocuments();
    return userDetails.documents;
  }

  var _fetchData;

  @override
  bool get wantKeepAlive => true;
  void initState() {
    super.initState();
    _fetchData = getUserDetails();
  }

  Timer _countdownTimer;
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    Firestore.instance.collection('userdetails').document(currentuser.uid).get().then((value) {
      if (value.data['currentGroup'] != null && mounted) {
        setState(() {
          GroupDetails.inGroup = true;
        });
      } else if (mounted) {
        setState(() {
          GroupDetails.inGroup = false;
        });
      }
    });
    timeDilation = 1.0;
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
                      color: Theme.of(context).accentColor,
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
                                              color: Theme.of(context).accentColor,
                                              size: 30,
                                            )
                                          : Icon(
                                              Icons.airplanemode_active,
                                              color: Theme.of(context).accentColor,
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
                                  Text('Start : ${DateFormat('dd.MM.yyyy - kk:mm a').format(widget.start)}', style: TextStyle(fontSize: 15.0, color: getVisibleColorOnAccentColor(context))),
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
                                    'End : ${DateFormat('dd.MM.yyyy - kk:mm a').format(widget.end)}',
                                    style: TextStyle(fontSize: 15, color: getVisibleColorOnAccentColor(context)),
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
                                      'Number of members in group: '
                                      '${widget.numberOfMembers}',
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
                    child: FutureBuilder(
                      future: _fetchData,
                      builder: (ctx, futureSnapshot) {
                        if (futureSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: futureSnapshot.data.length,
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
                                        child: Text(futureSnapshot.data[index].data['name']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(futureSnapshot.data[index].data['hostel']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                            onPressed: () async {
                                              try {
                                                if (Platform.isIOS) {
                                                  await Clipboard.setData(ClipboardData(text: '${futureSnapshot.data[index].data['mobilenum'].toString()}')).then((result) {
                                                    final snackBar = SnackBar(
                                                      backgroundColor: Theme.of(context).primaryColor,
                                                      content: Text(
                                                        'Copied to Clipboard',
                                                        style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                                                      ),
                                                      duration: Duration(seconds: 1),
                                                    );
                                                    Scaffold.of(ctx).hideCurrentSnackBar();
                                                    Scaffold.of(ctx).showSnackBar(snackBar);
                                                  });
                                                } else {
                                                  await launch('tel://${futureSnapshot.data[index].data['mobilenum'].toString()}');
                                                }
                                              } catch (e) {
                                                await Clipboard.setData(ClipboardData(text: '${futureSnapshot.data[index].data['mobilenum'].toString()}')).then((result) {
                                                  final snackBar = SnackBar(
                                                    backgroundColor: Theme.of(context).primaryColor,
                                                    content: Text(
                                                      'Copied to Clipboard',
                                                      style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                                                    ),
                                                    duration: Duration(seconds: 1),
                                                  );
                                                  Scaffold.of(ctx).hideCurrentSnackBar();
                                                  Scaffold.of(ctx).showSnackBar(snackBar);
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              Icons.phone,
                                              color: Theme.of(context).accentColor,
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
          bottomNavigationBar: FlatButton(
            textColor: getVisibleColorOnAccentColor(context),
            onPressed: () async {
              try {
                if (widget.privacy == true || GroupDetails.inGroup) {
                  null;
                } else {
                  await showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text('Join Group'),
                          content: Text('Are you sure you want to join this group?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Join', style: TextStyle(color: Theme.of(context).accentColor)),
                              onPressed: () async {
                                await _request.joinGroup(widget.docId);
                                GroupDetails.inGroup = true;
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
                }
              } catch (e) {
                print(e.toString());
              }
            },
            padding: EdgeInsets.all(20),
            child: widget.privacy == 'true'
                ? Text(
                    'Request to Join',
                    style: TextStyle(fontSize: 20),
                  )
                : GroupDetails.inGroup
                    ? Text(
                        'Already in a Group',
                        style: TextStyle(fontSize: 20),
                      )
                    : Text('Join Now', style: TextStyle(fontSize: 20)),
            color: Theme.of(context).accentColor,
          ),
        ));
  }

}
