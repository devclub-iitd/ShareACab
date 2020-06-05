import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './chat_tile.dart';

class ChatUsersList extends StatelessWidget {
  static FirebaseUser user;

  Future getChatDetails() async {
    final _auth = await FirebaseAuth.instance;
    user = await _auth.currentUser();
    final chatDocuments = await Firestore.instance.collection('chatroom').getDocuments();
    return chatDocuments.documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getChatDetails(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance.collection('chatroom').orderBy('lastMessage', descending: true).snapshots(),
          builder: (ctx, chatListSnapshots) {
            if (chatListSnapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatRoomDocs = chatListSnapshots.data.documents;
            //print(chatRoomDocs.length);
            return ListView.builder(
              itemCount: chatRoomDocs.length,
              itemBuilder: (context, index) {
                final docId = futureSnapshot.data[index].documentID;
                final destination = futureSnapshot.data[index].data['destination'];
                final lastMessage = futureSnapshot.data[index].data['lastMessage'];
                final List users = futureSnapshot.data[index].data['users'];
                //print(lastMessage.toString());
                if (users.contains(user.uid.toString())) {
                  return ChatTile(docId, destination, lastMessage);
                }
                return SizedBox(
                  height: 0,
                );
              },
            );
          },
        );
      },
    );
  }
}
