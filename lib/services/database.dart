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
  final CollectionReference requestdetails = Firestore.instance.collection('requestdetails');

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

  // add group details
  Future<void> createTrip(RequestDetails requestDetails) async {
    final docRef = await requestdetails.add({
      'destination': requestDetails.destination.toString(),
      'startDate': requestDetails.startDate.toString(),
      'startTime': requestDetails.startTime.toString(),
      'endDate': requestDetails.endDate.toString(),
      'endTime': requestDetails.endTime.toString(),
      'privacy': requestDetails.privacy.toString(),
    });
    var userUID = await _auth.currentUser();
    await userDetails.document(userUID.uid).updateData({
      'currentGroup': docRef.documentID,
    });
  }
}
