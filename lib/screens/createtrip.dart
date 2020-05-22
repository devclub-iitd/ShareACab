import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/models/alltrips.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/database.dart';
import 'package:shareacab/services/trips.dart';

class CreateTrip extends StatefulWidget {
  static const routeName = '/createTrip';

  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  List<String> destinations = ['New Delhi Railway Station', 'Indira Gandhi International Airport'];
  String _destination;
  final _finalDestinationController = TextEditingController();
  DateTime _selectedStartDate;
  TimeOfDay _selectedStartTime;
  DateTime _selectedEndDate;
  TimeOfDay _selectedEndTime;
  bool privacy = false;
  final RequestService _request = RequestService();

  void _addNewRequest() async {
    final newRq = RequestDetails(name: 'Name', id: DateTime.now().toString(), destination: _destination, finalDestination: _finalDestinationController.text, startDate: _selectedStartDate, startTime: _selectedStartTime, endDate: _selectedEndDate, endTime: _selectedEndTime, privacy: privacy);
    try {
      await _request.createTrip(newRq);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      allTrips.add(newRq);
    });
  }

  void _submitData() {
    final enteredDestination = _destination;
    final enteredFinalDestination = _finalDestinationController.text;
    if (enteredDestination.isEmpty || enteredFinalDestination.isEmpty || _selectedStartDate == null || _selectedStartTime == null || _selectedEndDate == null || _selectedEndTime == null) {
      return; //return stops function execution and thus nothing is called or returned
    }
    setState(() {
      _addNewRequest();
    });
    Navigator.of(context).pop();
  }

  void _startDatePicker() {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 1)), lastDate: DateTime.now().add(Duration(days: 30))).then((pickedDate) {
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
    showDatePicker(context: context, initialDate: _selectedStartDate, firstDate: DateTime.parse(_selectedStartDate.toString()), lastDate: DateTime.now().add(Duration(days: 30))).then((pickedDate) {
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
      initialTime: TimeOfDay.now(),
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
      initialTime: TimeOfDay.now(),
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
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Create Trip'),
        ),
        body: Container(
          //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildLabel('Destination'),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        left: 40,
                      ),
                      //width: MediaQuery.of(context).size.width * 0.7,
                      child: DropdownButton<String>(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                        ),
                        items: destinations.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          );
                        }).toList(),
                        value: _destination,
                        onChanged: (val) {
                          setState(() {
                            _destination = val;
                          });
                        },
                        hint: Text('Select The Destination'),
                      ),
                    ),
                  ],
                ),
                buildLabel('Going To'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      margin: EdgeInsets.only(top: 20, left: 40),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Enter Your Final Destination'),
                        controller: _finalDestinationController,
                        onSubmitted: (_) => _submitData(),
                        onChanged: (val) {},
                      ),
                    ),
                  ],
                ),
                buildLabel('Starting'),
                buildContainer('Start', _selectedStartDate, _selectedStartTime, _startDatePicker, _startTimePicker),
                buildLabel('Ending'),
                buildContainer('End', _selectedEndDate, _selectedEndTime, _endDatePicker, _endTimePicker),
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                    left: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                          value: privacy,
                          onChanged: (bool value) {
                            setState(() {
                              privacy = value;
                            });
                          }),
                      Text('Require Permission To Join Trip',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          )),
                    ],
                  ),
                ),
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
                      SystemChannels.textInput.invokeMethod('Text Input hide');
                      _submitData();
                    },
                    color: Theme.of(context).accentColor,
                    child: Text('Create Trip', style: TextStyle(fontSize: 18)),
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
