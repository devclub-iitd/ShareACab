import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/services/trips.dart';

class CreateTrip extends StatefulWidget {
  static const routeName = '/createTrip';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> destinations = ['New Delhi Railway Station', 'Indira Gandhi International Airport', 'Anand Vihar ISBT', 'Hazrat Nizamuddin Railway Station'];
  List<int> maxpoolers = [1, 2, 3, 4, 5, 6];
  String _destination;
  int _maxPoolers;
  final _finalDestinationController = TextEditingController();
  DateTime _selectedStartDate;
  TimeOfDay _selectedStartTime;
  DateTime _selectedEndDate;
  TimeOfDay _selectedEndTime;
  bool privacy = false;
  final RequestService _request = RequestService();

  void _addNewRequest() async {
    final newRq = RequestDetails(name: 'Name', id: DateTime.now().toString(), destination: _destination, finalDestination: _finalDestinationController.text, startDate: _selectedStartDate, startTime: _selectedStartTime, endDate: _selectedEndDate, endTime: _selectedEndTime, privacy: privacy, maxPoolers: _maxPoolers);
    try {
      await _request.createTrip(newRq);
      // LOOK FOR A WAY TO SHOW A RESPONSE THAT THE TRIP HAS BEEN CREATED
      // _scaffoldKey.currentState.hideCurrentSnackBar();
      // await _scaffoldKey.currentState.showSnackBar(SnackBar(
      //   duration: Duration(seconds: 1),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   content: Text('Your Trip has been created', style: TextStyle(color: Theme.of(context).accentColor)),
      // ));
    } catch (e) {
      print(e.toString());
      //String errStr = e.message ?? e.toString();
      //final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
      //_scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _submitData() {
    _formKey.currentState.validate();
    final enteredDestination = _destination;
    final enteredFinalDestination = _finalDestinationController.text;

    if (enteredFinalDestination == null || _maxPoolers == null || enteredDestination == null) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Theme.of(context).primaryColor,
        content: Text('One or more fields is missing', style: TextStyle(color: Theme.of(context).accentColor)),
      ));
      return; //return stops function execution and thus nothing is called or returned
    } else if (_selectedStartDate == null || _selectedStartTime == null || _selectedEndDate == null || _selectedEndTime == null) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Theme.of(context).primaryColor,
        content: Text('Date or Time is missing', style: TextStyle(color: Theme.of(context).accentColor)),
      ));
      return;
    } else {
      setState(() {
        _formKey.currentState.save();
        _addNewRequest();
      });
      Navigator.of(context).pop();
    }
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
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
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
      initialTime: _selectedEndTime ?? _selectedStartTime,
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

  // SORTING THE LIST IN ALPHABETICAL FOR DESTINATIONS
  @override
  void initState() {
    destinations.sort();
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
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Create Trip'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
            //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: DropdownButtonFormField<String>(
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Destination';
                              }
                              return null;
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
                          child: TextFormField(
                            decoration: InputDecoration(hintText: 'Enter Your Final Destination'),
                            controller: _finalDestinationController,
                            // onSubmitted: (_) => _submitData(),
                            onChanged: (val) {},
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your final destination';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    buildLabel('Starting'),
                    buildContainer('Start', _selectedStartDate, _selectedStartTime, _startDatePicker, _startTimePicker),
                    buildLabel('Ending'),
                    buildContainer('End', _selectedEndDate, _selectedEndTime, _endDatePicker, _endTimePicker),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 40.0),
                          child: Text('Max No. of poolers: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        Container(
                          width: 45,
                          margin: EdgeInsets.only(top: 30.0, left: 20),
                          child: DropdownButtonFormField<int>(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 30,
                            ),
                            items: maxpoolers.map((int dropDownIntItem) {
                              return DropdownMenuItem<int>(
                                value: dropDownIntItem,
                                child: Text(
                                  dropDownIntItem.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: _maxPoolers,
                            onChanged: (val) {
                              setState(() {
                                _maxPoolers = val;
                              });
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Please Enter Max CabPoolers';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        left: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              checkColor: getVisibleColorOnAccentColor(context),
                              activeColor: Theme.of(context).accentColor,
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
                          var starting = DateTime(_selectedStartDate.year, _selectedStartDate.month, _selectedStartDate.day, _selectedStartTime.hour, _selectedStartTime.minute);
                          var ending = DateTime(_selectedEndDate.year, _selectedEndDate.month, _selectedEndDate.day, _selectedEndTime.hour, _selectedEndTime.minute);
                          if (starting.compareTo(ending) < 0) {
                            SystemChannels.textInput.invokeMethod('Text Input hide');
                            _submitData();
                          } else {
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 2),
                              content: Text(
                                'INVALID : Start Time > End Time',
                                style: TextStyle(color: Theme.of(context).accentColor),
                              ),
                            ));
                            SystemChannels.textInput.invokeMethod('Text Input hide');
                          }
                        },
                        color: Theme.of(context).accentColor,
                        child: Text('Create Trip', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
