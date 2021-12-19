import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';
import 'package:flutter/cupertino.dart';

import '../wrapper.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
  String verify = '';

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
        : WillPopScope(
            onWillPop: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
              return Future.value(false);
            },
            child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  elevation: 0.0,
                  title: Text(
                    'Sign up',
                    style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                  ),
                  actions: <Widget>[
                    TextButton.icon(
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
                body: Builder(
                  builder: (BuildContext context) {
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
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  child: Icon(
                                    CupertinoIcons.car_detailed,
                                    size: 48,
                                    color: getVisibleColorOnAccentColor(context),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0)),
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
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0)),
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
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Confirm Password',
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0)),
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
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(hintText: 'Name', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0))),
                                  validator: (val) => val.isEmpty ? 'Enter a valid Name' : null,
                                  onChanged: (val) {
                                    setState(() => name = val);
                                  },
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  decoration: InputDecoration(hintText: 'Mobile Number', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0))),
                                  validator: (val) => val.length != 10 ? 'Enter a valid mobile number.' : null,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  onChanged: (val) {
                                    setState(() => mobileNum = val);
                                  },
                                ),
                                SizedBox(height: 20.0),
                                DropdownButtonFormField(
                                  decoration: InputDecoration(hintText: 'Select Hostel', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0))),
                                  value: hostel,
                                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                                  onChanged: (newValue) {
                                    setState(() {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      hostel = newValue;
                                    });
                                  },
                                  items: _hostels.map((temp) {
                                    return DropdownMenuItem(
                                      value: temp,
                                      child: Text(temp),
                                    );
                                  }).toList(),
                                  validator: (val) => val == null ? 'Please select your hostel' : null,
                                ),
                                SizedBox(height: 20.0),
                                DropdownButtonFormField(
                                  decoration: InputDecoration(hintText: 'Select Gender', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0))),
                                  value: sex,
                                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                                  onChanged: (newValue) {
                                    setState(() {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      sex = newValue;
                                    });
                                  },
                                  items: _sex.map((temp) {
                                    return DropdownMenuItem(
                                      value: temp,
                                      child: Text(temp),
                                    );
                                  }).toList(),
                                  validator: (val) => val == null ? 'Please select your sex' : null,
                                ),
                                SizedBox(height: 20.0),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 17.0),
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: getVisibleColorOnAccentColor(context),
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      ProgressDialog pr;
                                      pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                                      pr.style(
                                        message: 'Signing up...',
                                        backgroundColor: Theme.of(context).backgroundColor,
                                        messageTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      );
                                      await pr.show();
                                      await Future.delayed(Duration(seconds: 1));
                                      try {
                                        await _auth.registerWithEmailAndPassword(email: email.trim(), password: password, name: name, mobilenum: mobileNum, hostel: hostel, sex: sex);

                                        verify = 'Verification link has been sent to mailbox. Please verify and sign in.';
                                        await pr.hide();
                                      } catch (e) {
                                        await pr.hide();
                                        if (mounted) {
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
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: Theme.of(context).primaryColor,
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                              error,
                                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                            ),
                                          ));
                                        }
                                      }
                                    }
                                  },
                                ),
                                SizedBox(height: 12.0),
                                Text(
                                  verify,
                                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          );
  }
}
