import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/database.dart';

class EditGroup extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final String groupUID;
  EditGroup({Key key, this.groupUID}) : super(key: key);

  @override
  _EditGroupState createState() => _EditGroupState(groupUID);
}

class _EditGroupState extends State<EditGroup> {
  final DatabaseService _databaseService = DatabaseService();
  String groupUID;
  _EditGroupState(this.groupUID);

  DateTime _selectedStartDate;
  TimeOfDay _selectedStartTime;
  DateTime _selectedEndDate;
  TimeOfDay _selectedEndTime;

  Timestamp startTS;
  Timestamp endTS;

  void _updateGroup() async {
    try {
      await _databaseService.updateGroup(groupUID, _selectedStartDate, _selectedStartTime, _selectedEndDate, _selectedEndTime);
    } catch (e) {
      print(e.toString());
    }
  }

  void _submitData() {
    if (_selectedStartDate == null || _selectedStartTime == null || _selectedEndDate == null || _selectedEndTime == null) {
      return; //return stops function execution and thus nothing is called or returned
    }
    setState(() {
      _updateGroup();
    });
    Navigator.of(context).pop();
  }

  void _startDatePicker() {
    showDatePicker(context: context, initialDate: _selectedStartDate, firstDate: DateTime.parse(_selectedStartDate.toString()), lastDate: DateTime.now().add(Duration(days: 30))).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedStartDate = pickedDate;
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  void _endDatePicker() {
    showDatePicker(context: context, initialDate: _selectedEndDate, firstDate: DateTime.parse(_selectedEndDate.toString()), lastDate: DateTime.now().add(Duration(days: 30))).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedEndDate = pickedDate;
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  void _startTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedStartTime = pickedTime;
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  void _endTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedEndTime = pickedTime;
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  Widget buildLabel(String label) {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
        left: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainer(String point, DateTime date, TimeOfDay time, Function DatePicker, Function TimePicker) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(date == null ? '$point Date' : '${DateFormat.yMd().format(date)}'),
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => DatePicker(),
          ),
          Text(time == null ? '$point Time' : '${time.toString().substring(10, 15)}'),
          IconButton(
            icon: Icon(
              Icons.schedule,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => TimePicker(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Firestore.instance.collection('group').document(groupUID).get().then((value) {
      setState(() {
        startTS = value.data['start'];
        endTS = value.data['end'];
        _selectedStartDate = startTS.toDate();
        _selectedEndDate = endTS.toDate();
        _selectedStartTime = TimeOfDay(hour: _selectedStartDate.hour, minute: _selectedStartDate.minute);
        _selectedEndTime = TimeOfDay(hour: _selectedEndDate.hour, minute: _selectedEndDate.minute);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Group'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildLabel('Starting'),
                buildContainer('Start', _selectedStartDate, _selectedStartTime, _startDatePicker, _startTimePicker),
                buildLabel('Ending'),
                buildContainer('End', _selectedEndDate, _selectedEndTime, _endDatePicker, _endTimePicker),
                Container(
                  height: 50,
                  width: 150,
                  margin: EdgeInsets.only(
                    top: 40,
                    bottom: 30,
                    right: 20,
                  ),
                  child: RaisedButton(
                    textColor: getVisibleColorOnAccentColor(context),
                    onPressed: () {
                      _submitData();
                    },
                    color: Theme.of(context).accentColor,
                    child: Text('Update Trip', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
