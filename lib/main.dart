import 'package:flutter/material.dart';
import 'package:shareacab/screens/authenticate/forgotpass.dart';
import 'package:shareacab/screens/rootscreen.dart';
import 'package:shareacab/screens/wrapper.dart';
import 'package:shareacab/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
      initialRoute: '/wrapper',
        routes: {
          '/wrapper': (context) => Wrapper(),
          '/accounts/forgotpass': (context) => ForgotPass(),
          '/rootscreen': (context) => RootScreen(),
        },
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
        home: Wrapper(),
      ),
    );
  }
}
