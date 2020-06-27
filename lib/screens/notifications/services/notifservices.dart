import './database.dart';

class NotifServices {
  Future<void> createRequest(String groupId) async {
    await NotificationDatabase().createRequest(groupId);
  }

  Future<void> responseToRequest(bool response, String notifId) async {
    await NotificationDatabase().response(response, notifId);
  }

  Future<void> groupJoin(String name, String groupId) async {
    await NotificationDatabase().joined(name, groupId);
  }

  Future<void> leftGroup(String name, String groupId) async {
    await NotificationDatabase().left(name, groupId);
  }
}
