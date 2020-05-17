import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewRequest extends StatefulWidget {
  final Function addRq;
  NewRequest(this.addRq);
  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {

  List<String> destinations = ['New Delhi Railway Station', 'Indira Gandhi International Airport'];

  String _destination;
  final _finalDestinationController = TextEditingController();
  DateTime _selectedStartDate;
  TimeOfDay _selectedStartTime;
  DateTime _selectedEndDate;
  TimeOfDay _selectedEndTime;
  bool privacy = false;

  void _submitData(){
    final enteredDestination = _destination;
    final enteredFinalDestination = _finalDestinationController.text;
    if(enteredDestination.isEmpty || enteredFinalDestination.isEmpty || _selectedStartDate == null || _selectedStartTime == null || _selectedEndDate == null || _selectedEndTime == null ){
      return; //return stops function execution and thus nothing is called or returned
    }
    widget.addRq(
        _destination,
        _finalDestinationController.text,
        _selectedStartDate,
        _selectedStartTime,
        _selectedEndDate,
        _selectedEndTime,
        privacy
    );
    Navigator.of(context).pop();
  }

  void _startDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 30))
    ).then((pickedDate) {
      if(pickedDate == null){
        return;
      }
      setState(() {
        _selectedStartDate = pickedDate;
      });
    });
  }

  void _endDatePicker(){
    showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime.parse(_selectedStartDate.toString()),
        lastDate: DateTime.now().add(Duration(days: 30))
    ).then((pickedDate) {
      if(pickedDate == null){
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
      if(pickedTime == null){
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
      if(pickedTime == null){
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
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              child: DropdownButton<String>(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30,
                ),
                items: destinations.map((String dropDownStringItem) {
                  return DropdownMenuItem<String> (
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  );
                }).toList(),
                value: _destination,
                onChanged:(val){
                  setState(() {
                    this._destination = val;
                  });
                },
                hint: Text('Select The Destination'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Going To'),
                controller: _finalDestinationController,
                onSubmitted: (_) => _submitData(),
                //onChanged: (val) => amountInput = val,
              ),
            ),

            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 5,
                    ),
                    child: Text(
                        _selectedStartDate == null
                            ? 'Choose Start Date'
                            : '${DateFormat.yMd().format(_selectedStartDate)}'
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed:() => _startDatePicker() ,
                  ),
                  Text(
                      _selectedStartTime == null
                          ? 'Choose Start Time'
                          : '${_selectedStartTime.toString().substring(10,15)}'
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.alarm,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed:() => _startTimePicker() ,
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 5,
                    ),
                    child: Text(
                        _selectedEndDate == null
                            ? 'Choose End Date'
                            : '${DateFormat.yMd().format(_selectedEndDate)}'
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed:() => _endDatePicker(),
                  ),
                  Text(
                      _selectedEndTime == null
                          ? 'Choose End Time'
                          : '${_selectedEndTime.toString().substring(10,15)}'
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.alarm,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed:() => _endTimePicker() ,
                  ),
                ],
              ),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                      checkColor: Theme.of(context).accentColor,
                      value: privacy,
                      onChanged: (bool value){
                        setState(() {
                          privacy = value;
                        });
                      }
                  ),
                  Text('Require Permission To Join Trip',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(
                top: 10,
                bottom: 30,
                right: 20,
              ),
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: _submitData,
                color: Theme.of(context).primaryColor,
                child: Text('Create Trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
