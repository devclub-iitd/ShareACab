import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/shared/loading.dart';

import '../../main.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String userId = 'DEV CLUB';
  String name = '';
  String kerberosEmailID = 'randomemail@iitd.ac.in';
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

    Firestore.instance
        .collection('userdetails')
        .document(currentuser.uid)
        .get()
        .then((value) {
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

    return
      loading
        ? Loading() :
         Scaffold(
            appBar: AppBar(
              title: Text('My Profile', style: TextStyle(fontSize: 30),),
              elevation: 0,
              centerTitle: true,
              actions: <Widget>[
                FlatButton.icon(
                  textColor: getVisibleColorOnPrimaryColor(context),
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                  label: Text('Edit'),
                )
              ],
            ),
            body: Column(
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
                          'D',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 100,bottom: 20),
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 30),
                        )
                    ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'HOSTEL',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          Text(
                            hostel,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Gender',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          Text(
                            sex,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'TOTAL RIDES',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            '${totalrides}',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'CANCELLED TRIPS',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            '${cancelledrides}',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'MOBILE NUMBER',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            mobilenum,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'USER RATING',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            '${actualrating}',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'EMAIL ID',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            kerberosEmailID,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
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
