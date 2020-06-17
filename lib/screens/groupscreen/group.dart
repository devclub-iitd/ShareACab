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

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with AutomaticKeepAliveClientMixin<GroupPage> {
  final RequestService _request = RequestService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentuser = Provider.of<FirebaseUser>(context);

    Firestore.instance.collection('userdetails').document(currentuser.uid).get().then((value) {
      if (value.exists) {
        setState(() {
          groupUID = value.data['currentGroup'];
        });
      }
    });
    Firestore.instance.collection('group').document(groupUID).get().then((value) {
      if (value.exists) {
        setState(() {
          destination = value.data['destination'];
          start = DateFormat('dd.MM.yyyy - kk:mm a').format(value.data['start'].toDate());
          end = DateFormat('dd.MM.yyyy - kk:mm a').format(value.data['end'].toDate());
          grpOwner = value.data['owner'];
          presentNum = value.data['numberOfMembers'].toString();
          loading = false;
        });
      }
    });
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Group Details'),
              actions: <Widget>[
                FlatButton.icon(
                  textColor: getVisibleColorOnPrimaryColor(context),
                  icon: Icon(FontAwesomeIcons.signOutAlt),
                  onPressed: () async {
                    ProgressDialog pr;
                    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                    pr.style(
                      message: 'Leaving Group...',
                      backgroundColor: Theme.of(context).backgroundColor,
                      messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
                    );
                    await pr.show();
                    await Future.delayed(Duration(seconds: 1)); // sudden logout will show ProgressDialog for a very short time making it not very nice to see :p
                    try {
                      setState(() {
                        buttonEnabled = false;
                      });
                      await _request.exitGroup();
                      Navigator.pop(context);
                      await pr.hide();
                    } catch (err) {
                      // show e.message
                      await pr.hide();
                      String errStr = err.message ?? err.toString();
                      final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                      scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                  },
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
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '(DUMMY) Open Till : May 19, 2020 22:23',
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
                            '(DUMMY) Pool Capacity: 6/6',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: FutureBuilder(
                        future: getMembers(groupUID),
                        builder: (_, snapshots) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshots.data == null ? 0 : snapshots.data.length,
                            itemBuilder: (ctx, index) {
                              return Card(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: ListTile(
                                  title: Text(snapshots.data[index].data['name']),
                                  subtitle: Text('Hostel: ${snapshots.data[index].data['hostel']}\n Mobile Number: ${snapshots.data[index].data['mobilenum']}\n User Rating: ${2.5 + snapshots.data[index].data['actualrating'] / 2}'),
                                  trailing: grpOwner == snapshots.data[index].documentID ? FaIcon(FontAwesomeIcons.crown) : null,
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
  }
}

class Members {
  String name;
  bool isAdmin;
  String hostel;

  Members({@required this.name, @required this.isAdmin, @required this.hostel});
}
