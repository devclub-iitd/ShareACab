import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  List<Helper> helper;
  @override
  void initState() {
    super.initState();

    // Generate example items
    helper = <Helper>[];
    for (var i = 0; i < 1; i++) {
      helper.add(
        Helper(thumbnail: Image(image: AssetImage('assets/sampleHelpImage.jpeg')), heading: 'Creating a Trip', description: 'To create a new trip, click the Floating Action button(plus sign) on the dashboard. Note that you should not be present in any existing group. Then fill the information and click CreateTrip', isExpanded: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ));
                  },
                  isExpanded: helper.isExpanded,
                  body: Column(
                    children: <Widget>[
                      Text(
                        helper.description,
                        style: TextStyle(fontSize: 20),
                      ),
                      helper.thumbnail,
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
