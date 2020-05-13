import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Center(
        child: Text('User Profile will be shown here ', style: TextStyle(fontSize: 25.0),),
      ),
    );
  }
}