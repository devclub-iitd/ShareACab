import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import './chat_tile.dart';

class ChatUsersList extends StatelessWidget {
  static FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
      stream: Firestore.instance.collection('chatroom').where('users', arrayContains: user.uid).orderBy('lastMessage', descending: true).snapshots(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: futureSnapshot.data == null ? 0 : futureSnapshot.data.documents.length,
          itemBuilder: (context, index) {
            final docId = futureSnapshot.data.documents[index].documentID;
            final destination = futureSnapshot.data.documents[index].data['destination'];
            final lastMessage = futureSnapshot.data.documents[index].data['lastMessage'];
            return ChatTile(docId, destination, lastMessage);
          },
        );
      },
    );
  }
}
