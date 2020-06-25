import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';
import 'package:flutter/cupertino.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String confirmpass = '';
  String name = '';
  String mobileNum = '';
  String hostel;
  String sex;
  String error = '';

  final List<String> _sex = [
    'Female',
    'Male',
    'Others',
  ];

  final List<String> _hostels = [
    'Aravali',
    'Girnar',
    'Himadri',
    'Jwalamukhi',
    'Kailash',
    'Karakoram',
    'Kumaon',
    'Nilgiri',
    'Shivalik',
    'Satpura',
    'Udaigiri',
    'Vindhyachal',
    'Zanskar',
    'Day Scholar',
  ];

  bool passwordHide = false;

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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              title: Text(
                'Sign up',
                style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
              ),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person, color: getVisibleColorOnPrimaryColor(context)),
                  label: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18, color: getVisibleColorOnPrimaryColor(context)),
                  ),
                  onPressed: () {
                    widget.toggleView();
                  },
                ),
              ],
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
                        SizedBox(height: 20.0),
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Theme.of(context).accentColor,
                          child: Icon(
                            CupertinoIcons.car_detailed,
                            size: 48,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                          ),
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
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Password',
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordHide ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).accentColor,
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
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordHide ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordHide = !passwordHide;
                                });
                              },
                            ),
                          ),
                          validator: (val) {
                            if (val.length < 6) {
                              return 'Enter a password greater than 6 characters.';
                            }
                            if (val != password) {
                              return 'Password not matching';
                            }
                            return null;
                          },
                          obscureText: passwordHide,
                          onChanged: (val) {
                            setState(() => confirmpass = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Name', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                          validator: (val) => val.isEmpty ? 'Enter a valid Name' : null,
                          onChanged: (val) {
                            setState(() => name = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Mobile Number', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                          validator: (val) => val.length != 10 ? 'Enter a valid mobile number.' : null,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                          onChanged: (val) {
                            setState(() => mobileNum = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        DropdownButtonFormField(
                          decoration: InputDecoration(hintText: 'Select Hostel', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                          value: hostel,
                          onChanged: (newValue) {
                            setState(() {
                              hostel = newValue;
                            });
                          },
                          items: _hostels.map((temp) {
                            return DropdownMenuItem(
                              child: Text(temp),
                              value: temp,
                            );
                          }).toList(),
                          validator: (val) => val == null ? 'Please select your hostel' : null,
                        ),
                        SizedBox(height: 20.0),
                        DropdownButtonFormField(
                          decoration: InputDecoration(hintText: 'Select Gendet', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                          value: sex,
                          onChanged: (newValue) {
                            setState(() {
                              sex = newValue;
                            });
                          },
                          items: _sex.map((temp) {
                            return DropdownMenuItem(
                              child: Text(temp),
                              value: temp,
                            );
                          }).toList(),
                          validator: (val) => val == null ? 'Please select your sex' : null,
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 17.0),
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).scaffoldBackgroundColor,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              try {
                                await _auth.registerWithEmailAndPassword(email: email.trim(), password: password, name: name, mobilenum: mobileNum, hostel: hostel, sex: sex);

                                setState(() {
                                  loading = false;
                                  error = 'Verification link has been sent to mailbox. Please verify and sign in.';
                                });
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    switch (e.code) {
                                      case 'ERROR_WEAK_PASSWORD':
                                        error = 'Your password is too weak';
                                        break;
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
            ),
          );
  }
}
