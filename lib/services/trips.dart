import 'package:flutter/material.dart';
import 'package:shareacab/models/requestdetails.dart';
import 'package:shareacab/services/database.dart';

class RequestService {
  Future<void> createTrip(RequestDetails requestDetails) async {
    await DatabaseService().createTrip(requestDetails);
  }

  Future<void> updateGroup(String groupUID, DateTime SD, TimeOfDay ST, DateTime ED, TimeOfDay ET, bool privacy) async {
    await DatabaseService().updateGroup(groupUID, SD, ST, ED, ET, privacy);
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

  Future<void> kickUser(String currentGrp, String uid) async {
    await DatabaseService().kickUser(currentGrp, uid);
  }
}
