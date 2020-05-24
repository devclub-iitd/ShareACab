import 'package:flutter/material.dart';
import 'package:shareacab/screens/groupscreen/groupchat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/rootscreen.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int i = 0;
  List<Members> members = [
    Members(name: 'Shashwat', isAdmin: true, hostel: 'Girnar',),
    Members(name: 'Vishal', isAdmin: false, hostel: 'Aravali'),
    Members(name: 'Arpit', isAdmin: false, hostel: 'Vindy'),
    Members(name: 'Deepanshu', isAdmin: false, hostel: 'Udaigiri'),
    Members(name: 'Ishaan', isAdmin: false, hostel: 'Jwala'),
    Members(name: 'Kshitij', isAdmin: false, hostel: 'Jwala'),
    Members(name: 'Kshitij', isAdmin: false, hostel: 'Jwala'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Group'),
        actions: <Widget>[
          FlatButton.icon(
            textColor: getVisibleColorOnPrimaryColor(context),
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RootScreen()));
            },
            label: Text('Leave Group'),
          )
        ],
      ),
      body: Container(
        height: 1000,
        child: SingleChildScrollView(
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
                        )),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'New Delhi Railway Station',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                      'Start : May 20,2020 22:26',
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
              Padding(
                padding: EdgeInsets.only(
                  bottom: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Open Till : May 19, 2020 22:23',
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
                      'Pool Capacity: 6/6',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
                SingleChildScrollView(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ListTile(
                            title: Text(members[index].name),
                            subtitle: Text(
                                'Hostel: ${members[index].hostel}\n Start : Start : May 21,2020 22:26\n  End : May 24,2020 22:26\n Any other info that we might add in future'),
                            trailing: members[index].isAdmin
                                ? FaIcon(FontAwesomeIcons.crown)
                                : null,
                            isThreeLine: true,
                          ),
                        ),
                      ],
                    );
                  },
                )),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupChatPage()));
        },
        child: Stack(
          alignment: Alignment(-10, -10),
          children: <Widget>[
            Icon(Icons.chat),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 10.0,
              child: Text(
                '0',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Members {
  String name;
  bool isAdmin;
  String hostel;
  Members({@required this.name, @required this.isAdmin, @required this.hostel});
}
