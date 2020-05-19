import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shareacab/shared/constants.dart';

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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'Update your user details.',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Name'),
              validator: (val) => val.isEmpty ? 'Enter a valid Name' : null,
              onChanged: (val) {
                setState(() => name = val);
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration:
                  textInputDecoration.copyWith(hintText: 'Mobile Number'),
              validator: (val) =>
                  val.length != 10 ? 'Enter a valid mobile number.' : null,
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
              validator: (val) => val == null ? 'Please select your sex' : null,
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text('Update'),
              onPressed: () async {
                Navigator.pop(context);
                print(name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
