import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/authenticate/authenticate.dart';
import 'rootscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'authenticate/verified_email_check.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either home or Authenticate widget

    final user = Provider.of<User>(context);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Container(
                  height: 200,
                  child: Image(image: AssetImage('assets/images/logo.png'))),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          );
        } else {
          if (user == null) {
            return Authenticate();
          } else if (user.emailVerified) {
            return RootScreen();
          } else {
            return VerificationCheck();
          }
        }
      },
    );
  }
}
