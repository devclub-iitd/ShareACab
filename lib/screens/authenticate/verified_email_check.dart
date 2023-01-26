import 'dart:async' show Future, Timer;
import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/authenticate/change_email.dart';
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
  String email = '';

  @override
  void initState() {
    super.initState();
    // code for auto-check

    Future(() async {
      Timer.periodic(Duration(seconds: 5), (timer) async {
        // User
        var olduser = FirebaseAuth.instance.currentUser;
        await olduser.reload();
        var user = FirebaseAuth.instance.currentUser;
        if (user.emailVerified) {
          setState(() {
            verified = user.emailVerified;
          });
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentuser = Provider.of<User>(context);

    email = currentuser.email;

    currentuser.reload();
    return verified
        ? RootScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Verification Screen'),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: getVisibleColorOnPrimaryColor(context),
                  ),
                  onPressed: () async {
                    setState(() => loading = true);
                    try {
                      await _auth.signOut();
                      setState(() => loading = false);
                    } catch (e) {
                      setState(() {
                        error = e.message;
                        Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Text(
                              e.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).accentColor),
                            )));
                        setState(() => loading = false);
                      });
                    }
                  },
                  label: Text(
                    'Logout',
                    style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                  ),
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
                      text: 'Verification email has been sent to your ID. Please click on the verification link in your mail.',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: getBorderColorForInputFields(context)),
                    )),
                    SizedBox(height: 30.0),
                    RichText(
                      text: TextSpan(
                        text: 'The registered email id is: $email',
                        style: TextStyle(fontSize: 17.0, color: getBorderColorForInputFields(context), fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                          ),
                          child: Text(
                            'Resend email',
                            style: TextStyle(color: getVisibleColorOnAccentColor(context)),
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
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  content: Text(
                                    error,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )));
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                          ),
                          child: Text(
                            'Change email',
                            style: TextStyle(color: getVisibleColorOnAccentColor(context)),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    RichText(
                        text: TextSpan(
                      text: 'You will be auto-redirected to dashboard once you verify your account.',
                      style: TextStyle(color: Colors.red, fontSize: 20.0, fontStyle: FontStyle.italic),
                    )),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
  }
}
