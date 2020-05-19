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
    // print(user);
    // return Authenticate();
//
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
}
