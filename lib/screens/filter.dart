import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
      ),
      body: Center(
        child: Text("Filter screen", style: TextStyle(fontSize: 25.0),),
      ),
    );
  }
}
