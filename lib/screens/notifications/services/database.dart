import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationDatabase {
  final _auth = FirebaseAuth.instance;
  final CollectionReference groupdetails = Firestore.instance.collection('group');
  final CollectionReference userDetails = Firestore.instance.collection('userdetails');
  final CollectionReference chatLists = Firestore.instance.collection('chatroom');

//Request created to join a group
  Future<void> createRequest(String groupId) async {
    var user = await _auth.currentUser();
    var name;
    var admin;

    await userDetails.document(user.uid).get().then((data) {
      name = data['name'];
    });
    await groupdetails.document(groupId).get().then((value) {
      admin = value['admin'];
    });
    if (admin != null) {
      await userDetails.document(admin).collection('Notifications').add({
        'from': user.uid,
        'senderName': name,
        'createdAt': Timestamp.now(),
        'purpose': 'Request to Join',
        'response': null,
        'groupId': groupId,
      });
    }
  }

//Updating response, adding user to the group, adding user to chatroom
  Future<void> response(bool response, String notifId) async {
    var user = await _auth.currentUser();
    var listuid;
    var uid;
    await userDetails.document(user.uid).collection('Notifications').document(notifId).updateData({
      'response': response,
    });
    if (response == true) {
      await userDetails.document(user.uid).collection('Notifications').document(notifId).get().then((value) {
        listuid = value['groupId'];
        uid = value['from'];
      });
      var presentNum;
      await userDetails.document(uid).updateData({
        'previous_groups': FieldValue.arrayUnion([listuid]),
        'currentGroup': listuid,
      });
      await groupdetails.document(listuid).get().then((value) {
        presentNum = value.data['numberOfMembers'];
      });
      await groupdetails.document(listuid).updateData({
        'users': FieldValue.arrayUnion([uid.toString()]),
        'numberOfMembers': presentNum + 1,
      });

      var request = groupdetails.document(listuid).collection('users');
      await Firestore.instance.collection('userdetails').document(uid).get().then((value) async {
        if (value.exists) {
          await request.document(uid).setData({
            'name': value.data['name'],
            'hostel': value.data['hostel'],
            'sex': value.data['sex'],
            'mobilenum': value.data['mobileNumber'],
            'totalrides': value.data['totalRides'],
            'actualrating': value.data['actualRating'],
            'cancelledrides': value.data['cancelledRides'],
            'numberofratings': value.data['numberOfRatings'],
          });
        }
      });
      await chatLists.document(listuid).updateData({
        'users': FieldValue.arrayUnion([uid.toString()]),
      });
    }
  }

//Creating a notification when a user joins the group
  Future<void> joined(String name, String uid, String groupId) async {
    var allUsers;

    await groupdetails.document(groupId).get().then((value) {
      allUsers = value['users'];
    });

    for (var i = 0; allUsers.length; i++) {
      await userDetails.document(allUsers[i]).collection('Notifications').add({
        'from': uid,
        'senderName': name,
        'createdAt': Timestamp.now(),
        'purpose': '${name} joined the group',
        'response': null,
        'groupId': groupId,
      });
    }
  }

//Creating a notification for all users of a group when a user leaves that group
  Future<void> left(String name, String uid, String groupId) async {
    var allUsers;

    await groupdetails.document(groupId).get().then((value) {
      allUsers = value['users'];
    });

    for (var i = 0; allUsers.length; i++) {
      await userDetails.document(allUsers[i]).collection('Notifications').add({
        'from': uid,
        'senderName': name,
        'createdAt': Timestamp.now(),
        'purpose': '${name} left the group',
        'response': null,
        'groupId': groupId,
      });
    }
  }
}
