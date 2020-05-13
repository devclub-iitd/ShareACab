import 'package:shareacab/chatscreen/chat_modules/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage{
  String message;
  MessageType type;
  ChatMessage({@required this.message,@required this.type});
}