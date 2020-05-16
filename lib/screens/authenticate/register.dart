import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/constants.dart';
import 'package:shareacab/shared/loading.dart';

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
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        elevation: 0.0,
        title: Text('Sign up'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign in'),
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
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordHide
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme
                            .of(context)
                            .accentColor,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordHide = !passwordHide;
                        });
                      },
                    ),
                  ),
                  validator: (val) =>
                  val.length < 6
                      ? 'Enter a password greater than 6 characters.'
                      : null,
                  obscureText: passwordHide,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration:
                  textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) =>
                  val.isEmpty ? 'Enter a valid Name' : null,
                  onChanged: (val) {
                    setState(() => name = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'MobileNumber'),
                  validator: (val) =>
                  val.length != 10
                      ? 'Enter a valid mobile number.'
                      : null,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  onChanged: (val) {
                    setState(() => mobileNum = val);
                  },
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  hint: Text('Select Hostel'),
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
                  validator: (val) =>
                  val == null ? 'Please select your hostel' : null,
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  hint: Text('Select Sex'),
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
                  validator: (val) =>
                  val == null ? 'Please select your sex' : null,
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Theme.of(context).errorColor,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      try {
                        setState(() {
                          email = email.trim();
                        });
                        await _auth.registerWithEmailAndPassword(
                            email: email,
                            password: password,
                            name: name,
                            mobilenum: mobileNum,
                            hostel: hostel,
                            sex: sex);
                        setState(() {
                          loading = false;
                          error =
                          'Verification link has been sent to mailbox. Please verify and sign in.';
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
                                error =
                                'Email is already in use on different account';
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
                  style: TextStyle(color: Theme.of(context).errorColor, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}