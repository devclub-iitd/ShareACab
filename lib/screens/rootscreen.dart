import 'package:flutter/material.dart';
import 'package:shareacab/services/auth.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text("Share A "),
            Text(
              "Cab",
              style: TextStyle(fontWeight: FontWeight.w900),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('Logout'),
          )
        ],
      ),
      body: Center(child: Text("ShareACab")),
    );
  }
}
