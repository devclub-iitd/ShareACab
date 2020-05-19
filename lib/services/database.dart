import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shareacab/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDetails =
      Firestore.instance.collection('userdetails');

  Future enterUserData(
      {String name, String mobileNumber, String hostel, String sex}) async {
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
}
