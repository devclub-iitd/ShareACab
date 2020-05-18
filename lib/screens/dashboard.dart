import 'package:shareacab/models/Request_details.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/screens/addroom.dart';
import 'package:shareacab/screens/trips_list.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final List<RequestDetails> _allRequests = [];

  void _addNewRequest(
      String rqDest,
      String rqFinalDest,
      DateTime startDate,
      TimeOfDay startTime,
      DateTime endDate,
      TimeOfDay endTime,
      bool privacy) {
    final newRq = RequestDetails(
        name: 'Name',
        id: DateTime.now().toString(),
        destination: rqDest,
        finalDestination: rqFinalDest,
        startDate: startDate,
        startTime: startTime,
        endDate: endDate,
        endTime: endTime,
        privacy: privacy
    );
    setState(() {
      _allRequests.add(newRq);
    });
  }
  void _startCreatingRequests(BuildContext ctx){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
      ),
      context: ctx,
      builder: (_) {

        return GestureDetector(
          onTap: () {},
          child: NewRequest(_addNewRequest),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom)*0.84 ,
            width: double.infinity,
            child: TripsList(_allRequests),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () => _startCreatingRequests(context),
          child: Icon(Icons.add)
      ),
    );
  }
}
