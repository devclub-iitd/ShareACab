import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './appbar.dart';
import 'package:intl/intl.dart';

class GroupDetails extends StatelessWidget {
//  static const routeName = '/groupDetails';

  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final startTime;
  final endTime;
  final List users;
  GroupDetails(this.destination, this.startDate,this.startTime, this.endDate, this.endTime, this.users);

//  Future getGroupDetails() async {
//    final groupDetails =
//        await Firestore.instance.collection('group').document(docId).get();
//    return groupDetails;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  expandedHeight: 210,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      destination ==
                              'New Delhi Railway Station'
                          ? 'assets/images/train.jpg'
                          : 'assets/images/plane.jpg',
                      fit: BoxFit.cover,
                    ),
                    title: AppBarTitle(destination),
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    children: <Widget>[
                      Container(
                    margin: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 10,
                            right: 50,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 0.25,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Start Date',
                                  style: TextStyle(letterSpacing: 2),
                                ),
                              ),
                              Text(
                                DateFormat.yMd().format(startDate),
                                style: TextStyle(letterSpacing: 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 50,
                            right: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'End Date',
                                  style: TextStyle(letterSpacing: 2),
                                ),
                              ),
                              Text(
                                DateFormat.yMd().format(endDate),
                                style: TextStyle(letterSpacing: 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 10,
                            right: 50,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 0.25,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Start Time',
                                  style: TextStyle(letterSpacing: 2),
                                ),
                              ),
                              Text(
                                '${startTime.substring(10,15)}',
                                style: TextStyle(
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 50,
                            right: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'End Time',
                                  style: TextStyle(letterSpacing: 2),
                                ),
                              ),
                              Text(
                                '${endTime.substring(10,15)}',
                                style: TextStyle(letterSpacing: 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                    ],
                  ),

                ),
              ],
            ),
    );
  }
}
