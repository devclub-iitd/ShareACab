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

    await userDetails.document(user.uid).get().then((value) {
      name = value.data['name'];
    });
    await groupdetails.document(groupId).get().then((value) {
      admin = value.data['owner'];
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
      await userDetails.document(user.uid).updateData({
        'currentGroupJoinRequests': FieldValue.arrayUnion([groupId])
      });
    }
  }

//Creating a notification when a user joins the group (non-private groups)
  Future<void> joined(String name, String groupId) async {
    var allUsers;
    final user = await _auth.currentUser();

    await groupdetails.document(groupId).get().then((value) {
      allUsers = value.data['users'];
    });

    await userDetails.document(user.uid).updateData({
      'currentGroupJoinRequests': null,
    });

    for (var i = 0; i < allUsers.length; i++) {
      if (allUsers[i] != user.uid) {
        await userDetails.document(allUsers[i]).collection('Notifications').add({
          'from': user.uid,
          'senderName': name,
          'createdAt': Timestamp.now(),
          'purpose': 'joined the group',
          'response': null,
          'groupId': groupId,
        });
      }
    }
  }

//Updating response, adding user to the group, adding user to chatroom
  Future<void> response(bool response, String notifId) async {
    var user = await _auth.currentUser();
    var listuid;
    var uid;
    var name;
    var nameo;

    await userDetails.document(user.uid).collection('Notifications').document(notifId).updateData({
      'response': response,
    });

    if (response == true) {
      await userDetails.document(user.uid).collection('Notifications').document(notifId).get().then((value) {
        listuid = value.data['groupId'];
        uid = value.data['from'];
      });
      var presentNum;
      await userDetails.document(uid).updateData({
        'previous_groups': FieldValue.arrayUnion([listuid]),
        'currentGroup': listuid,
        'currentGroupJoinRequests': null,
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
          name = value.data['name'];
        }
      });

      var allUsers;
      await groupdetails.document(listuid).get().then((value) {
        allUsers = value.data['users'];
      });

      await userDetails.document(user.uid).get().then((value) {
        nameo = value.data['name'];
      });

      for (var i = 0; i < allUsers.length; i++) {
        if (allUsers[i] != uid && allUsers[i] != user.uid) {
          await userDetails.document(allUsers[i]).collection('Notifications').add({
            'from': uid,
            'senderName': name,
            'createdAt': Timestamp.now(),
            'purpose': 'joined the group',
            'response': null,
            'groupId': listuid,
          });
        } else if (allUsers[i] == uid) {
          await userDetails.document(uid).collection('Notifications').add({
            'from': user.uid,
            'senderName': nameo,
            'createdAt': Timestamp.now(),
            'purpose': 'Your request is accepted',
            'response': null,
            'groupId': listuid,
          });
        }
      }

      await chatLists.document(listuid).updateData({
        'users': FieldValue.arrayUnion([uid.toString()]),
      });
    } else if (response == false) {
      var name;
      await userDetails.document(user.uid).get().then((value) {
        name = value.data['name'];
      });

      await userDetails.document(user.uid).collection('Notifications').document(notifId).get().then((value) {
        listuid = value.data['groupId'];
        uid = value.data['from'];
      });

      await userDetails.document(uid).collection('Notifications').add({
        'from': user.uid,
        'senderName': name,
        'createdAt': Timestamp.now(),
        'purpose': 'Request to Join Declined',
        'response': null,
        'groupId': listuid,
      });
    }
  }

//Creating a notification for all users of a group when a user leaves that group
  Future<void> left(String name, String groupId) async {
    final user = await _auth.currentUser();
    var allUsers;
    await groupdetails.document(groupId).get().then((value) {
      allUsers = value.data['users'];
    });

    for (var i = 0; i < allUsers.length; i++) {
      if (user.uid != allUsers[i]) {
        await userDetails.document(allUsers[i]).collection('Notifications').add({
          'from': user.uid,
          'senderName': name,
          'createdAt': Timestamp.now(),
          'purpose': 'left the group',
          'response': null,
          'groupId': groupId,
        });
      }
    }
  }

  //Deleting a notification
  Future<void> remNotif(String notifId, var purpose, var uid, var response) async {
    final user = await _auth.currentUser();
    if (purpose == 'Request to Join' && response == false) {
      var name;
      var listuid;

      await userDetails.document(user.uid).get().then((value) {
        name = value.data['name'];
      });

      await userDetails.document(user.uid).collection('Notifications').document(notifId).get().then((value) {
        listuid = value.data['groupId'];
      });

      await userDetails.document(uid).collection('Notifications').add({
        'from': user.uid,
        'senderName': name,
        'createdAt': Timestamp.now(),
        'purpose': 'Request to Join Declined',
        'response': null,
        'groupId': listuid,
      });
    }
    await userDetails.document(user.uid).collection('Notifications').document(notifId).delete();
  }

  Future<void> removeAllNotif() async {
    final user = await _auth.currentUser();
    final notifs = await userDetails.document(user.uid).collection('Notifications').getDocuments();
    for (var i = 0; i < notifs.documents.length; i++) {
      if (notifs.documents[i].data['response'] == null && notifs.documents[i].data['purpose'] == 'Request to Join') {
        var name;
        var listuid;

        await userDetails.document(user.uid).get().then((value) {
          name = value.data['name'];
        });
        listuid = notifs.documents[i].documentID;
        await userDetails.document(notifs.documents[i].data['from']).collection('Notifications').add({
          'from': user.uid,
          'senderName': name,
          'createdAt': Timestamp.now(),
          'purpose': 'Request to Join Declined',
          'response': null,
          'groupId': listuid,
        });
      }
      await userDetails.document(user.uid).collection('Notifications').document(notifs.documents[i].documentID).delete();
    }
  }
}
