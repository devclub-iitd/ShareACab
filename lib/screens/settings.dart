import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareacab/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shareacab/services/auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  final AuthService _auth;
  Settings(this._auth);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      _darkTheme = prefs.getBool('darkMode') ?? true;
      _theme = prefs.getString('theme') ?? 'system';
      //print(_theme);
      _chosenAccentColor = prefs.getString('accentColor') ?? 'blue';
      for (var i = 0; i < colorList.length; i++) {
        if (_chosenAccentColor == colorList[i].value) {
          _selectedIndex = i;
          break;
        }
      }
      setState(() {});
    });
    super.initState();
  }

  var _darkTheme = true;
  Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
  var _theme;
  String _chosenAccentColor;
  int _selectedIndex;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var availableThemes = ['system', 'dark', 'light'];
  List<ThemeModel> themeList = [
    ThemeModel(label: 'Follow System', value: 'system'),
    ThemeModel(label: 'Light', value: 'light'),
    ThemeModel(label: 'Dark', value: 'dark'),
  ];
  List<ColorModel> colorList = [
    ColorModel(
      'Blue',
      Colors.blueAccent,
    ),
    ColorModel(
      'Cyan',
      Colors.cyanAccent,
    ),
    ColorModel(
      'Teal',
      Colors.tealAccent,
    ),
    ColorModel(
      'Purple',
      Colors.purpleAccent,
    ),
    ColorModel(
      'Red',
      Colors.redAccent,
    ),
    ColorModel(
      'Orange',
      Colors.deepOrangeAccent,
    ),
    ColorModel(
      'Yellow',
      Colors.yellowAccent,
    ),
    ColorModel(
      'Green',
      Colors.greenAccent,
    ),
  ];
  double w, h;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: <Widget>[
          user != null
              ? FlatButton.icon(
                  textColor: getVisibleColorOnPrimaryColor(context),
                  icon: Icon(FontAwesomeIcons.signOutAlt),
                  onPressed: () async {
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
                      Navigator.pop(context);
                    } catch (err) {
                      await pr.hide();
                      String errStr = err.message ?? err.toString();
                      final snackBar = SnackBar(content: Text(errStr), duration: Duration(seconds: 3));
                      scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                  },
                  label: Text('Logout'),
                )
              : FlatButton(onPressed: null, child: null)
        ],
      ),
      body: ListView(
        children: <Widget>[
          PreviewWidget(),
          ListTile(
            subtitle: Material(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'App Theme',
                      style: TextStyle(
                        fontSize: 18,
                        color: getVisibleColorOnScaffold(context),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    DropdownButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).accentColor,
                      ),
                      iconSize: 30,
                      style: TextStyle(color: getVisibleColorOnScaffold(context), fontSize: 15),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).accentColor,
                      ),
                      items: List.generate(themeList.length, (index) {
                        return DropdownMenuItem<String>(
                          value: themeList[index].value,
                          child: Text(
                            themeList[index].label,
                          ),
                        );
                      }),
                      onChanged: (String newValueSelected) {
                        newValueSelected != 'system'
                            ? setState(() {
                                _theme = newValueSelected;
                                _darkTheme = newValueSelected == 'dark' ? true : false;
                                newValueSelected == 'dark' ? onThemeChanged(true, themeNotifier) : onThemeChanged(false, themeNotifier);
                              })
                            : setState(() {
                                _theme = newValueSelected;
                                brightness == Brightness.dark ? _darkTheme = true : _darkTheme = false;
                                brightness == Brightness.dark ? onThemeChanged(true, themeNotifier) : onThemeChanged(false, themeNotifier);
                              });
                        setTheme(newValueSelected);
                      },
                      value: _theme,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: w * 0.03,
          ),
          ListTile(
            subtitle: Material(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Choose accent color',
                        style: TextStyle(
                          fontSize: 18,
                          color: getVisibleColorOnScaffold(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(colorList.length, (index) {
                            return SizedBox(
                              width: w * 0.20,
                              height: w * 0.10,
                              child: GestureDetector(
                                  child: AnimatedContainer(
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    child: _selectedIndex == index
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : null,
                                    decoration: BoxDecoration(
                                      color: colorList[index].color,
                                      borderRadius: BorderRadius.circular(_selectedIndex == index ? w * 0.05 : 0),
                                    ),
                                    duration: Duration(milliseconds: 300),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                    onColorChanged(colorList[index].value, colorList[index].color, themeNotifier);
                                  }),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              launch('https://github.com/devclub-iitd/ShareACab/issues/new?assignees=&labels=bug&template=bug_report.md&title=Issue+Title+%40AssignedUser');
            },
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
                padding: EdgeInsets.only(bottom: 100),
                icon: Icon(
                  Icons.bug_report,
                  size: 40.0,
                  color: getVisibleTextColorOnScaffold(context),
                ),
                onPressed: () {
                  launch('https://github.com/devclub-iitd/ShareACab/issues/new?assignees=&labels=bug&template=bug_report.md&title=Issue+Title+%40AssignedUser');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    themeNotifier.setTheme(getThemeDataForAccentColor(Theme.of(context).accentColor, value));
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  void onColorChanged(String value, Color accentColor, ThemeNotifier themeNotifier) async {
    themeNotifier.setTheme(getThemeDataForAccentColor(accentColor, _darkTheme));
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('accentColor', value);
  }

  void setTheme(String theme) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }
}

class ColorModel {
  String value;
  Color color;

  ColorModel(this.value, this.color);
}

class ThemeModel {
  String value, label;

  ThemeModel({this.value, this.label});
}

class PreviewWidget extends StatefulWidget {
  @override
  PreviewWidgetState createState() => PreviewWidgetState();
}

class PreviewWidgetState extends State<PreviewWidget> {
  bool switchValue = true, checkBoxValue = true;
  double sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Preview',
                style: TextStyle(
                  fontSize: 18,
                  color: getVisibleColorOnScaffold(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: switchValue,
                    onChanged: (_) {
                      setState(() {
                        switchValue = !switchValue;
                      });
                    }),
                Radio(
                  activeColor: Theme.of(context).accentColor,
                  groupValue: 0,
                  value: 0,
                  onChanged: (_) {},
                ),
                Checkbox(
                  activeColor: Theme.of(context).accentColor,
                  value: checkBoxValue,
                  onChanged: (_) {
                    setState(() {
                      checkBoxValue = !checkBoxValue;
                    });
                  },
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'BUTTON',
                    style: TextStyle(color: getVisibleColorOnAccentColor(context)),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            Slider(
              activeColor: Theme.of(context).accentColor,
              onChanged: (double newValue) {
                setState(() {
                  sliderValue = newValue;
                });
              },
              min: 0,
              max: 1,
              value: sliderValue,
            ),
          ],
        ),
      ),
    );
  }
}
