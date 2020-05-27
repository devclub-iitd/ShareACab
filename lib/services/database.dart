import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/models/user.dart';

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
    await requests.add({
      'user': user.uid.toString(),
      'destination': requestDetails.destination.toString(),
      'startDate': requestDetails.startDate.toString(),
      'startTime': requestDetails.startTime.toString(),
      'endDate': requestDetails.endDate.toString(),
      'endTime': requestDetails.endTime.toString(),
      'finaldestination': requestDetails.finalDestination.toString(),
      'maxpoolers': 0,
      'joiningtime': null,
    });
  }

  // add group details
  Future<void> createTrip(RequestDetails requestDetails) async {
    var user = await _auth.currentUser();

    final reqRef = await requests.add({
      'user': user.uid.toString(),
      'destination': requestDetails.destination.toString(),
      'startDate': requestDetails.startDate.toString(),
      'startTime': requestDetails.startTime.toString(),
      'endDate': requestDetails.endDate.toString(),
      'endTime': requestDetails.endTime.toString(),
      'finaldestination': requestDetails.finalDestination.toString(),
      'maxpoolers': 0,
      'joiningtime': null,
    });

    final docRef = await groupdetails.add({
      'owner': user.uid.toString(),
      'users': FieldValue.arrayUnion([reqRef.documentID.toString()]),
      'destination': requestDetails.destination.toString(),
      'startDate': requestDetails.startDate.toString(),
      'startTime': requestDetails.startTime.toString(),
      'endDate': requestDetails.endDate.toString(),
      'endTime': requestDetails.endTime.toString(),
      'privacy': requestDetails.privacy.toString(),
      'maxpoolers': 0,
      'threshold': null,
    });

    await userDetails.document(user.uid).updateData({
      'currentGroup': docRef.documentID,
      'currentReq': reqRef.documentID,
    });

    // dont remove these comments yet, need to think about this later.

    // var request = groupdetails.document(docRef.documentID).collection('users');
    // await Firestore.instance.collection('userdetails').document(user.uid).get().then((value) async {
    //   if (value.exists) {
    //     await request.document(user.uid).setData({
    //       'name': value.data['name'],
    //       'hostel': value.data['hostel'],
    //       'sex': value.data['sex'],
    //       'mobilenum': value.data['mobileNumber'],
    //       'totalrides': value.data['totalRides'],
    //       'actualrating': value.data['actualRating'],
    //       'cancelledrides': value.data['cancelledRides'],
    //     });
    //   }
    // });
  }

  // exit a group
  Future<void> exitGroup() async {
    var user = await _auth.currentUser();
    var currentGrp;
    var currentReq;
    await Firestore.instance.collection('userdetails').document(user.uid).get().then((value) {
      currentGrp = value.data['currentGroup'];
      currentReq = value.data['currentReq'];
    });
    await groupdetails.document(currentGrp).updateData({
      'users': FieldValue.arrayRemove([currentReq.toString()]),
    });
    await userDetails.document(user.uid).updateData({
      'currentGroup': null,
      'currentReq': null,
    });
  }

  // join a group from dashboard
  Future<void> joinGroup(String listuid) async {
    var user = await _auth.currentUser();
    await userDetails.document(user.uid).updateData({
      'currentGroup': listuid,
    });
    await groupdetails.document(listuid).updateData({
      'users': FieldValue.arrayUnion([user.uid.toString()]),
    });
  }
}
