import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          ],
        ));
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value) ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }
}
