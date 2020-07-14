import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
// import 'package:provider/provider.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/settings.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  bool passwordHide = false;

  // text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  void initState() {
    passwordHide = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                'Sign in',
              ),
              actions: <Widget>[
                IconButton(
                    tooltip: 'Settings',
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () {
                      return Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Settings(_auth);
                      }));
                    }),
                FlatButton.icon(
                  icon: Icon(Icons.person_add, color: getVisibleColorOnPrimaryColor(context)),
                  label: Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: getVisibleColorOnPrimaryColor(context)),
                  ),
                  onPressed: () {
                    widget.toggleView();
                  },
                ),
              ],
            ),
            body: Builder(builder: (BuildContext context) {
              return GestureDetector(
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
                          SizedBox(height: 20.0),
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Theme.of(context).accentColor,
                            child: Icon(
                              CupertinoIcons.car_detailed,
                              size: 48,
                              color: getVisibleColorOnAccentColor(context),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'ShareACab ',
                                style: TextStyle(
                                  fontFamily: 'Poiret',
                                  fontSize: 47,
                                  color: getVisibleTextColorOnScaffold(context),
                                  fontWeight: FontWeight.bold,
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Email', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                            validator: (val) => val.isEmpty ? 'Enter a valid Email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordHide ? Icons.visibility_off : Icons.visibility,
                                  color: getVisibleTextColorOnScaffold(context),
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordHide = !passwordHide;
                                  });
                                },
                              ),
                            ),
                            validator: (val) => val.length < 6 ? 'Enter a password greater than 6 characters.' : null,
                            obscureText: passwordHide,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: getVisibleColorOnAccentColor(context),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                //setState(() => loading = true);

                                ProgressDialog pr;
                                pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                                pr.style(
                                  message: 'Signing in...',
                                  backgroundColor: Theme.of(context).backgroundColor,
                                  messageTextStyle: TextStyle(
                                    color: getVisibleTextColorOnScaffold(context),
                                  ),
                                );
                                await pr.show();
                                await Future.delayed(Duration(seconds: 1));
                                try {
                                  email = email.trim();

                                  var flag = await _auth.signInWithEmailAndPassword(email, password);
                                  if (flag == false) {
                                    error = 'ID not verified, verification mail sent again.';
                                    Scaffold.of(context).hideCurrentSnackBar();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                        error,
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                      ),
                                    ));
                                  }
                                  await pr.hide();
                                  //setState(() => loading = false);
                                } catch (e) {
                                  await pr.hide();
                                  if (mounted) {
                                    switch (e.code) {
                                      case 'ERROR_INVALID_EMAIL':
                                        error = 'Your email address appears to be malformed.';
                                        break;
                                      case 'ERROR_WRONG_PASSWORD':
                                        error = 'Your password is wrong.';
                                        break;
                                      case 'ERROR_USER_NOT_FOUND':
                                        error = "User with this email doesn't exist.";
                                        break;
                                      case 'ERROR_USER_DISABLED':
                                        error = 'User with this email has been disabled.';
                                        break;
                                      case 'ERROR_TOO_MANY_REQUESTS':
                                        error = 'Too many requests. Try again later.';
                                        break;
                                      case 'ERROR_OPERATION_NOT_ALLOWED':
                                        error = 'Signing in with Email and Password is not enabled.';
                                        break;
                                      default:
                                        {
                                          print('undefined error:' + error.toString());
                                          error = 'An undefined Error happened.';
                                        }
                                    }
                                    //loading = false;
                                    Scaffold.of(context).hideCurrentSnackBar();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                        error,
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                      ),
                                    ));
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20.0),
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'FORGOT PASSWORD',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: getVisibleColorOnAccentColor(context),
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/accounts/forgotpass');
                            },
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Tip: Toggle theme from settings (icon in the AppBar).',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              color: getVisibleTextColorOnScaffold(context),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          // Text(
                          //   error,
                          //   style: TextStyle(color: Colors.red, fontSize: 14.0),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
