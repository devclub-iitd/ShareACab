import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/shared/loading.dart';

import '../main.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String name = '';
  String hostel = '';
  String mobilenum = '';
  String sex = '';
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
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });

    // void _showEditPannel() {
    //   showModalBottomSheet(
    //       isScrollControlled: true,
    //       context: context,
    //       builder: (context) {
    //         return GestureDetector(
    //           onTap: () {
    //             FocusScope.of(context).unfocus();
    //           },
    //           child: Container(
    //             padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
    //             child: EditForm(),
    //           ),
    //         );
    //       });
    // }
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('My Profile'),
              actions: <Widget>[
                FlatButton.icon(
                    textColor: getVisibleColorOnAccentColor(context),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edituserdetails');
                      // _showEditPannel();
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit'))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Name:  ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$name',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 30.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Mobile: ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$mobilenum',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 22.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Hostel:  ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$hostel',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Sex:  ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$sex',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Total Rides:  ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$totalrides',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Cancelled Rides:  ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$cancelledrides',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Actual Ratings:  ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$actualrating',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
