import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String destination;
  AppBarTitle(this.destination);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        destination == 'New Delhi Railway Station' || destination == 'Hazrat Nizamuddin Railway Station' ? Container(margin: EdgeInsets.only(right: 10), decoration: BoxDecoration(shape: BoxShape.circle), child: Icon(Icons.train)) : destination == 'Indira Gandhi International Airport' ? Container(margin: EdgeInsets.only(right: 10), decoration: BoxDecoration(shape: BoxShape.circle), child: Icon(Icons.flight_takeoff)) : Container(margin: EdgeInsets.only(right: 10), decoration: BoxDecoration(shape: BoxShape.circle), child: Icon(Icons.directions_bus)),
        Flexible(fit: FlexFit.loose, child: Text(destination)),
      ],
    );
  }
}
