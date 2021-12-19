import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDatabase {
  final _auth = FirebaseAuth.instance;

  final CollectionReference chatLists =
      FirebaseFirestore.instance.collection('chatroom');
  final CollectionReference group =
      FirebaseFirestore.instance.collection('group');

  //adding user to chat room
  Future<void> createChatRoom(
      String docId, String uid, String destination) async {
    var user = _auth.currentUser;
    await chatLists.doc(docId).set({
      'lastMessage': Timestamp.now(),
      'destination': destination,
      'users': FieldValue.arrayUnion([user.uid]),
    });
    chatLists.doc(docId).collection('chats');
  }

  //deleting user from group chat
  Future<void> exitChatRoom(String docId) async {
    var user = _auth.currentUser;
    await chatLists.doc(docId).update({
      'users': FieldValue.arrayRemove([user.uid.toString()])
    });
  }

  //adding user to chat group
  Future<void> joinGroup(String listuid) async {
    var user = _auth.currentUser;
    await chatLists.doc(listuid).update({
      'users': FieldValue.arrayUnion([user.uid.toString()]),
    });
  }

  // kicking a user from chat group
  Future<void> kickedChatRoom(String groupID, String userID) async {
    await chatLists.doc(groupID).update({
      'users': FieldValue.arrayRemove([userID.toString()])
    });
  }
}
