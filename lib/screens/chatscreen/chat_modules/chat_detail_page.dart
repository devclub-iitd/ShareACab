import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_components/chat_bubble.dart';
import 'package:shareacab/screens/chatscreen/chat_components/chat_detail_page_appbar.dart';
import 'package:shareacab/screens/chatscreen/chat_models/chat_message.dart';
import 'package:shareacab/screens/chatscreen/chat_models/send_menu_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> chatMessages = [
    ChatMessage(name: "Vishal", message: 'Hi John', type: MessageType.Receiver),
    ChatMessage(name: "Vishal", message: 'Hope you are doin good', type: MessageType.Receiver),
    ChatMessage(name: "Vishal", message: "Hello Jane, I'm good what about you", type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: "I'm fine, Working from home", type: MessageType.Receiver),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: '2nd last, Oh! Nice. Same here man', type: MessageType.Sender),
    ChatMessage(name: "Vishal", message: 'last, I am God, Oh! Nice. Same here man', type: MessageType.Sender),
  ];

  List<SendMenuItems> menuItems = [
    SendMenuItems(text: 'Photos & Videos', icons: Icons.image, color: getMenuItemColor(0)),
    SendMenuItems(text: 'Document', icons: Icons.insert_drive_file, color: getMenuItemColor(1)),
    SendMenuItems(text: 'Audio', icons: Icons.music_note, color: getMenuItemColor(2)),
    SendMenuItems(text: 'Location', icons: Icons.location_on, color: getMenuItemColor(3)),
    SendMenuItems(text: 'Contact', icons: Icons.person, color: getMenuItemColor(4)),
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              ),
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
      appBar: ChatDetailPageAppBar(),
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80),
          child: SingleChildScrollView(
            child: ListView.builder(
              itemCount: chatMessages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  subtitle: ChatBubble(
                    chatMessage: chatMessages[index],
                  ),
                );
              },
            ),
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
                    decoration: InputDecoration(hintText: 'Type message...', hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary), border: InputBorder.none),
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
