import 'package:flutter/material.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/constants.dart';
import 'package:shareacab/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign in'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text('Register'),
                  onPressed: () {
                    widget.toggleView();
                  },
                ),
              ],
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
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter a valid Email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) => val.length < 6
                            ? 'Enter a password greater than 6 characters.'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            try {
                              bool flag = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (flag == false) {
                                setState(() {
                                  error =
                                      "ID not verified, verification mail sent again.";
                                });
                              }
                              setState(() => loading = false);
                            } catch (e) {
                              if (this.mounted) {
                                setState(() {
                                  switch (e.code) {
                                    case "ERROR_INVALID_EMAIL":
                                      error =
                                          "Your email address appears to be malformed.";
                                      break;
                                    case "ERROR_WRONG_PASSWORD":
                                      error = "Your password is wrong.";
                                      break;
                                    case "ERROR_USER_NOT_FOUND":
                                      error =
                                          "User with this email doesn't exist.";
                                      break;
                                    case "ERROR_USER_DISABLED":
                                      error =
                                          "User with this email has been disabled.";
                                      break;
                                    case "ERROR_TOO_MANY_REQUESTS":
                                      error =
                                          "Too many requests. Try again later.";
                                      break;
                                    case "ERROR_OPERATION_NOT_ALLOWED":
                                      error =
                                          "Signing in with Email and Password is not enabled.";
                                      break;
                                    default:
                                      {
                                        print("undefined error:" +
                                            error.toString());
                                        error = "An undefined Error happened.";
                                      }
                                  }
                                  loading = false;
                                  // Scaffold.of(context).showSnackBar(
                                  //     SnackBar(content: Text(error)));
                                });
                              }
                            }
                          }
                        },
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/accounts/forgotpass');
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
