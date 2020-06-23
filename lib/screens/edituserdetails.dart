import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/database.dart';
import 'package:shareacab/shared/loading.dart';

class EditForm extends StatefulWidget {
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0.0,
                  title: Text('Edit User Details'),
                  actions: <Widget>[
                    FlatButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Navigator.pop(context);
                            setState(() {
                              if (name == '') {
                                name = snapshot.data['name'];
                              }
                              if (mobileNum == '') {
                                mobileNum = snapshot.data['mobileNumber'];
                              }
                              hostel ??= snapshot.data['hostel'];
                              sex ??= snapshot.data['sex'];
                            });
                            await DatabaseService(uid: user.uid).updateUserData(
                              name: name,
                              mobileNumber: mobileNum,
                              hostel: hostel,
                              sex: sex,
                            );
                          }
                        },
                        icon: Icon(
                          Icons.done,
                          color: getVisibleColorOnPrimaryColor(context),
                        ),
                        label: Text(
                          'Done',
                          style: TextStyle(color: getVisibleColorOnPrimaryColor(context)),
                        ))
                  ],
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                            initialValue: snapshot.data['name'],
                            decoration: InputDecoration(hintText: 'Name', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                            validator: (val) => val.isEmpty ? 'Enter a valid Name' : null,
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            initialValue: snapshot.data['mobileNumber'],
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
                            value: hostel ?? snapshot.data['hostel'],
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
                            decoration: InputDecoration(hintText: 'Select Gender', enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: getBorderColorForInputFields(context), width: 2.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0))),
                            value: sex ?? snapshot.data['sex'],
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
                          // RaisedButton(
                          //   color: Theme.of(context).accentColor,
                          //   child: Text('Update'),
                          //   onPressed: () async {
                          //     if (_formKey.currentState.validate()) {
                          //       Navigator.pop(context);
                          //       setState(() {
                          //         if (name == '') {
                          //           name = snapshot.data['name'];
                          //         }
                          //         if (mobileNum == '') {
                          //           mobileNum = snapshot.data['mobileNumber'];
                          //         }
                          //         hostel ??= snapshot.data['hostel'];
                          //         sex ??= snapshot.data['sex'];
                          //       });
                          //       await DatabaseService(uid: user.uid)
                          //           .updateUserData(
                          //         name: name,
                          //         mobileNumber: mobileNum,
                          //         hostel: hostel,
                          //         sex: sex,
                          //       );
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
