import 'package:flutter/material.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/constants.dart';
import 'package:shareacab/shared/loading.dart';

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              title: Text('Forgot Password'),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) => val.isEmpty ? 'Enter a valid Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            'Send Password Reset Link',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              try {
                                setState(() {
                                  email = email.trim();
                                });
                                await _auth.resetPassword(email);
                                setState(() => message = 'Email sent');
                                setState(() => loading = false);
                              } catch (e) {
                                setState(() {
                                  switch (e.code) {
                                    case 'ERROR_USER_NOT_FOUND':
                                      message = "User with this email doesn't exist.";
                                      break;
                                    case 'ERROR_USER_DISABLED':
                                      message = 'User with this email has been disabled.';
                                      break;
                                    case 'ERROR_TOO_MANY_REQUESTS':
                                      message = 'Too many requests. Try again later.';
                                      break;
                                    default:
                                      message = 'An undefined Error happened.';
                                  }
                                });
                                setState(() => loading = false);
                              }
                            } else {
                              setState(() => message = 'Incorrect Email');
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text('Go back to Sign In'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          message,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
