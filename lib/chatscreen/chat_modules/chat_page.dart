import 'package:shareacab/chatscreen/chat_components/chat.dart';
import 'package:shareacab/chatscreen/chat_models/chat_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(text: "Arpit Sir", secondaryText: "Chill hai", image: "images/userImage1.jpeg", time: "Now"),
    ChatUsers(text: "Kshitij", secondaryText: "Cool", image: "images/userImage1.jpeg", time: "Yesterday"),
    ChatUsers(text: "Shashwat Sir", secondaryText: "Itne saare issues!!", image: "images/userImage1.jpeg", time: "69 May"),
    ChatUsers(text: "Deepanshu ", secondaryText: "Okkk", image: "images/userImage1.jpeg", time: "69 May"),
    ChatUsers(text: "Ishaan", secondaryText: "Ok", image: "images/userImage1.jpeg", time: "11 May"),
    ChatUsers(text: "Random", secondaryText: "Lorem Ipsum", image: "images/userImage1.jpeg", time: "0 May"),
    ChatUsers(text: "Random2", secondaryText: "random text", image: "images/userImage1.jpeg", time: "0 May"),
    ChatUsers(text: "Random3", secondaryText: "random text again", image: "images/userImage1.jpeg", time: "30 Feb"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ChatUsersList(
                  text: chatUsers[index].text,
                  secondaryText: chatUsers[index].secondaryText,
                  image: chatUsers[index].image,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3)?true:false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}