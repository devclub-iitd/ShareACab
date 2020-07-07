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

    final user = Provider.of<FirebaseUser>(context);

    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (user == null) {
            return Authenticate();
          } else if (user.isEmailVerified) {
            //print('Verified');
            return RootScreen();
          } else {
            //print('Not verified');
            return VerificationCheck();
          }
        }
      },
    );
  }
}
