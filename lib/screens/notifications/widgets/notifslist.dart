import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import './notiftile.dart';
import 'package:shareacab/screens/notifications/services/notifservices.dart';

class NotifsList extends StatefulWidget {
  static FirebaseUser user;

  @override
  _NotifsListState createState() => _NotifsListState();
}

class _NotifsListState extends State<NotifsList> {
  final NotifServices _notifServices = NotifServices();

  Future getUserDetails(String uid, String purpose, String notifId, var response) async {
    var currentGroup;
    await Firestore.instance.collection('userdetails').document(uid).get().then((value) {
      currentGroup = value.data['currentGroup'];
    });
    if (currentGroup != null && purpose == 'Request to Join' && response == null) {
      await _notifServices.removeNotif(notifId, purpose, uid, response);
      return null;
    }
    return 'del';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
      stream: Firestore.instance.collection('userdetails').document(user.uid).collection('Notifications').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
        }
        return ListView.builder(
          itemCount: futureSnapshot.data == null ? 0 : futureSnapshot.data.documents.length,
          itemBuilder: (context, index) {
            final docId = futureSnapshot.data.documents[index].documentID;
            final fromuid = futureSnapshot.data.documents[index].data['from'];
            final name = futureSnapshot.data.documents[index].data['senderName'];
            final createdAt = futureSnapshot.data.documents[index].data['createdAt'];
            final response = futureSnapshot.data.documents[index].data['response'];
            final purpose = futureSnapshot.data.documents[index].data['purpose'];
            return FutureBuilder(
                future: getUserDetails(fromuid, purpose, docId, response),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // print('loading..');
                  }
                  if (snapshot != null) {
                    return NotifTile(docId, fromuid, name, createdAt, response, purpose);
                  }
                  return null;
                });
          },
        );
      },
    );
  }
}
