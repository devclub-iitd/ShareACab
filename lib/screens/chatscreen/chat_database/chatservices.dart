import './database.dart';

class ChatService {
  Future<void> createChatRoom(String docId, String uid, String destination) async {
    await ChatDatabase().createChatRoom(docId, uid, destination);
  }

  Future<bool> checkUserGroup(String docId) async {
    return await ChatDatabase().checkGroup(docId);
  }

  Future<void> exitChatRoom(String docId) async {
    await ChatDatabase().exitChatRoom(docId);
  }
  Future<void> joinGroup(String listuid) async {
    await ChatDatabase().joinGroup(listuid);
  }
}