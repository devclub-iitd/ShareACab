import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

//import './appbar.dart';
import 'package:shareacab/services/trips.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupDetails extends StatelessWidget {
//  static const routeName = '/groupDetails';

  final String destination;
  final docId;
  final privacy;
  final start;
  final end;

  GroupDetails(
      this.destination, this.start, this.end, this.docId, this.privacy);

  final RequestService _request = RequestService();

  Future getUserDetails() async {
    final userDetails = await Firestore.instance
        .collection('group')
        .document(docId)
        .collection('users')
        .getDocuments();
    return userDetails.documents;
  }

  static bool inGroup = false;

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<FirebaseUser>(context);
    Firestore.instance
        .collection('userdetails')
        .document(currentuser.uid)
        .get()
        .then((value) {
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
                  //expandedHeight: 210,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    // background: Image.asset(
                    //   destination == 'New Delhi Railway Station' ? 'assets/images/train.jpg' : 'assets/images/plane.jpg',
                    //   fit: BoxFit.cover,
                    // ),
                    //title: AppBarTitle(destination),
                    // THE ABOVE WAS THROWING AN ERROR, WILL CHECK LATER
                    title: Text(destination),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 10),
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
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Start:',
                                          style: TextStyle(letterSpacing: 2),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd.MM.yyyy - kk:mm a')
                                            .format(start),
                                        style: TextStyle(letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
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
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'End:',
                                          style: TextStyle(letterSpacing: 2),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd.MM.yyyy - kk:mm a')
                                            .format(end),
                                        style: TextStyle(
                                          letterSpacing: 2,
                                        ),
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
                                      margin: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(futureSnapshot
                                                  .data[index].data['name']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(futureSnapshot
                                                  .data[index].data['hostel']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                  onPressed: () async {
                                                   try {
                                                      await launch(
                                                        'tel://${futureSnapshot.data[index].data['mobilenum'].toString()}');
                                                    } catch(e) {
                                                      await Clipboard.setData(ClipboardData(text : '${futureSnapshot.data[index].data['mobilenum'].toString()}')).then((result) {
                                                      final snackBar = SnackBar(
                                                        backgroundColor: Theme.of(context).primaryColor,
                                                        content: Text('Copied to Clipboard', style: TextStyle(color: Theme.of(context).accentColor),),
                                                        duration: Duration(seconds: 1),
                                                      );
                                                      Scaffold.of(ctx).hideCurrentSnackBar();
                                                      Scaffold.of(ctx).showSnackBar(snackBar);
                                                    });
                                                    }
                                                  },
                                                  icon: Icon(Icons.phone, color: Theme.of(context).accentColor,)),
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
