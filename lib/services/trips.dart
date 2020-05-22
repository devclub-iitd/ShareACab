import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/services/database.dart';

class RequestService {
  Future<void> createTrip(RequestDetails requestDetails) async {
    await DatabaseService().createTrip(requestDetails);
  }
}
