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
  final CollectionReference userDetails = Firestore.instance.collection('userdetails');
  final CollectionReference groupdetails = Firestore.instance.collection('group');
  final CollectionReference requests = Firestore.instance.collection('requests');

  Future enterUserData({String name, String mobileNumber, String hostel, String sex}) async {
    return await userDetails.document(uid).setData({
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

  Future updateUserData({String name, String mobileNumber, String hostel, String sex}) async {
    return await userDetails.document(uid).updateData({
      'name': name,
      'mobileNumber': mobileNumber,
      'hostel': hostel,
      'sex': sex,
    });
  }

  // user list from snapshot
  List<Userdetails> _UserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Userdetails(
        uid: doc.documentID,
        name: doc.data['name'] ?? '',
        mobilenum: doc.data['mobileNumber'] ?? '',
        hostel: doc.data['hostel'] ?? '',
        sex: doc.data['sex'] ?? '',
        totalrides: doc.data['totalRides'] ?? 0,
        cancelledrides: doc.data['cancelledRides'] ?? 0,
        actualrating: doc.data['actualRating'] ?? 0,
        numberofratings: doc.data['numberOfRatings'] ?? 0,
      );
    }).toList();
  }

  // get users stream
  Stream<List<Userdetails>> get users {
    return userDetails.snapshots().map(_UserListFromSnapshot);
  }

  // get user doc
  Stream<DocumentSnapshot> get userData {
    return userDetails.document(uid).snapshots();
  }

  // add request details from user (will use in future versions)
  Future<void> addRequest(RequestDetails requestDetails) async {
    var user = await _auth.currentUser();

    // CODE FOR CONVERTING DATE TIME TO TIMESTAMP

    var temp = requestDetails.startTime;
    var starting = DateTime(requestDetails.startDate.year, requestDetails.startDate.month, requestDetails.startDate.day, temp.hour, temp.minute);
    var temp2 = requestDetails.endTime;
    var ending = DateTime(requestDetails.endDate.year, requestDetails.endDate.month, requestDetails.endDate.day, temp2.hour, temp2.minute);

    await requests.add({
      'user': user.uid.toString(),
      'destination': requestDetails.destination.toString(),
      'start': starting,
      'end': ending,
      'finaldestination': requestDetails.finalDestination.toString(),
      'maxpoolers': 0,
      'created': Timestamp.now(),
    });
  }

  // add group details
  Future<void> createTrip(RequestDetails requestDetails) async {
    var user = await _auth.currentUser();

    // CODE FOR CONVERTING DATE TIME TO TIMESTAMP

    var temp = requestDetails.startTime;
    var starting = DateTime(requestDetails.startDate.year, requestDetails.startDate.month, requestDetails.startDate.day, temp.hour, temp.minute);
    var temp2 = requestDetails.endTime;
    var ending = DateTime(requestDetails.endDate.year, requestDetails.endDate.month, requestDetails.endDate.day, temp2.hour, temp2.minute);

    //var timeStamp = Timestamp.fromDate(temp2);

    final reqRef = await requests.add({
      'user': user.uid.toString(),
      'destination': requestDetails.destination.toString(),
      'start': starting,
      'end': ending,
      'finaldestination': requestDetails.finalDestination.toString(),
      'maxpoolers': requestDetails.maxPoolers,
      'created': Timestamp.now(),
    });
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
    await ChatService().createChatRoom(docRef.documentID, user.uid.toString(), requestDetails.destination.toString());

    await userDetails.document(user.uid).updateData({
      'currentGroup': docRef.documentID,
      'currentReq': reqRef.documentID,
      'previous_groups': FieldValue.arrayUnion([docRef.documentID]),
    });

    var request = groupdetails.document(docRef.documentID).collection('users');
    await Firestore.instance.collection('userdetails').document(user.uid).get().then((value) async {
      if (value.exists) {
        await request.document(user.uid).setData({'name': value.data['name'], 'hostel': value.data['hostel'], 'sex': value.data['sex'], 'mobilenum': value.data['mobileNumber'], 'totalrides': value.data['totalRides'], 'cancelledrides': value.data['cancelledRides'], 'actualrating': value.data['actualRating'], 'numberofratings': value.data['numberOfRatings']});
      }
    });
  }

  // to update group details
  Future<void> updateGroup(String groupUID, DateTime SD, TimeOfDay ST, DateTime ED, TimeOfDay ET) async {
    var starting = DateTime(SD.year, SD.month, SD.day, ST.hour, ST.minute);
    var ending = DateTime(ED.year, ED.month, ED.day, ET.hour, ET.minute);

    await groupdetails.document(groupUID).setData({
      'start': starting,
      'end': ending,
    }, merge: true);
  }

  // exit a group
  Future<void> exitGroup() async {
    var user = await _auth.currentUser();
    var currentGrp;
    //var currentReq;
    var presentNum;
    var startTimeStamp;
    await Firestore.instance.collection('userdetails').document(user.uid).get().then((value) {
      currentGrp = value.data['currentGroup'];
      //currentReq = value.data['currentReq'];
    });
    await groupdetails.document(currentGrp).get().then((value) {
      presentNum = value.data['numberOfMembers'];
      startTimeStamp = value.data['start'];
    });

    if (startTimeStamp.compareTo(Timestamp.now()) > 0) {
      await userDetails.document(user.uid).updateData({
        'currentGroup': null,
        'currentReq': null,
        'previous_groups': FieldValue.arrayRemove([currentGrp]),
      });
      await groupdetails.document(currentGrp).updateData({
        'users': FieldValue.arrayRemove([user.uid]),
        'numberOfMembers': presentNum - 1,
      });
      await groupdetails.document(currentGrp).collection('users').document(user.uid).delete();
    } else {
      await userDetails.document(user.uid).updateData({
        'currentGroup': null,
        'currentReq': null,
      });
    }

    // delete group if last member and startTime is greater than present time.
    if (presentNum == 1 && startTimeStamp.compareTo(Timestamp.now()) > 0) {
      await groupdetails.document(currentGrp).delete();
    }

    //deleting user from chat group
    await ChatService().exitChatRoom(currentGrp);
  }

  // join a group from dashboard
  Future<void> joinGroup(String listuid) async {
    var user = await _auth.currentUser();
    var presentNum;
    await userDetails.document(user.uid).updateData({
      'previous_groups': FieldValue.arrayUnion([listuid]),
      'currentGroup': listuid,
    });
    await groupdetails.document(listuid).get().then((value) {
      presentNum = value.data['numberOfMembers'];
    });
    await groupdetails.document(listuid).updateData({
      // presently storing user.uid in users, need to change this later to the requestID when we start taking input of requests. (IMPORTANT)
      'users': FieldValue.arrayUnion([user.uid.toString()]),
      'numberOfMembers': presentNum + 1,
    });

    var request = groupdetails.document(listuid).collection('users');
    await Firestore.instance.collection('userdetails').document(user.uid).get().then((value) async {
      if (value.exists) {
        await request.document(user.uid).setData({
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
    //calling chat service to add the user to chatgroup also
    await ChatService().joinGroup(listuid);
  }

  Future<void> setToken(String token) async {
    final user = await _auth.currentUser();
    await userDetails.document(user.uid).updateData({'device_token': token});
  }
}
