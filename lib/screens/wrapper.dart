import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/screens/authenticate/authenticate.dart';
import 'package:shareacab/models/user.dart';
import 'rootscreen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either home or Authenticate widget

    final user = Provider.of<User>(context);
    // print(user);
    // return Authenticate();

    if (user == null) {
      return Authenticate();
    } else {
      return RootScreen();
    }
  }
}
