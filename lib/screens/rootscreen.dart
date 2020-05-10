import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Row(children: <Widget>[Text("ShareA"), Text("Cab", style: TextStyle(fontWeight: FontWeight.w900),)],),
      ),
      body: Center(child: Text("ShareACab")),
    );
  }
}
