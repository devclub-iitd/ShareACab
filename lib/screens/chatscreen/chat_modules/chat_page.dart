import 'package:shareacab/screens/chatscreen/chat_components/chat.dart';
import 'package:shareacab/screens/chatscreen/chat_models/chat_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        text: 'Arpit Sir',
        secondaryText: 'Chill hai',
        image: 'assets/images/avatar.jpg',
        time: 'Now'),
    ChatUsers(
        text: 'Kshitij',
        secondaryText: 'Cool',
        image: 'assets/images/avatar.jpg',
        time: 'Yesterday'),
    ChatUsers(
        text: 'Shashwat Sir',
        secondaryText: 'Itne saare issues!!',
        image: 'assets/images/avatar.jpg',
        time: '69 May'),
    ChatUsers(
        text: 'Deepanshu',
        secondaryText: 'Okkk',
        image: 'assets/images/avatar.jpg',
        time: '69 May'),
    ChatUsers(
        text: 'Ishaan',
        secondaryText: 'Ok',
        image: 'assets/images/avatar.jpg',
        time: '11 May'),
    ChatUsers(
        text: 'Random',
        secondaryText: 'Lorem Ipsum',
        image: 'assets/images/avatar.jpg',
        time: '0 May'),
    ChatUsers(
        text: 'Random2',
        secondaryText: 'random text',
        image: 'assets/images/avatar.jpg',
        time: '0 May'),
    ChatUsers(
        text: 'Random3',
        secondaryText: 'random text again',
        image: 'assets/images/avatar.jpg',
        time: '30 Feb'),
    ChatUsers(
        text: 'Random3',
        secondaryText: 'random text again',
        image: 'assets/images/avatar.jpg',
        time: '30 Feb'),
    ChatUsers(
        text: 'Random3',
        secondaryText: 'random text again',
        image: 'assets/images/avatar.jpg',
        time: '30 Feb'),
    ChatUsers(
        text: 'Random3',
        secondaryText: 'random text again',
        image: 'assets/images/avatar.jpg',
        time: '30 Feb'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: chatUsers.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              return ChatUsersList(
                text: chatUsers[index].text,
                secondaryText: chatUsers[index].secondaryText,
                image: chatUsers[index].image,
                time: chatUsers[index].time,
                isMessageRead: (index == 0 || index == 3) ? true : false,
              );
            },
          ),
        ]),
      ),
    );
  }
}
