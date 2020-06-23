import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/models/alltrips.dart';

import '../main.dart';

class Filter extends StatefulWidget {
  final Function filtering;
  final bool _dest;
  final bool _date;
  final bool _time;
  final String _selecteddest;
  final DateTime _SD;
  final TimeOfDay _ST;
  final DateTime _ED;
  final TimeOfDay _ET;

  Filter(this.filtering, this._dest, this._date, this._time, this._selecteddest, this._SD, this._ST, this._ED, this._ET);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> destinations = ['New Delhi Railway Station', 'Indira Gandhi International Airport'];
  List<RequestDetails> _Trips = allTrips;

  String _destination;
  DateTime _selectedStartDate;
  TimeOfDay _selectedStartTime;
  DateTime _selectedEndDate;
  TimeOfDay _selectedEndTime;
  bool _dest = false;
  bool _time = false;
  bool _date = false;

  @override
  void initState() {
    _dest = widget._dest;
    _time = widget._time;
    _date = widget._date;
    _destination = widget._selecteddest;
    _selectedStartDate = widget._SD;
    _selectedEndDate = widget._ED;
    _selectedStartTime = widget._ST;
    _selectedEndTime = widget._ET;
    super.initState();
  }

  void _submitData() {
    if (_dest) {
      _Trips = _Trips.where((trip) {
        return trip.destination.contains(_destination);
      }).toList();
    }
    if (_date) {
      _Trips = _Trips.where((trip) {
        return (trip.startDate.isBefore(_selectedEndDate) && trip.endDate.isAfter(_selectedStartDate));
      }).toList();
    }
    if (_time) {
      var _startTime = double.parse(_selectedStartTime.hour.toString()) + double.parse(_selectedStartTime.minute.toString()) / 60;
      var _endTime = double.parse(_selectedEndTime.hour.toString()) + double.parse(_selectedEndTime.minute.toString()) / 60;
      _Trips = _Trips.where((trip) {
        var _tripStartTime = double.parse(trip.startTime.hour.toString()) + double.parse(trip.startTime.minute.toString()) / 60;
        var _tripEndTime = double.parse(trip.endTime.hour.toString()) + double.parse(trip.endTime.minute.toString()) / 60;
        if (trip.endDate.isAfter(trip.startDate)) {
          _tripEndTime = _tripEndTime + 24;
        }
        if (_startTime > _endTime) {
          _endTime = _endTime + 24;
        }
        return (_tripStartTime <= _endTime && _tripEndTime >= _startTime);
      }).toList();
    }
    setState(() {
      widget.filtering(_Trips, _dest, _date, _time, _destination, _selectedStartDate, _selectedStartTime, _selectedEndDate, _selectedEndTime);
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Center(
                  child: Text(
                '*filter is not working in the current version.',
                style: TextStyle(color: Theme.of(context).accentColor),
              )),
            ),
            SwitchListTile(
              title: Text('Destination'),
              value: _dest,
              subtitle: Text('Select Preferred Destination'),
              onChanged: (newValue) {
                setState(() {
                  _dest = newValue;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(
                left: 20,
                bottom: 20,
              ),
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
                onChanged: _dest
                    ? (newValue) {
                        setState(() {
                          _destination = newValue;
                        });
                      }
                    : null,
                hint: Text('Select The Destination'),
              ),
            ),
            SwitchListTile(
              title: Text('Date'),
              value: _date,
              subtitle: Text('Select Preferred Date Period'),
              onChanged: (newValue) {
                setState(() {
                  _date = newValue;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 20, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(_date ? _selectedStartDate == null ? 'Start Date' : '${DateFormat.yMd().format(_selectedStartDate)}' : 'Start Date'),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: _date ? () => _startDatePicker() : null,
                  ),
                  Text(_date ? _selectedEndDate == null ? 'End Date' : '${DateFormat.yMd().format(_selectedEndDate)}' : 'End Date'),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: _date ? () => _endDatePicker() : null,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: Text('Time'),
              value: _time,
              subtitle: Text('Select Preferred Time Interval'),
              onChanged: (newValue) {
                setState(() {
                  _time = newValue;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 20, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(_time ? _selectedStartTime == null ? 'Start Time' : '${_selectedStartTime.toString().substring(10, 15)}' : 'Start Time'),
                  IconButton(
                    icon: Icon(
                      Icons.schedule,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: _time ? () => _startTimePicker() : null,
                  ),
                  Text(_time ? _selectedEndTime == null ? 'End Time' : '${_selectedEndTime.toString().substring(10, 15)}' : 'End Time'),
                  IconButton(
                    icon: Icon(
                      Icons.schedule,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: _time ? () => _endTimePicker() : null,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 120,
                  margin: EdgeInsets.only(
                    top: 15,
                    bottom: 5,
                    right: 20,
                  ),
                  child: RaisedButton(
                    onPressed: () {
                      _submitData();
                    },
                    color: Theme.of(context).accentColor,
                    child: Text('Filter', style: TextStyle(fontSize: 16, color: getVisibleColorOnAccentColor(context))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
