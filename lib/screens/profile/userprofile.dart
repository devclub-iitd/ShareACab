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
  String userId = '';
  String name = '';
  String kerberosEmailID = 'randomemail@iitd.ac.in';
  String password = '';
  String mobileNumber = '6969696969';
  String hostel = '';
  int sex = 1;
  int cancelledRides = 0;
  int actualRating = 0;
  int totalRides = 0;

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
          name = value.data['name'] ?? 'DEV CLUB';
          hostel = value.data['hostel'] ?? 'GIRNAR';
          sex = value.data['sex'];
          mobileNumber = value.data['mobileNumber'];
          totalRides = value.data['totalRides'];
          actualRating = value.data['actualRating'];
          cancelledRides = value.data['cancelledRides'];
          kerberosEmailID = value.data['kerberosEmailID'];

          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });

    return
//      loading
//        ? Loading() :
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
                            '${sex}',
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
                            '${totalRides}',
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
                            '${cancelledRides}',
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
                            mobileNumber,
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
                            '${actualRating}',
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
