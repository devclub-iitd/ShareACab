import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shareacab/screens/chatscreen/chat_widgets/chat_bubble.dart';

class MessageScreen extends StatelessWidget {
  final String docId;

  MessageScreen(this.docId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        print(docId);
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chatroom')
                .document(docId)
                .collection('chats')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              print('bye');
              print(chatDocs.length);
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(chatDocs[index]['text'], chatDocs[index]['name'], chatDocs[index]['userId'] == futureSnapshot.data.uid, key: ValueKey(chatDocs[index].documentID)),
              );
            });
      },
    );
  }
}
