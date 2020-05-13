import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/shared/loading.dart';

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

    Firestore.instance
        .collection('userdetails')
        .document(currentuser.uid)
        .get()
        .then((value) {
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
    });

    // users.forEach((user) {
    //   if (user.uid == currentuser.uid) {
    //     print(user.name);
    //   }
    // });

    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text('Name: $name'),
                    SizedBox(height: 20.0),
                    Text('Mobile Number: $mobilenum'),
                    SizedBox(height: 20.0),
                    Text('Hostel: $hostel'),
                    SizedBox(height: 20.0),
                    Text('Sex: $sex'),
                    SizedBox(height: 20.0),
                    Text('Total Rides: $totalrides'),
                    SizedBox(height: 20.0),
                    Text('Cancelled Rides: $cancelledrides'),
                    SizedBox(height: 20.0),
                    Text('Actual Ratings: $actualrating'),
                  ],
                ),
              ),
            ),
          );
  }
}
