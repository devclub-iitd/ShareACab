import 'package:flutter/material.dart';
import 'package:shareacab/services/auth.dart';

class VerificationCheck extends StatefulWidget {
  @override
  _VerificationCheckState createState() => _VerificationCheckState();
}

class _VerificationCheckState extends State<VerificationCheck> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Verification Screen'),
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              RichText(
                  text: TextSpan(
                text:
                    'Verification email has been resent to your ID. Please click on the verification link in your mail and then login again to proceed.',
                style: TextStyle(color: Colors.red, fontSize: 20.0),
              )),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
