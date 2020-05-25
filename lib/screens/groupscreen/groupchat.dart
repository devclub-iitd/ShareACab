import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_components/chat_bubble.dart';
import 'package:shareacab/screens/chatscreen/chat_models/chat_message.dart';
import 'package:shareacab/screens/chatscreen/chat_models/send_menu_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  @override
  _GroupChatPage createState() => _GroupChatPage();
}

class _GroupChatPage extends State<GroupChatPage> {
  List<ChatMessage> chatMessages = [
    ChatMessage(name: 'Vishal', message: 'Hi John', sending: false),
    ChatMessage(
        name: 'Vishal', message: 'Hope you are doin good', sending: false),
    ChatMessage(
        name: 'Vishal',
        message: "Hello Jane, I'm good what about you",
        sending: true),
    ChatMessage(
        name: 'Vishal', message: "I'm fine, Working from home", sending: false),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal',
        message: '2nd last, Oh! Nice. Same here man', sending: true),
    ChatMessage(
        name: 'Vishal', message: 'last, I am God, Oh! Nice. Same here man', sending: true),
  ];

  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: 'Photos & Videos',
        icons: Icons.image,
        color: getMenuItemColor(0)),
    SendMenuItems(
        text: 'Document',
        icons: Icons.insert_drive_file,
        color: getMenuItemColor(1)),
    SendMenuItems(
        text: 'Audio', icons: Icons.music_note, color: getMenuItemColor(2)),
    SendMenuItems(
        text: 'Location', icons: Icons.location_on, color: getMenuItemColor(3)),
    SendMenuItems(
        text: 'Contact', icons: Icons.person, color: getMenuItemColor(4)),
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 1000,
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          onTap: () {},
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Group'),
      ),
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80),
          child: ListView.builder(
            itemCount: chatMessages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                children: <Widget>[
                  SenderBubble(
                    chatMessage: chatMessages[index],
                  ),
                  Text('\n'),
                  ChatBubble(
                    chatMessage: chatMessages[index],
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 16, bottom: 10),
            height: 80,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showModal();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 21,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Type message...',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.only(right: 30, bottom: 50),
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
              backgroundColor: sendMessageIcon(context),
              elevation: 0,
            ),
          ),
        )
      ]),
    );
  }
}


// ignore: must_be_immutable
class SenderBubble extends StatefulWidget {
  ChatMessage chatMessage;

  SenderBubble({@required this.chatMessage});
  @override
  _SenderBubbleState createState() => _SenderBubbleState();
}

class _SenderBubbleState extends State<SenderBubble> {
  @override
  Widget build(BuildContext context) {
    return !widget.chatMessage.sending ?Container(
        margin:  const EdgeInsets.only(left: 10.0, ),
        child: Text(
          widget.chatMessage.name,
        )):Container();
  }
}


