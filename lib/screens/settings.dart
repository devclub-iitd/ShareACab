import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _darkTheme = true;

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
            ListTile(
              title: Text(
                'Bug Report',
                style: TextStyle(fontSize: 28.0),
              ),
              contentPadding: EdgeInsets.all(26.0),
              subtitle: Text('Found a bug, report here:'),
              trailing: Tooltip(
                message: 'Report Bug',
                verticalOffset: -60,
                child: IconButton(
                  icon: Icon(
                    Icons.bug_report,
                    size: 40.0,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    launch('https://github.com/devclub-iitd/ShareACab/issues/new?assignees=&labels=bug&template=bug_report.md&title=Issue+Title+%40AssignedUser');
                  },
                ),
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
