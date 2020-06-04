import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/services/database.dart';

class RequestService {
  Future<void> createTrip(RequestDetails requestDetails) async {
    await DatabaseService().createTrip(requestDetails);
  }

  Future<void> exitGroup() async {
    await DatabaseService().exitGroup();
  }

  Future<void> joinGroup(String listuid) async {
    await DatabaseService().joinGroup(listuid);
  }

  Future<void> setDeviceToken(String token) async {
    await DatabaseService().setToken(token);
  }
}
