import 'package:flutter/cupertino.dart';

// this is temporary and only for design, actual ChatMessage is different
class ChatMessage {
  String name;
  String message;
  bool  sending;

  ChatMessage({@required this.name, @required this.message, @required this.sending});
}
