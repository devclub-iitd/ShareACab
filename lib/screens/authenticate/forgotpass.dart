import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/auth.dart';
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 100.0),
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            CupertinoIcons.car_detailed,
                            size: 48,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Email', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                          validator: (val) => val.isEmpty ? 'Enter a valid Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              'SEND RESET LINK',
                              style: TextStyle(
                                color: getVisibleColorOnAccentColor(context),
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),
                            ),
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
                        SizedBox(height: 15.0),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              'GO BACK TO SIGN IN',
                              style: TextStyle(
                                color: getVisibleColorOnAccentColor(context),
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
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
