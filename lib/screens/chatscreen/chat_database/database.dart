import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDatabase {
  final _auth = FirebaseAuth.instance;

  final CollectionReference chatLists = Firestore.instance.collection('chatroom');
  final CollectionReference group = Firestore.instance.collection('group');

  Future<void> createChatRoom(String docId, String uid, String destination) async {
    final chatList = await chatLists.document(docId).setData({
      'lastMessage': Timestamp.now(),
      'destination': destination,
      'users': FieldValue.arrayUnion([uid]),
    });
    var chat = chatLists.document(docId).collection('chats');
  }

  Future<void> exitChatRoom(String docId) async {
    var user = await _auth.currentUser();
    await chatLists.document(docId).updateData({
      'users': FieldValue.arrayRemove([user.uid.toString()])
    });
  }

  Future<void> joinGroup(String listuid) async {
    var user = await _auth.currentUser();
    await chatLists.document(listuid).updateData({
      'users': FieldValue.arrayUnion([user.uid.toString()]),
    });
  }
}
