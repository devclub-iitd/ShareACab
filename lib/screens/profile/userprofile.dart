import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/rootscreen.dart';
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
  User currentUser;
  var namefirst = 'P';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    setState(() {
      // call setState to rebuild the view
      currentUser = FirebaseAuth.instance.currentUser;
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
  double rating = 0;
  int finalrating = 0;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentuser = Provider.of<User>(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Profile',
            style: TextStyle(fontSize: 25),
          ),
          elevation: 0,
          actions: <Widget>[
            TextButton.icon(
                style: TextButton.styleFrom(textStyle: TextStyle(color: getVisibleColorOnPrimaryColor(context))),
                onPressed: () {
                  Navigator.pushNamed(context, '/edituserdetails');
                },
                icon: Icon(Icons.edit),
                label: Text('Edit')),
            TextButton.icon(
              style: TextButton.styleFrom(textStyle: TextStyle(color: getVisibleColorOnPrimaryColor(context))),
              icon: Icon(FontAwesomeIcons.signOutAlt),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        title: Text('Log out'),
                        content: Text('Are you sure you want to log out?'),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Log out', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                            onPressed: () async {
                              ProgressDialog pr;
                              pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                              pr.style(
                                message: 'Logging out...',
                                backgroundColor: Theme.of(context).backgroundColor,
                                messageTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              );
                              await pr.show();
                              await Future.delayed(Duration(seconds: 1)); // sudden logout will show ProgressDialog for a very short time making it not very nice to see :p
                              try {
                                await widget._auth.signOut();
                                await pr.hide();
                              } catch (err) {
                                await pr.hide();
                                String errStr = err.message ?? err.toString();
                                final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                              Navigator.of(context).pop();
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
              },
              label: Text('Logout'),
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('userdetails').doc(currentuser.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                name = snapshot.data()['name'];
                hostel = snapshot.data()['hostel'];
                sex = snapshot.data()['sex'];
                mobilenum = snapshot.data()['mobileNumber'];
                totalrides = snapshot.data()['totalRides'];
                actualrating = snapshot.data()['actualRating'];
                cancelledrides = snapshot.data()['cancelledRides'];
                numberofratings = snapshot.data()['numberOfRatings'];
                loading = false;

                namefirst = name.substring(0, 1);

                rating = 5 - (0.2 * cancelledrides) + (0.35 * totalrides);
                if (rating < 0) {
                  rating = 0;
                }
                if (rating > 5) {
                  rating = 5;
                }
                finalrating = rating.round();
              }
              if (snapshot.connectionState == ConnectionState.active) {
                return loading
                    ? Loading()
                    : Scaffold(
                        body: ListView(
                          children: <Widget>[
                            Stack(
                              clipBehavior: Clip.none,
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
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    child: Text(
                                      namefirst.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontFamily: 'Poiret',
                                        fontWeight: FontWeight.bold,
                                        color: getVisibleColorOnAccentColor(context),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 50, bottom: 20, right: 20, left: 20),
                                child: Center(
                                  child: FittedBox(
                                    child: SelectableText(
                                      name,
                                      style: TextStyle(
                                        fontSize: 40,
                                      ),
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
                                          '$totalrides',
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
                                              '$cancelledrides',
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
                                              await Clipboard.setData(ClipboardData(text: '$mobilenum')).then((result) {
                                                final snackBar = SnackBar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  content: Text(
                                                    'Copied to Clipboard',
                                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                                  ),
                                                  duration: Duration(seconds: 1),
                                                );
                                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else {
                                              await launch('tel://$mobilenum');
                                            }
                                          } catch (e) {
                                            await Clipboard.setData(ClipboardData(text: '$mobilenum')).then((result) {
                                              final snackBar = SnackBar(
                                                backgroundColor: Theme.of(context).primaryColor,
                                                content: Text(
                                                  'Copied to Clipboard',
                                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                                ),
                                                duration: Duration(seconds: 1),
                                              );
                                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                            '$finalrating',
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
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
