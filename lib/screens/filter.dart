import 'package:flutter/material.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/models/alltrips.dart';
import '../main.dart';

class Filter extends StatefulWidget {
  final Function filtering;
  final bool _dest;
  final bool _notPrivacy;
  final String _selecteddest;
  Filter(this.filtering, this._dest, this._selecteddest, this._notPrivacy);
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> destinations = ['New Delhi Railway Station', 'Indira Gandhi International Airport', 'Anand Vihar ISBT', 'Hazrat Nizamuddin Railway Station'];
  List<RequestDetails> _Trips = allTrips;

  String _destination;
  bool _dest = false;
  bool _notPrivacy = false;

  @override
  void initState() {
    _dest = widget._dest;
    _notPrivacy = widget._notPrivacy;
    _destination = widget._selecteddest;
    super.initState();
  }

  void _submitData() {
    if (_dest) {
      _Trips = _Trips.where((trip) {
        return trip.destination.contains(_destination);
      }).toList();
    }
    setState(() {
      widget.filtering(_dest, _destination, _notPrivacy);
    });
    Navigator.of(context).pop();
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
            SwitchListTile(
              title: Text('Destination'),
              value: _dest,
              subtitle: Text('Select Preferred Destination'),
              activeColor: Theme.of(context).accentColor,
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
              title: Text('Privacy'),
              value: _notPrivacy,
              subtitle: Text('Only see groups which are Free to Join'),
              activeColor: Theme.of(context).accentColor,
              onChanged: (newValue) {
                setState(() {
                  _notPrivacy = newValue;
                });
              },
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
                  child: ElevatedButton(
                    onPressed: () {
                      _submitData();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
                    ),
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
