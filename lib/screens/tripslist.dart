import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/groupscreen/group.dart';
import 'package:shareacab/services/trips.dart';
import 'package:intl/intl.dart';
import 'groupdetailscreen/groupdetails.dart';
import 'package:shareacab/screens/notifications/services/notifservices.dart';

class TripsList extends StatefulWidget {
  @override
  _TripsListState createState() => _TripsListState();
}

class _TripsListState extends State<TripsList> {
  final RequestService _request = RequestService();
  final NotifServices _notifServices = NotifServices();

  var inGroup = false;

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('userdetails').document(currentuser.uid).snapshots(),
        builder: (context, usersnapshot) {
          if (usersnapshot.connectionState == ConnectionState.waiting) {
            //print('wait');
          }
          if (usersnapshot.connectionState == ConnectionState.active) {
            var temp = usersnapshot.data['currentGroup'];
            if (temp != null) {
              inGroup = true;
            } else {
              inGroup = false;
            }
          }
          if (usersnapshot.connectionState == ConnectionState.active) {
            return Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('group').where('end', isGreaterThan: Timestamp.now()).orderBy('end', descending: true).snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //print('dashwaiting');
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
                                              flex: !inGroup ? 4 : 300,
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
                                            Flexible(
                                              flex: inGroup ? 9 : 2,
                                              child: Container(
                                                child: snapshot.data.documents[index].data['privacy'] == 'true'
                                                    ? Padding(
                                                        padding: const EdgeInsets.only(right: 25),
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
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                        actions: <Widget>[
                                                                          FlatButton(
                                                                            child: Text('Join', style: TextStyle(color: Theme.of(context).accentColor)),
                                                                            onPressed: () async {
                                                                              ProgressDialog pr;
                                                                              pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                                                                              pr.style(
                                                                                message: 'Joining Group...',
                                                                                backgroundColor: Theme.of(context).backgroundColor,
                                                                                messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
                                                                              );
                                                                              await pr.show();
                                                                              await Future.delayed(Duration(seconds: 1));
                                                                              try {
                                                                                DocumentSnapshot temp = snapshot.data.documents[index];
                                                                                await _request.joinGroup(temp.documentID);
                                                                                await Navigator.of(context).pop();
                                                                                await pr.hide();
                                                                                await _notifServices.groupJoin(usersnapshot.data['name'], docId);
                                                                              } catch (e) {
                                                                                await pr.hide();
                                                                                print(e.toString());
                                                                              }

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
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
