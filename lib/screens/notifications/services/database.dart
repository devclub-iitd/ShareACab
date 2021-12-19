import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationDatabase {
  final _auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> groupdetails = FirebaseFirestore.instance.collection('group');
  final CollectionReference<Map<String, dynamic>> userDetails = FirebaseFirestore.instance.collection('userdetails');
  final CollectionReference<Map<String, dynamic>> chatLists = FirebaseFirestore.instance.collection('chatroom');

//Request created to join a group
  Future<void> createRequest(String groupId) async {
    var user = _auth.currentUser;
    var name;
    var admin;

    await userDetails.doc(user.uid).get().then((value) {
      name = value.data()['name'];
    });
    await groupdetails.doc(groupId).get().then((value) {
      admin = value.data()['owner'];
    });
    if (admin != null) {
      await userDetails.doc(admin).collection('Notifications').add({
        'from': user.uid,
        'senderName': name,
        'createdAt': Timestamp.now(),
        'purpose': 'Request to Join',
        'response': null,
        'groupId': groupId,
      });
      await userDetails.doc(user.uid).update({
        'currentGroupJoinRequests': FieldValue.arrayUnion([groupId])
      });
    }
  }

//Creating a notification when a user joins the group (non-private groups)
  Future<void> joined(String name, String groupId) async {
    var allUsers;
    final user = _auth.currentUser;

    await groupdetails.doc(groupId).get().then((value) {
      allUsers = value.data()['users'];
    });
    await userDetails.doc(user.uid).update({
      'currentGroupJoinRequests': null,
    });

    for (var i = 0; i < allUsers.length; i++) {
      if (allUsers[i] != user.uid) {
        await userDetails.doc(allUsers[i]).collection('Notifications').add({
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
    var user = _auth.currentUser;
    var listuid;
    var uid;
    var name;
    var nameo;

    await userDetails.doc(user.uid).collection('Notifications').doc(notifId).update({
      'response': response,
    });

    if (response == true) {
      await userDetails.doc(user.uid).collection('Notifications').doc(notifId).get().then((value) {
        listuid = value.data()['groupId'];
        uid = value.data()['from'];
      });
      var presentNum;
      var maxPoolers;
      await userDetails.doc(uid).update({
        // 'previous_groups': FieldValue.arrayUnion([listuid]),
        'currentGroup': listuid,
        'currentGroupJoinRequests': null,
      });
      await groupdetails.doc(listuid).get().then((value) {
        presentNum = value.data()['numberOfMembers'];
        maxPoolers = value.data()['maxpoolers'];
      });
      if (presentNum == maxPoolers) {
        await groupdetails.doc(listuid).update({
          'users': FieldValue.arrayUnion([uid.toString()]),
          'numberOfMembers': presentNum + 1,
          'maxpoolers': maxPoolers + 1,
        });
      } else {
        await groupdetails.doc(listuid).update({
          'users': FieldValue.arrayUnion([uid.toString()]),
          'numberOfMembers': presentNum + 1,
        });
      }

      var request = groupdetails.doc(listuid).collection('users');
      await FirebaseFirestore.instance.collection('userdetails').doc(uid).get().then((value) async {
        if (value.exists) {
          await request.doc(uid).set({
            'name': value.data()['name'],
            'hostel': value.data()['hostel'],
            'sex': value.data()['sex'],
            'mobilenum': value.data()['mobileNumber'],
            'totalrides': value.data()['totalRides'],
            'actualrating': value.data()['actualRating'],
            'cancelledrides': value.data()['cancelledRides'],
            'numberofratings': value.data()['numberOfRatings'],
          });
          name = value.data()['name'];
        }
      });

      var allUsers;
      await groupdetails.doc(listuid).get().then((value) {
        allUsers = value.data()['users'];
      });

      await userDetails.doc(user.uid).get().then((value) {
        nameo = value.data()['name'];
      });

      for (var i = 0; i < allUsers.length; i++) {
        if (allUsers[i] != uid && allUsers[i] != user.uid) {
          await userDetails.doc(allUsers[i]).collection('Notifications').add({
            'from': uid,
            'senderName': name,
            'createdAt': Timestamp.now(),
            'purpose': 'joined the group',
            'response': null,
            'groupId': listuid,
          });
        } else if (allUsers[i] == uid) {
          await userDetails.doc(uid).collection('Notifications').add({
            'from': user.uid,
            'senderName': nameo,
            'createdAt': Timestamp.now(),
            'purpose': 'Your request is accepted',
            'response': null,
            'groupId': listuid,
          });
        }
      }

      await chatLists.doc(listuid).update({
        'users': FieldValue.arrayUnion([uid.toString()]),
      });
    } else if (response == false) {
      var name;
      await userDetails.doc(user.uid).get().then((value) {
        name = value.data()['name'];
      });

      await userDetails.doc(user.uid).collection('Notifications').doc(notifId).get().then((value) {
        listuid = value.data()['groupId'];
        uid = value.data()['from'];
      });

      await userDetails.doc(uid).collection('Notifications').add({
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
    final user = _auth.currentUser;
    var allUsers;
    await groupdetails.doc(groupId).get().then((value) {
      allUsers = value.data()['users'];
    });

    for (var i = 0; i < allUsers.length; i++) {
      if (user.uid != allUsers[i]) {
        await userDetails.doc(allUsers[i]).collection('Notifications').add({
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
    final user = _auth.currentUser;
    if (purpose == 'Request to Join' && response == false) {
      var name;
      var listuid;

      await userDetails.doc(user.uid).get().then((value) {
        name = value.data()['name'];
      });

      await userDetails.doc(user.uid).collection('Notifications').doc(notifId).get().then((value) {
        listuid = value.data()['groupId'];
      });

      await userDetails.doc(uid).collection('Notifications').add({
        'from': user.uid,
        'senderName': name,
        'createdAt': Timestamp.now(),
        'purpose': 'Request to Join Declined',
        'response': null,
        'groupId': listuid,
      });
    }
    await userDetails.doc(user.uid).collection('Notifications').doc(notifId).delete();
  }

  Future<void> removeAllNotif() async {
    final user = _auth.currentUser;
    final notifs = await userDetails.doc(user.uid).collection('Notifications').get();
    for (var i = 0; i < notifs.docs.length; i++) {
      if (notifs.docs[i].data()['response'] == null && notifs.docs[i].data()['purpose'] == 'Request to Join') {
        var name;
        var listuid;

        await userDetails.doc(user.uid).get().then((value) {
          name = value.data()['name'];
        });
        listuid = notifs.docs[i].id;
        await userDetails.doc(notifs.docs[i].data()['from']).collection('Notifications').add({
          'from': user.uid,
          'senderName': name,
          'createdAt': Timestamp.now(),
          'purpose': 'Request to Join Declined',
          'response': null,
          'groupId': listuid,
        });
      }
      await userDetails.doc(user.uid).collection('Notifications').doc(notifs.docs[i].id).delete();
    }
  }
}
