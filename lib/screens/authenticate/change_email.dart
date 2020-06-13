import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/constants.dart';
import 'package:shareacab/shared/loading.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  String email = '';
  final AuthService _auth = AuthService();
  String originalEmail = '';
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var currentuser = Provider.of<FirebaseUser>(context);
    if (currentuser != null) {
      setState(() {
        originalEmail = currentuser.email;
      });
    }
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              title: Text('Change Email'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        initialValue: originalEmail,
                        decoration:
                            // use this inputdecoration of IITD email
                            //textInputDecoration.copyWith(hintText: 'Kerberos email'),
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter a valid Email';
                          } else {
                            return null;
                          }

                          // uncomment below lines for iitd.ac.in validator

                          // if (val.endsWith('iitd.ac.in')) {
                          //   return null;
                          // } else {
                          //   return 'Enter valid IITD email';
                          // }
                        },
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            'Change Email',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                setState(() {
                                  loading = true;
                                });
                                await _auth.changeEmail(email);
                                await _auth.signOut();
                                await Navigator.pushNamedAndRemoveUntil(context, '/wrapper', (route) => false);
                                //await Navigator.popUntil(context, ModalRoute.withName('/wrapper'));
                                setState(() {
                                  loading = false;
                                });
                              } catch (e) {
                                print(e.toString());
                                if (mounted) {
                                  setState(() {
                                    switch (e.code) {
                                      case 'ERROR_INVALID_EMAIL':
                                        error = 'Your email is invalid';
                                        break;
                                      case 'ERROR_EMAIL_ALREADY_IN_USE':
                                        error = 'Email is already in use on different account';
                                        break;
                                      default:
                                        error = 'An undefined Error happened.';
                                    }
                                    loading = false;
                                  });
                                }
                              }
                            }
                          }),
                      SizedBox(height: 24.0),
                      Text(
                        'Once you change your email, please log-in again by entering your new email ID and your previous password.',
                        style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
