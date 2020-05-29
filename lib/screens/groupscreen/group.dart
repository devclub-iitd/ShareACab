import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/groupscreen/groupchat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/trips.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/shared/loading.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with AutomaticKeepAliveClientMixin<GroupPage> {
  final RequestService _request = RequestService();

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
          startTime = value.data['startTime'];
          endTime = value.data['endTime'];
          startDate = value.data['startDate'];
          endDate = value.data['endDate'];
          start = '${DateFormat.yMMMd().format(DateTime.parse(startDate))} ${startTime.substring(10, 15)}';
          end = '${DateFormat.yMMMd().format(DateTime.parse(endDate))} ${endTime.substring(10, 15)}';
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
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
                    try {
                      await _request.exitGroup();
                      Navigator.pop(context);
                    } catch (e) {
                      print(e.toString());
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
                              child: destination == 'New Delhi Railway Station'
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
                                  subtitle: Text('Hostel: ${snapshots.data[index].data['hostel']}\n Mobile Number: ${snapshots.data[index].data['mobilenum']}'),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatPage()));
              },
              child: Stack(
                alignment: Alignment(-10, -10),
                children: <Widget>[
                  Icon(Icons.chat),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10.0,
                    child: Text(
                      numberOfMessages.toString(),
                      style: TextStyle(color: Colors.white, fontSize: numberOfMessages.toString().length < 3 ? 14 : 8),
                    ),
                  )
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
