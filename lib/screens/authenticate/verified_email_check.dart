import 'dart:async' show Future, Timer;

import 'package:flutter/material.dart';
import 'package:shareacab/screens/rootscreen.dart';
import 'package:shareacab/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationCheck extends StatefulWidget {
  @override
  _VerificationCheckState createState() => _VerificationCheckState();
}

class _VerificationCheckState extends State<VerificationCheck> {
  final AuthService _auth = AuthService();
  FirebaseAuth auth;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';
  bool verified = false;

  // void _checkIfVerified() async {
  //   await FirebaseAuth.instance.currentUser()
  //     ..reload();
  //   var user = await FirebaseAuth.instance.currentUser();
  //   if (user.isEmailVerified) {
  //     setState(() {
  //       verified = user.isEmailVerified;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Timer _timer;
    // code for auto-check

    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        FirebaseUser olduser = await FirebaseAuth.instance.currentUser();
        await olduser.reload();
        var user = await FirebaseAuth.instance.currentUser();
        if (user.isEmailVerified) {
          setState(() {
            verified = user.isEmailVerified;
          });
          timer.cancel();
        }
      });
    });
    _timer = _timer;
    // void _checkIfVerified() async {
    //   await FirebaseAuth.instance.currentUser()
    //     ..reload();
    //   var user = await FirebaseAuth.instance.currentUser();
    //   if (user.isEmailVerified) {
    //     setState(() {
    //       verified = user.isEmailVerified;
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    var currentuser = Provider.of<FirebaseUser>(context);
    currentuser.reload();
    return verified
        ? RootScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
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
                          'Verification email has been sent to your ID. Please click on the verification link in your mail.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 40.0),
                    RichText(
                        text: TextSpan(
                      text:
                          'If you did not recieve it, please click on the button below',
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    )),
                    //SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Resend email',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        try {
                          _auth.verificationEmail(currentuser);
                        } catch (e) {
                          print(e.toString());
                          //need to show error in snackbar.
                          setState(() {
                            error = e.toString();
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    RichText(
                        text: TextSpan(
                      text:
                          'You will be auto-redirected to dashboard once you verify your account.',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic),
                    )),

                    // RaisedButton(
                    //   color: Colors.blue[400],
                    //   child: Text(
                    //     'Retry',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   onPressed: () {
                    //     if (currentuser.isEmailVerified) {
                    //       setState(() {
                    //         verified = true;
                    //       });
                    //     }
                    //   },
                    // ),

                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
  }
}
