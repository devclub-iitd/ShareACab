import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  List<Helper> helper = [
    Helper(thumbnail: Image(image: AssetImage('assets/images/create trip.jpg')), heading: 'Creating a Trip', description: 'To create a new trip, click the Floating Action button(plus sign) on the dashboard. Note that you should not be present in any existing group. Then fill the information and click CreateTrip', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/profile and edit.jpg')), heading: 'Your Profile/Edit Profile', description: 'You can view your profile by clicking on profile icon in navbar. Also, you can edit details of your profile by clicking on Edit Profile', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/ended trips.jpg')), heading: 'Ended Rides', description: 'You can view all your completed rides by clicking 2nd icon in navbar from left.', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/max no of poolers.jpg')), heading: 'Maximum number of Poolers', description: 'Max no of poolers = total no of members in the trip including the admin.', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/require permission to join trip.jpg')), heading: 'Require permission to join trip', description: 'Admin can check this option while creating/editing trip. On selecting this, the group becomes private and then the user will have to request the admin to join the trip. Admin can selectively then accept/decline each request.', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/accent color.jpg')), heading: 'Selecting accent color/theme', description: 'You can select various accent color/themes by clicking settings icon on top-right of dashboard', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/chat group.jpg')), heading: 'Chat groups', description: 'Once you join/create a trip, you also get into respective trip chat group. You can share your details with each other and chat about final timings.', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/notifications.jpg')), heading: 'Notifications', description: 'In Notifications screen, you will get notifications whenever someone joins/leaves your group and if admin you will also recieve requests from others where you can accept/decline their requests', isExpanded: false),
    Helper(thumbnail: Image(image: AssetImage('assets/images/filter.jpg')), heading: 'Filter the trips', description: 'You can filter the trips on the dashboard to better search an appropriate trip for you by clicking filter icon on dashboard.', isExpanded: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  helper[index].isExpanded = !helper[index].isExpanded;
                });
              },
              children: helper.map((Helper helper) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                        title: Text(
                      helper.heading,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ));
                  },
                  isExpanded: helper.isExpanded,
                  body: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Text(
                          helper.description,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        height: helper.heading == 'Maximum number of Poolers' || helper.heading == 'Require permission to join trip' ? MediaQuery.of(context).size.height*0.1 : MediaQuery.of(context).size.height*0.6,
                        margin: EdgeInsets.all(13),
                        child: helper.thumbnail
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class Helper {
  bool isExpanded;
  Image thumbnail;
  String heading;
  String description;

  Helper({this.heading, this.thumbnail, this.description, this.isExpanded});
}
