import 'package:flutter/material.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                    setState(() => loading = true);
                    try {
                      await _auth.signOut();
                      setState(() => loading = false);
                    } catch (e) {
                      setState(() {
                        error = e.message;
                        setState(() => loading = false);
                      });
                    }
                  },
                  label: Text('Logout'),
                )
              ],
            ),
            body: Center(child: Text("ShareACab")),
          );
  }
}
