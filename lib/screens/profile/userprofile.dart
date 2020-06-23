import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/shared/loading.dart';
import '../../main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shareacab/services/auth.dart';

class MyProfile extends StatefulWidget {
  final AuthService _auth;
  MyProfile(this._auth);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with AutomaticKeepAliveClientMixin<MyProfile> {
  FirebaseUser currentUser;
  var namefirst = 'P';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
  int numberofratings = 0;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentuser = Provider.of<FirebaseUser>(context);

    return StreamBuilder(
        stream: Firestore.instance.collection('userdetails').document(currentuser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            name = snapshot.data['name'];
            hostel = snapshot.data['hostel'];
            sex = snapshot.data['sex'];
            mobilenum = snapshot.data['mobileNumber'];
            totalrides = snapshot.data['totalRides'];
            actualrating = snapshot.data['actualRating'];
            cancelledrides = snapshot.data['cancelledRides'];
            numberofratings = snapshot.data['numberOfRatings'];
            loading = false;

            namefirst = name.substring(0, 1);
          }
          if (snapshot.connectionState == ConnectionState.active) {
            return loading
                ? Loading()
                : Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'My Profile',
                        style: TextStyle(fontSize: 25),
                      ),
                      elevation: 0,
                      actions: <Widget>[
                        FlatButton.icon(
                            textColor: getVisibleColorOnPrimaryColor(context),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edituserdetails');
                              // _showEditPannel();
                            },
                            icon: Icon(Icons.edit),
                            label: Text('Edit')),
                        FlatButton.icon(
                          textColor: getVisibleColorOnPrimaryColor(context),
                          icon: Icon(FontAwesomeIcons.signOutAlt),
                          onPressed: () async {
                            ProgressDialog pr;
                            pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                            pr.style(
                              message: 'Logging out...',
                              backgroundColor: Theme.of(context).backgroundColor,
                              messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
                            );
                            await pr.show();
                            await Future.delayed(Duration(seconds: 1)); // sudden logout will show ProgressDialog for a very short time making it not very nice to see :p
                            try {
                              await widget._auth.signOut();
                              await pr.hide();
                            } catch (err) {
                              // show e.message
                              await pr.hide();
                              String errStr = err.message ?? err.toString();
                              final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                              scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          },
                          label: Text('Logout'),
                        )
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
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontFamily: 'Poiret',
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                style: TextStyle(
                                  fontSize: 40,
                                ),
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
                                      'GENDER',
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
                                      textAlign: TextAlign.center,
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
                                          textAlign: TextAlign.center,
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
                                      try {
                                        if (Platform.isIOS) {
                                          await Clipboard.setData(ClipboardData(text: '${mobilenum}')).then((result) {
                                            final snackBar = SnackBar(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              content: Text(
                                                'Copied to Clipboard',
                                                style: TextStyle(color: Theme.of(context).accentColor),
                                              ),
                                              duration: Duration(seconds: 1),
                                            );
                                            Scaffold.of(context).hideCurrentSnackBar();
                                            Scaffold.of(context).showSnackBar(snackBar);
                                          });
                                        } else {
                                          await launch('tel://${mobilenum}');
                                        }
                                      } catch (e) {
                                        await Clipboard.setData(ClipboardData(text: '${mobilenum}')).then((result) {
                                          final snackBar = SnackBar(
                                            backgroundColor: Theme.of(context).primaryColor,
                                            content: Text(
                                              'Copied to Clipboard',
                                              style: TextStyle(color: Theme.of(context).accentColor),
                                            ),
                                            duration: Duration(seconds: 1),
                                          );
                                          Scaffold.of(context).hideCurrentSnackBar();
                                          Scaffold.of(context).showSnackBar(snackBar);
                                        });
                                      }
                                    },
                                    title: Center(
                                      child: Text(
                                        'MOBILE NUMBER',
                                        textAlign: TextAlign.center,
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
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                      ),
                                    ),
                                    subtitle: Center(
                                      child: Text(
                                        '${2.5 + actualrating / 2}',
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
          } else {
            return Center(
              child: Text('Loading..'),
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
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
