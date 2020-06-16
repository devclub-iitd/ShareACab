import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareacab/services/auth.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Settings extends StatefulWidget {
  final AuthService _auth;
  Settings(this._auth);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _darkTheme = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            ListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(fontSize: 28.0),
              ),
              contentPadding: EdgeInsets.all(26.0),
              subtitle: _darkTheme ? Text('Swipe to disable dark mode') : Text('Swipe to enable dark mode'),
              trailing: Transform.scale(
                scale: 1.6,
                child: Switch(
                  value: _darkTheme,
                  onChanged: (val) {
                    setState(() {
                      _darkTheme = val;
                    });
                    onThemeChanged(val, themeNotifier);
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 28.0),
              ),
              contentPadding: EdgeInsets.all(26.0),
              onTap: () async {
                ProgressDialog pr;
                pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                pr.style(
                  message: 'Logging out...',
                  backgroundColor: Theme.of(context).backgroundColor,
                  messageTextStyle: TextStyle(color: Theme.of(context).accentColor),
                );
                await pr.show();
                await Future.delayed(Duration(seconds: 1)); // sudden logout will show ProgressDialog for a very short time making it not very nice to see :p
                try {
                  await widget._auth.signOut();
                  await pr.hide();
                } catch (err) {
                  // show e.message
                  await pr.hide();
                  String errStr = err.message ?? err.toString();
                  final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                  scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
              trailing: Transform.scale(
                scale: 1.6,
              ),
            ),
          ],
        ));
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value) ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }
}
