import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shareacab/screens/chatscreen/chat_screen.dart';
import 'package:intl/intl.dart';

class ChatUsersList extends StatelessWidget {
  var _auth;
  var user;
  void updateUser() async {
     _auth = await FirebaseAuth.instance;
     user = await _auth.currentUser();
  }
  final CollectionReference group = Firestore.instance.collection('group');
  String destination;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if(futureSnapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance.collection('chatroom').orderBy('lastMessageAt', descending: true).snapshots(),
          builder: (ctx, chatListSnapshots){
            if(chatListSnapshots.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatRoomDocs = chatListSnapshots.data.documents;
            return ListView.builder(
              itemCount: chatRoomDocs.length,
              itemBuilder: (context, index) {
                print('chatRoomDocs');
                var details = chatRoomDocs[index].get();
                var docId = details.documentID;
//                    var val;
//                    Future<void> obtainVal () async {
//                      val = await ChatService().checkUserGroup(docId);
//                    }
//                    obtainVal();
                destination = chatListSnapshots.data[index].data['destination'];
                if(chatListSnapshots.data[index].data['users'].contains(user.uid.toString())){
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(docId)));
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: destination == 'New Delhi Railway Station' ? Icon(Icons.train) : Icon(Icons.flight_takeoff),
                      ),
                    ),
                    title: Text(destination,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    trailing: Text(DateFormat.yMMMd().format(chatListSnapshots.data[index].data['lastMessageAt'])),
                  );
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
