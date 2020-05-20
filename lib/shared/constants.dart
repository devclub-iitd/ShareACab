import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
  //fillColor: Theme.of(context).inputDecorationTheme.fillColor,
  //fillColor: Theme.of(context).accentColor,
  filled: true,
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);
