import 'package:flutter/material.dart';
import 'screens/rootscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share A Cab',
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey[600], //  Color(0xFFF3F5F7)
        accentColor: Colors.blueGrey[700],
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: RootScreen(),
    );
  }
}
