import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String destination;
  AppBarTitle(this.destination);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        MediaQuery.of(context).size.width > 360
            ? destination == 'New Delhi Railway Station'
                ? Container(
          margin: EdgeInsets.only(right : 10),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Icon(Icons.train))
                : Container(
            margin: EdgeInsets.only(right:10),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Icon(Icons.flight_takeoff))
            : null,
        Flexible(fit: FlexFit.loose, child: Text(destination == 'Indira Gandhi International Airport' ? 'IGT Airport' : 'ND Railway Station')),
      ],
    );
  }
}
