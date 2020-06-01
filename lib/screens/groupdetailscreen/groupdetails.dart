import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './appbar.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/services/trips.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupDetails extends StatelessWidget {
//  static const routeName = '/groupDetails';

  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final startTime;
  final endTime;
  final docId;
  final privacy;

  GroupDetails(this.destination, this.startDate, this.startTime, this.endDate, this.endTime, this.docId, this.privacy);

  final RequestService _request = RequestService();

  Future getUserDetails() async {
    final userDetails = await Firestore.instance.collection('group').document(docId).collection('users').getDocuments();
    return userDetails.documents;
  }

  static bool inGroup = false;

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    Firestore.instance.collection('userdetails').document(currentuser.uid).get().then((value) {
      if (value.data['currentGroup'] != null) {
        inGroup = true;
      } else {
        inGroup = false;
      }
    });
    return Scaffold(
      body: FutureBuilder(
          future: getUserDetails(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  expandedHeight: 210,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      destination == 'New Delhi Railway Station' ? 'assets/images/train.jpg' : 'assets/images/plane.jpg',
                      fit: BoxFit.cover,
                    ),
                    title: AppBarTitle(destination),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
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
                                        '${startTime.substring(10, 15)}',
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
                                        '${endTime.substring(10, 15)}',
                                        style: TextStyle(letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(top: 60),
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.builder(
                                  itemCount: futureSnapshot.data.length,
                                  itemBuilder: (ctx, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 4,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(futureSnapshot.data[index].data['name']),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(futureSnapshot.data[index].data['hostel']),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
      bottomNavigationBar: FlatButton(
        onPressed: () async {
          try {
            if (privacy == true || inGroup) {
              null;
            } else {
              await _request.joinGroup(docId);
              inGroup = true;
            }
          } catch (e) {
            print(e.toString());
          }
        },
        padding: EdgeInsets.all(20),
        child: privacy == 'true'
            ? Text(
                'Request to Join',
                style: TextStyle(fontSize: 20),
              )
            : inGroup
                ? Text(
                    'Already in a Group',
                    style: TextStyle(fontSize: 20),
                  )
                : Text('Join Now', style: TextStyle(fontSize: 20)),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
