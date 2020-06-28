import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/chatscreen/chat_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/groupscreen/editgroup.dart';
import 'package:shareacab/services/trips.dart';
import 'package:shareacab/shared/loading.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shareacab/screens/notifications/services/notifservices.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with AutomaticKeepAliveClientMixin<GroupPage> {
  final RequestService _request = RequestService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final NotifServices _notifServices = NotifServices();

  String groupUID = '';
  String destination = '';
  String startTime = '';
  String endTime = '';
  String startDate = '';
  String endDate = '';
  String grpOwner = '';
  String presentNum = '';
  bool loading = true;

  String start = '';
  String end = '';

  int i = 0, numberOfMessages = 696;

  Future getMembers(String docid) async {
    var qp = await Firestore.instance.collection('group').document(docid).collection('users').getDocuments();
    return qp.documents;
  }

  bool buttonEnabled = true;
  Timestamp endTimeStamp = Timestamp.now();
  bool timestampFlag = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentuser = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('userdetails').document(currentuser.uid).snapshots(),
        builder: (context, usersnapshot) {
          if (usersnapshot.connectionState == ConnectionState.active) {
            if (buttonEnabled == true) {
              groupUID = usersnapshot.data['currentGroup'];
            }
            return StreamBuilder(
                stream: Firestore.instance.collection('group').document(groupUID).snapshots(),
                builder: (context, groupsnapshot) {
                  if (groupsnapshot.connectionState == ConnectionState.active) {
                    if (buttonEnabled == true) {
                      destination = groupsnapshot.data['destination'];
                      start = DateFormat('dd.MM.yyyy - kk:mm a').format(groupsnapshot.data['start'].toDate());
                      end = DateFormat('dd.MM.yyyy - kk:mm a').format(groupsnapshot.data['end'].toDate());
                      grpOwner = groupsnapshot.data['owner'];
                      presentNum = groupsnapshot.data['numberOfMembers'].toString();
                      endTimeStamp = groupsnapshot.data['end'];
                      loading = false;
                      if (endTimeStamp.compareTo(Timestamp.now()) < 0) {
                        timestampFlag = true;
                      }
                    }
                    return loading
                        ? Loading()
                        : Scaffold(
                            appBar: AppBar(
                              title: Text('Group Details'),
                              actions: <Widget>[
                                buttonEnabled
                                    ? timestampFlag
                                        ? FlatButton.icon(
                                            textColor: getVisibleColorOnPrimaryColor(context),
                                            icon: Icon(FontAwesomeIcons.signOutAlt),
                                            onPressed: () async {
                                              try {
                                                await showDialog(
                                                    context: context,
                                                    builder: (BuildContext ctx) {
                                                      return AlertDialog(
                                                        title: Text('End Trip'),
                                                        content: Text('Are you sure you want to end this trip?'),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('End', style: TextStyle(color: Theme.of(context).accentColor)),
                                                            onPressed: () async {
                                                              ProgressDialog pr;
                                                              pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                                                              pr.style(
                                                                message: 'Ending Trip...',
                                                                backgroundColor: Theme.of(context).backgroundColor,
                                                                messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
                                                              );
                                                              await pr.show();
                                                              await Future.delayed(Duration(seconds: 1));
                                                              try {
                                                                buttonEnabled = false;
                                                                await _request.exitGroup();
                                                                Navigator.pop(context);
                                                                await pr.hide();
                                                              } catch (e) {
                                                                await pr.hide();
                                                                print(e.toString());
                                                                String errStr = e.message ?? e.toString();
                                                                final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                                                                scaffoldKey.currentState.showSnackBar(snackBar);
                                                              }
                                                              Navigator.pop(context);
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
                                            label: Text('End Trip'),
                                          )
                                        : FlatButton.icon(
                                            textColor: getVisibleColorOnPrimaryColor(context),
                                            icon: Icon(FontAwesomeIcons.signOutAlt),
                                            onPressed: () async {
                                              try {
                                                await showDialog(
                                                    context: context,
                                                    builder: (BuildContext ctx) {
                                                      return AlertDialog(
                                                        title: Text('Leave Group'),
                                                        content: Text('Are you sure you want to leave this group?'),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('Leave', style: TextStyle(color: Theme.of(context).accentColor)),
                                                            onPressed: () async {
                                                              ProgressDialog pr;
                                                              pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                                                              pr.style(
                                                                message: 'Leaving Group...',
                                                                backgroundColor: Theme.of(context).backgroundColor,
                                                                messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
                                                              );
                                                              await pr.show();
                                                              await Future.delayed(Duration(seconds: 1));
                                                              try {
                                                                buttonEnabled = false;
                                                                await _notifServices.leftGroup(usersnapshot.data['name'], groupUID);
                                                                await _request.exitGroup();
                                                                Navigator.pop(context);
                                                                await pr.hide();
                                                              } catch (e) {
                                                                await pr.hide();
                                                                print(e.toString());
                                                                String errStr = e.message ?? e.toString();
                                                                final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                                                                scaffoldKey.currentState.showSnackBar(snackBar);
                                                              }
                                                              Navigator.pop(context);
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
                                                // fixed this conflict =======
//                                                 buttonEnabled = false;
//                                                 await _notifServices.leftGroup(usersnapshot.data['name'], groupUID);
//                                                 await _request.exitGroup();
//                                                 Navigator.pop(context);
//                                                 await pr.hide();
                                              } catch (e) {
                                                print(e.toString());
                                              }
                                            },
                                            label: Text('Leave Group'),
                                          )
                                    : timestampFlag
                                        ? FlatButton.icon(
                                            textColor: getVisibleColorOnPrimaryColor(context),
                                            icon: Icon(FontAwesomeIcons.signOutAlt),
                                            onPressed: null,
                                            label: Text('End Trip'),
                                          )
                                        : FlatButton.icon(
                                            textColor: getVisibleColorOnPrimaryColor(context),
                                            icon: Icon(FontAwesomeIcons.signOutAlt),
                                            onPressed: null,
                                            label: Text('Leave Group'),
                                          )
                              ],
                            ),
                            body: Container(
                              height: 1000,
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
                                              child: destination == 'New Delhi Railway Station' || destination == 'Hazrat Nizamuddin Railway Station'
                                                  ? Icon(
                                                      Icons.train,
                                                      color: Theme.of(context).accentColor,
                                                      size: 30,
                                                    )
                                                  : destination == 'Indira Gandhi International Airport'
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
                                              destination,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    grpOwner == currentuser.uid
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text('Press here to edit the details: '),
                                                FlatButton.icon(
                                                    onPressed: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditGroup(groupUID: groupUID)));
                                                    },
                                                    icon: Icon(
                                                      FontAwesomeIcons.pen,
                                                      size: 16.0,
                                                      color: Theme.of(context).accentColor,
                                                    ),
                                                    label: Text(
                                                      'Edit',
                                                      style: TextStyle(color: Theme.of(context).accentColor),
                                                    )),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '*Contact group creator to edit timings.',
                                                  style: TextStyle(color: Theme.of(context).accentColor),
                                                ),
                                              ],
                                            ),
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
                                            'Start : $start',
                                            //'Start : ${DateFormat.yMMMd().format(DateTime.parse(startDate))} ${startTime.substring(10, 15)}',
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
                                            'End: $end',
                                            //'End : ${DateFormat.yMMMd().format(DateTime.parse(endDate))} ${endTime.substring(10, 15)}',
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
                                            'Number of members in group: ${presentNum}',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: StreamBuilder(
                                        stream: Firestore.instance.collection('group').document(groupUID).collection('users').snapshots(),
                                        builder: (_, snapshots) {
                                          if (!snapshots.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshots.data == null ? 0 : snapshots.data.documents.length,
                                            itemBuilder: (ctx, index) {
                                              return Card(
                                                color: Theme.of(context).scaffoldBackgroundColor,
                                                child: ListTile(
                                                  title: Text(snapshots.data.documents[index].data['name']),
                                                  subtitle: Text('Hostel: ${snapshots.data.documents[index].data['hostel']}\n Mobile Number: ${snapshots.data.documents[index].data['mobilenum']}\n User Rating: ${2.5 + snapshots.data.documents[index].data['actualrating'] / 2}'),
                                                  trailing: grpOwner == snapshots.data.documents[index].documentID ? FaIcon(FontAwesomeIcons.crown) : null,
                                                  isThreeLine: true,
                                                  onTap: () {},
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(groupUID)));
                              },
                              child: Stack(
                                alignment: Alignment(-10, -10),
                                children: <Widget>[
                                  Tooltip(
                                    message: 'Messages',
                                    verticalOffset: 30,
                                    child: Icon(Icons.chat),
                                  ),

                                  // COMMENTING OUT THE CODE FOR NUMBER OF MESSAGES FOR NOW

                                  // CircleAvatar(
                                  //   backgroundColor: Colors.red,
                                  //   radius: 10.0,
                                  //   child: Text(
                                  //     numberOfMessages.toString(),
                                  //     style: TextStyle(color: Colors.white, fontSize: numberOfMessages.toString().length < 3 ? 14 : 8),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          );
                  } else {
                    return Container(child: Center(child: CircularProgressIndicator()));
                  }
                });
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class Members {
  String name;
  bool isAdmin;
  String hostel;

  Members({@required this.name, @required this.isAdmin, @required this.hostel});
}
