import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/shared/loading.dart';
import '../../main.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  FirebaseUser currentUser;
  var namefirst = 'P';
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        currentUser = user;
      });
    });
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return 'no current user';
    }
  }

  String userId = 'DEV CLUB';
  String name = '';
  String kerberosEmailID = 'random@gmail.com';
  String password = '';
  String mobilenum = '6969696969';
  String hostel = '';
  String sex = 'Male';
  int cancelledrides = 0;
  int actualrating = 0;
  int totalrides = 0;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    //print(currentuser.uid);

    Firestore.instance.collection('userdetails').document(currentuser.uid).get().then((value) {
      if (value.exists) {
        setState(() {
          name = value.data['name'];
          hostel = value.data['hostel'];
          sex = value.data['sex'];
          mobilenum = value.data['mobileNumber'];
          totalrides = value.data['totalRides'];
          actualrating = value.data['actualRating'];
          cancelledrides = value.data['cancelledRides'];
          loading = false;
          namefirst = name.substring(0, 1);
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
    
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'My Profile',
                style: TextStyle(fontSize: 30),
              ),
              elevation: 0,
              centerTitle: true,
              actions: <Widget>[
                FlatButton.icon(
                    textColor: getVisibleColorOnPrimaryColor(context),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edituserdetails');
                      // _showEditPannel();
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit'))
              ],
            ),
            body: ListView(
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 6 - 74,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).accentColor,
                        child: Text(
                          namefirst,
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 50, bottom: 20),
                    child: Center(
                      child: SelectableText(
                        name,
                        style: TextStyle(fontSize: 30),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          onTap: () {},
                          title: Center(
                            child: Text(
                              'HOSTEL',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              hostel,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          onTap: () {},
                          title: Center(
                            child: Text(
                              'Gender',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              sex,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          onTap: () {},
                          title: Center(
                            child: Text(
                              'TOTAL RIDES',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              '${totalrides}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListTile(
                              onTap: () {},
                              title: Center(
                                child: Text(
                                  'CANCELLED TRIPS',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                ),
                              ),
                              subtitle: Center(
                                child: Text(
                                  '${cancelledrides}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                            onTap: () async {
                              await launch('tel://${mobilenum}');
                            },
                            title: Center(
                              child: Text(
                                'MOBILE NUMBER',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                            ),
                            subtitle: Center(
                              child: Text(
                                mobilenum,
                                style: TextStyle(fontSize: 15),
                              ),
                            )),
                      ),
                      Expanded(
                        child: ListTile(
                            onTap: () {},
                            title: Center(
                              child: Text(
                                'USER RATING',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                            ),
                            subtitle: Center(
                              child: Text(
                                '${actualrating}',
                                style: TextStyle(fontSize: 15),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                            onTap: () {},
                            title: Center(
                              child: Text(
                                'EMAIL ID',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                            ),
                            subtitle: Center(
                              child: Text(
                                _email(),
                                style: TextStyle(fontSize: 15),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

//class User {
//  @required
//  final String name;
//  @required
//  final String hostel;
//  @required
//  @required
//  final int sex;
//  @required
//  final String kerberosEmailId;
//  @required
//  int totalRides;
//  @required
//  int cancelledRides;
//  @required
//  String mobileMumber;
//  User({this.name, this.hostel, this.sex, this.kerberosEmailId ,this.totalRides, this
//      .cancelledRides, this.mobileMumber});
//}
