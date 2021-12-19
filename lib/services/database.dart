import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/models/user.dart';
import 'package:shareacab/screens/chatscreen/chat_database/chatservices.dart';

class DatabaseService {
  final String uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference<Map<String, dynamic>> userDetails = FirebaseFirestore.instance.collection('userdetails');
  final CollectionReference<Map<String, dynamic>> groupdetails = FirebaseFirestore.instance.collection('group');
  final CollectionReference<Map<String, dynamic>> requests = FirebaseFirestore.instance.collection('requests');

  // Enter user data (W=1, R=0)
  Future enterUserData({String name, String mobileNumber, String hostel, String sex}) async {
    return await userDetails.doc(uid).set({
      'name': name,
      'mobileNumber': mobileNumber,
      'hostel': hostel,
      'sex': sex,
      'totalRides': 0,
      'cancelledRides': 0,
      'actualRating': 0,
      'numberOfRatings': 0,
    });
  }

  // Update user data (W=1/2,R=1)
  Future updateUserData({String name, String mobileNumber, String hostel, String sex}) async {
    var currentGrp;
    var user = _auth.currentUser;
    await FirebaseFirestore.instance.collection('userdetails').doc(user.uid).get().then((value) {
      currentGrp = value.data()['currentGroup'];
    });
    await userDetails.doc(uid).update({
      'name': name,
      'mobileNumber': mobileNumber,
      'hostel': hostel,
      'sex': sex,
    });
    if (currentGrp != null) {
      await groupdetails.doc(currentGrp).collection('users').doc(user.uid).set({
        'name': name,
        'mobilenum': mobileNumber,
        'hostel': hostel,
        'sex': sex,
      }, SetOptions(merge: true));
    }
  }

  // user list from snapshot
  List<Userdetails> _UserListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return Userdetails(
        uid: doc.id,
        name: doc.data()['name'] ?? '',
        mobilenum: doc.data()['mobileNumber'] ?? '',
        hostel: doc.data()['hostel'] ?? '',
        sex: doc.data()['sex'] ?? '',
        totalrides: doc.data()['totalRides'] ?? 0,
        cancelledrides: doc.data()['cancelledRides'] ?? 0,
        actualrating: doc.data()['actualRating'] ?? 0,
        numberofratings: doc.data()['numberOfRatings'] ?? 0,
      );
    }).toList();
  }

  // get users stream
  Stream<List<Userdetails>> get users {
    return userDetails.snapshots().map(_UserListFromSnapshot);
  }

  // get user doc
  Stream<DocumentSnapshot<Map<String, dynamic>>> get userData {
    return userDetails.doc(uid).snapshots();
  }

  // add group details (W = 4, R = 0)
  Future<void> createTrip(RequestDetails requestDetails) async {
    var user = _auth.currentUser;

    // CODE FOR CONVERTING DATE TIME TO TIMESTAMP

    var temp = requestDetails.startTime;
    var starting = DateTime(requestDetails.startDate.year, requestDetails.startDate.month, requestDetails.startDate.day, temp.hour, temp.minute);
    var temp2 = requestDetails.endTime;
    var ending = DateTime(requestDetails.endDate.year, requestDetails.endDate.month, requestDetails.endDate.day, temp2.hour, temp2.minute);

    final docRef = await groupdetails.add({
      'owner': user.uid.toString(),
      'users': FieldValue.arrayUnion([user.uid]),
      'destination': requestDetails.destination.toString(),
      'start': starting,
      'end': ending,
      'privacy': requestDetails.privacy.toString(),
      'maxpoolers': requestDetails.maxPoolers,
      'numberOfMembers': 1,
      'threshold': null,
      'created': Timestamp.now(),
    });

    //adding user to group chat
    await ChatService().createChatRoom(docRef.id, user.uid.toString(), requestDetails.destination.toString());

    await userDetails.doc(user.uid).update({
      'currentGroup': docRef.id,
    });

    var request = groupdetails.doc(docRef.id).collection('users');
    await FirebaseFirestore.instance.collection('userdetails').doc(user.uid).get().then((value) async {
      if (value.exists) {
        await request.doc(user.uid).set({'name': value.data()['name'], 'hostel': value.data()['hostel'], 'sex': value.data()['sex'], 'mobilenum': value.data()['mobileNumber'], 'totalrides': value.data()['totalRides'], 'cancelledrides': value.data()['cancelledRides'], 'actualrating': value.data()['actualRating'], 'numberofratings': value.data()['numberOfRatings']});
      }
    });
  }

  // to update group details (W=1, R=0)
  Future<void> updateGroup(String groupUID, DateTime SD, TimeOfDay ST, DateTime ED, TimeOfDay ET, bool privacy, int maxPoolers) async {
    var starting = DateTime(SD.year, SD.month, SD.day, ST.hour, ST.minute);
    var ending = DateTime(ED.year, ED.month, ED.day, ET.hour, ET.minute);

    await groupdetails.doc(groupUID).set({
      'start': starting,
      'end': ending,
      'privacy': privacy.toString(),
      'maxpoolers': maxPoolers,
    }, SetOptions(merge: true));
  }

  // exit a group (W=4/5, R =3/4)
  Future<void> exitGroup() async {
    var user = _auth.currentUser;
    var currentGrp;
    var presentNum;
    var startTimeStamp;
    var totalRides;
    var cancelledRides;
    var owner;
    await FirebaseFirestore.instance.collection('userdetails').doc(user.uid).get().then((value) {
      currentGrp = value.data()['currentGroup'];
      totalRides = value.data()['totalRides'];
      cancelledRides = value.data()['cancelledRides'];
    });
    await groupdetails.doc(currentGrp).get().then((value) {
      presentNum = value.data()['numberOfMembers'];
      startTimeStamp = value.data()['start'];
      owner = value.data()['owner'];
    });
    // if user leaves early, then :
    if (startTimeStamp.compareTo(Timestamp.now()) > 0) {
      await userDetails.doc(user.uid).update({
        'currentGroup': null,
        'cancelledRides': cancelledRides + 1,
      });
      await groupdetails.doc(currentGrp).update({
        'users': FieldValue.arrayRemove([user.uid]),
        'numberOfMembers': presentNum - 1,
      });
      if (owner == user.uid && presentNum > 1) {
        var newowner;
        await groupdetails.doc(currentGrp).get().then((value) {
          newowner = value.data()['users'][0];
        });
        await groupdetails.doc(currentGrp).update({
          'owner': newowner,
        });
      }
      await groupdetails.doc(currentGrp).collection('users').doc(user.uid).delete();
      //deleting user from chat group
      await ChatService().exitChatRoom(currentGrp);
    }
    // if user leaves after ride completion:
    else {
      await userDetails.doc(user.uid).update({
        'currentGroup': null,
        'totalRides': totalRides + 1,
        'previous_groups': FieldValue.arrayUnion([currentGrp]),
      });
    }

    // delete group if last member and startTime is greater than present time.
    if (presentNum == 1 && startTimeStamp.compareTo(Timestamp.now()) > 0) {
      await groupdetails.doc(currentGrp).delete();
    }
  }

  // join a group from dashboard (W=4,R=2)
  Future<void> joinGroup(String listuid) async {
    var user = _auth.currentUser;
    var presentNum;
    await userDetails.doc(user.uid).update({
      'currentGroup': listuid,
    });
    await groupdetails.doc(listuid).get().then((value) {
      presentNum = value.data()['numberOfMembers'];
    });
    await groupdetails.doc(listuid).update({
      'users': FieldValue.arrayUnion([user.uid.toString()]),
      'numberOfMembers': presentNum + 1,
    });

    var request = groupdetails.doc(listuid).collection('users');
    await FirebaseFirestore.instance.collection('userdetails').doc(user.uid).get().then((value) async {
      if (value.exists) {
        await request.doc(user.uid).set({
          'name': value.data()['name'],
          'hostel': value.data()['hostel'],
          'sex': value.data()['sex'],
          'mobilenum': value.data()['mobileNumber'],
          'totalrides': value.data()['totalRides'],
          'actualrating': value.data()['actualRating'],
          'cancelledrides': value.data()['cancelledRides'],
          'numberofratings': value.data()['numberOfRatings'],
        });
      }
    });
    //calling chat service to add the user to chatgroup also
    await ChatService().joinGroup(listuid);
  }

  // set device token (W=1,R=0)
  Future<void> setToken(String token) async {
    final user = _auth.currentUser;
    await userDetails.doc(user.uid).update({'device_token': token});
  }

  // Function for kicking a user (ADMIN ONLY) (W=4,R=1)
  Future<void> kickUser(String currentGrp, String uid) async {
    await groupdetails.doc(currentGrp).collection('users').doc(uid).delete();
    var presentNum;
    await groupdetails.doc(currentGrp).get().then((value) {
      presentNum = value.data()['numberOfMembers'];
    });
    await userDetails.doc(uid).update({
      'currentGroup': null,
    });
    await groupdetails.doc(currentGrp).update({
      'users': FieldValue.arrayRemove([uid]),
      'numberOfMembers': presentNum - 1,
    });
    await ChatService().kickedChatRoom(currentGrp, uid);
  }
}
