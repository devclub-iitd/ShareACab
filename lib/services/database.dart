import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDetails =
      Firestore.instance.collection('userdetails');

  // Future initializeUserData() async {
  //   return await userDetails.document(uid).setData({
  //     'isFilled': 0,
  //   });
  // }

  Future enterUserData(
      String name, String mobileNumber, String hostel, String sex) async {
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
}
