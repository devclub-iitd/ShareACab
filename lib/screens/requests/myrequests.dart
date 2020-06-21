import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> with AutomaticKeepAliveClientMixin<MyRequests> {
  List<Requests> requests = [
    Requests(name: 'Demo Request Trip-1', destination: 'New Delhi Railway Station', id: '1', status: 'Pending'),
    Requests(name: 'Demo Request Trip-2', destination: 'IGI Airport', id: '1', status: 'Accepted'),
    Requests(name: 'Demo Request Trip-3', destination: 'New Delhi Railway Station', id: '1', status: 'Rejected'),
  ];
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Requests'),
        ),
        body: requests.isEmpty
            ? Center(
                child: Text(
                  'No Requests to show',
                  style: TextStyle(fontSize: 25.0),
                ),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    child: ListTile(
                      onTap: () {},
                      title: Container(
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
                                      child: requests[index].destination == 'New Delhi Railway Station'
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
                                      '${requests[index].destination}',
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
                                        child: requests[index].status == 'Accepted'
                                            ? Column(
                                                children: <Widget>[
                                                  FlatButton(
                                                    onPressed: null,
                                                    child: Text('Accepted', style: TextStyle(color: requestAccepted(context), fontWeight: FontWeight.w700)),
                                                  ),
                                                  FlatButton(
                                                    onPressed: null,
                                                    child: Text('Join Now', style: TextStyle(color: requestAccepted(context), fontWeight: FontWeight.w700)),
                                                  )
                                                ],
                                              )
                                            : requests[index].status == 'Rejected'
                                                ? Column(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: null,
                                                        child: Text('Rejected', style: TextStyle(color: requestRejected(context), fontWeight: FontWeight.w700)),
                                                      ),
                                                      FlatButton(
                                                        onPressed: null,
                                                        child: Text('View Message', style: TextStyle(fontSize: 11.8, fontWeight: FontWeight.w700)),
                                                      )
                                                    ],
                                                  )
                                                : Column(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: null,
                                                        child: Text('Pending', style: TextStyle(color: requestPending(context), fontWeight: FontWeight.w700)),
                                                      ),
                                                      FlatButton(
                                                        onPressed: null,
                                                        child: Text(
                                                          'View Message',
                                                          style: TextStyle(fontSize: 11.8, fontWeight: FontWeight.w700),
                                                        ),
                                                      )
                                                    ],
                                                  )))
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
                                  children: <Widget>[
                                    Text('Members'),
                                    Text('Arpit'),
                                    Text('Vishal'),
                                    Text('Kshitij'),
                                    Text('Ishaan'),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text('Going To'),
                                    Text('Goa'),
                                    Text('Paris'),
                                    Text('London'),
                                    Text('New York'),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: requests.length));

  }
  @override
  bool get wantKeepAlive => true;
}

class Requests {
  @required
  final String name;
  @required
  final String id;
  @required
  final String destination;
  @required
  final String status;

  // Give status as Pending, Accepted and Declined.

  Requests({this.name, this.id, this.destination, this.status});
}
