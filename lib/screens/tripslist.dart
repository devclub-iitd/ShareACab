import 'package:shareacab/models/requestdetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/screens/groupscreen/group.dart';

class TripsList extends StatelessWidget {
  final List<RequestDetails> trips;

  TripsList(this.trips);

  @override
  Widget build(BuildContext context) {
    return trips.isEmpty
        ? Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: Container(
        height: 150,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        top: 20,
                      ),
                      child: Icon(
                        Icons.train,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      )
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Demo Trip',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    child:
                    FlatButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPage()));
                      },
                      child: Text('Join Now'),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 5,
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Start : May 21,2020 22:26',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'End : May 21, 2020 22:23',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[Text('Members')],
                ),
                Column(
                  children: <Widget>[Text('Going To')],
                )
              ],
            ),
          ],
        ),
      ),
    )
        : ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
            child: Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(
                              left: 20,
                              top: 20,
                            ),
                            child: trips[index].destination == 'New Delhi Railway Station'
                                ? Icon(
                              Icons.train,
                              color: Theme.of(context).accentColor,
                              size: 30,
                            )
                                : Icon(
                              Icons.airplanemode_active,
                              color: Theme.of(context).accentColor,
                              size: 30,
                            )),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '${trips[index].destination}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: trips[index].privacy
                              ? Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                              : FlatButton(
                            onPressed: null,
                            child: Text('Join Now'),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 5,
                      top: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Start : ${DateFormat.yMMMd().format(trips[index].startDate)} ${trips[index].startTime.toString().substring(10, 15)}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'End : ${DateFormat.yMMMd().format(trips[index].endDate)} ${trips[index].endTime.toString().substring(10, 15)}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[Text('Members')],
                      ),
                      Column(
                        children: <Widget>[Text('Going To')],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: trips.length);
  }
}