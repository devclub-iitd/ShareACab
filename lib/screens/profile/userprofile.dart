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

    return loading
        ? Loading()
        : Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/4,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height/4- 74,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).accentColor,
                  child: Text('D', style: TextStyle(fontSize: 40),),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
              child: Text('DEV CLUB', style: TextStyle(fontSize: 30), )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('HOSTEL', style: TextStyle(fontWeight: FontWeight
                        .w700, fontSize: 20),),
                    Text('GIRNAR', style: TextStyle(fontSize: 15),)
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('TRIPS', style: TextStyle(fontWeight: FontWeight
                        .w700, fontSize: 20
                    ),),
                    Text('69', style: TextStyle(fontSize: 15),)
                  ],
                ),
                Column(
                  children: <Widget>[
                      Text('USER RATING', style: TextStyle(fontWeight:
                      FontWeight.w700, fontSize: 20),),
                    Text('6.9', style: TextStyle(fontSize: 15),)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
