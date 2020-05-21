import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_components/chat_bubble.dart';
import 'package:shareacab/screens/chatscreen/chat_models/chat_message.dart';
import 'package:shareacab/screens/chatscreen/chat_models/send_menu_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareacab/screens/rootscreen.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPage createState() => _GroupPage();
}

class _GroupPage extends State<GroupPage> {
  List<ChatMessage> chatMessages = [
    ChatMessage(name: 'Vishal', message: 'Hi John', sending: false),
    ChatMessage(
        name: 'Vishal',
        message: 'Hope you are doin good',
        sending: false),
    ChatMessage(
        name: 'Vishal',
        message: "Hello Jane, I'm good what about you",
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: "I'm fine, Working from home",
        sending: false),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'Oh! Nice. Same here man',
        sending: true),

    ChatMessage(
        name: 'Vishal',
        message: '2nd last, Oh! Nice. Same here man',
        sending: true),
    ChatMessage(
        name: 'Vishal',
        message: 'last, I am God, Oh! Nice. Same here man',
        sending: true),
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              FlatButton.icon(
                textColor: getVisibleColorOnPrimaryColor(context),
                icon: Icon(FontAwesomeIcons.signOutAlt),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
                },
                label: Text('Leave Group'),
              ),
            ],
            expandedHeight: 200.0,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Demo Group'),
              background: Card(
                color: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
//                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 60, horizontal: 5),
                child: Container(
                  height: 150,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Container(
                                margin: EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                ),
                                child: Icon(
                                  Icons.train,
                                  color: Theme.of(context).accentColor,
                                  size: 30,
                                )
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 5,
                          top: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Start : May 21,2020 22:26',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'End : May 21, 2020 22:23',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverFillRemaining(
            child: Stack(children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80),
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
          )
        ],
      ),
    );
  }
}












//////////////
