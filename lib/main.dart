import 'package:flutter/material.dart';
import 'package:shareacab/screens/authenticate/forgotpass.dart';
import 'package:shareacab/screens/dashboard.dart';
import 'package:shareacab/screens/edituserdetails.dart';
import 'package:shareacab/screens/rootscreen.dart';
import 'package:shareacab/screens/createtrip.dart';
import 'package:shareacab/screens/wrapper.dart';
import 'package:shareacab/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareacab/screens/chatscreen/chat_screen.dart';

Color userIsOnline(BuildContext context) => Colors.green;

Color sendMessageIcon(BuildContext context) => Colors.green;

Color requestAccepted(BuildContext context) => Colors.green;
Color requestRejected(BuildContext context) => Colors.red;
Color requestPending(BuildContext context) => Colors.yellow;

Color warning(BuildContext context) => Colors.yellow;
Color warningHeading(BuildContext context) => Colors.red;

Color getVisibleColorOnScaffold(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

ThemeData getSearchAppBarTheme(BuildContext context) {
  final theme = Theme.of(context);
  assert(theme != null);
  if (theme.brightness == Brightness.light) {
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  } else {
    return theme.copyWith(
      primaryColor: Colors.black,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      primaryColorBrightness: Brightness.dark,
      primaryTextTheme: theme.textTheme,
    );
  }
}

Color chatBubbleBackgroundColorReceiver = Colors.lightBlue; // Needs to be changed acc to combinations, requires creativity
Color chatBubbleBackgroundColorSender = Colors.lightGreen; // Needs to be changed acc to combinations, requires creativity
Color chatSearchBackgroundColor = Colors.white;

Color getVisibleColorOnPrimaryColor(BuildContext context) {
  return Colors.white;
}

Color getVisibleColorOnAccentColor(BuildContext context) {
  var color = Theme.of(context).accentColor;
  if (color == Colors.yellow || color == Colors.orange) {
    return Colors.black;
  }
  return Colors.white;
}

Color getBorderColorForInputFields(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  bool _darkModeOn;
  ThemeNotifier(this._themeData, this._darkModeOn);

  ThemeData getTheme() => _themeData;
  bool darkModeIsOn() => _darkModeOn;

  void setTheme(ThemeData themeData) async {
    await SharedPreferences.getInstance().then((prefs) {
      _darkModeOn = !prefs.getBool('darkMode');
      //print('darkModeOn is $_darkModeOn');
    });
    _themeData = themeData;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    var _theme = prefs.getString('theme') ?? 'system';
    var chosenAccentColor = prefs.getString('accentColor');
    if (_theme == 'system') {
      var brightness = WidgetsBinding.instance.window.platformBrightness;
      if (brightness == Brightness.dark) {
        darkModeOn = true;
      } else {
        darkModeOn = false;
      }
    }
    if (chosenAccentColor == 'Blue') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(getThemeDataForAccentColor(Colors.blue, darkModeOn), darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Purple') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(getThemeDataForAccentColor(Colors.purple, darkModeOn), darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Red') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(getThemeDataForAccentColor(Colors.red, darkModeOn), darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Orange') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(getThemeDataForAccentColor(Colors.orange, darkModeOn), darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Yellow') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(getThemeDataForAccentColor(Colors.yellow, darkModeOn), darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Green') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(getThemeDataForAccentColor(Colors.green, darkModeOn), darkModeOn),
          child: MyApp(),
        ),
      );
    } else {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(getThemeDataForAccentColor(Colors.blue, darkModeOn), darkModeOn),
          child: MyApp(),
        ),
      );
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/wrapper',
        routes: {
          '/wrapper': (context) => Wrapper(),
          '/accounts/forgotpass': (context) => ForgotPass(),
          '/rootscreen': (context) => RootScreen(),
          '/edituserdetails': (context) => EditForm(),
          '/dashboard': (context) => Dashboard(),
          CreateTrip.routeName: (context) => CreateTrip(),
          ChatScreen.routeName: (context) => ChatScreen(' '),
//          GroupDetails.routeName : (context) => GroupDetails(' '),
        },
        title: 'Share A Cab',
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
        // theme: ThemeData(
        //   primaryColor: Colors.grey[600], //  Color(0xFFF3F5F7)
        //   accentColor: Colors.blueGrey[700],
        //   scaffoldBackgroundColor: Color(0xFFF3F5F7),
        // ),
      ),
    );
  }
}

// class MyAppBar extends AppBar {
//   MyAppBar({Key key, Widget title, Icon icon})
//       : super(
//             key: key,
//             title: title,
//             actions: <Widget>[IconButton(icon: icon, onPressed: () {})]);
// }

ThemeData getThemeDataForAccentColor(Color accentColor, bool darkTheme) {
  //print('dark theme is $darkTheme');
  return darkTheme
      ? ThemeData(
          primarySwatch: Colors.grey,
          bottomAppBarColor: const Color(0xFF212121),
          primaryColor: const Color(0xFF212121),
          primaryColorDark: Colors.black,
          brightness: Brightness.dark,
          backgroundColor: const Color(0xFF212121),
          accentColor: accentColor,
          accentIconTheme: IconThemeData(color: Colors.black),
          dividerColor: Colors.black12,
          scaffoldBackgroundColor: Colors.black,
          textSelectionHandleColor: Colors.blue,
          cursorColor: Colors.white,
          textSelectionColor: Colors.blue,
          // inputDecorationTheme: const InputDecorationTheme(fillColor: Colors.black),
        )
      : ThemeData(
          appBarTheme: AppBarTheme(color: accentColor),
          primarySwatch: Colors.grey,
          bottomAppBarColor: Colors.white,
          primaryColor: Colors.grey[600],
          primaryColorDark: Colors.grey[800],
          //primaryColor: Colors.white,
          brightness: Brightness.light,
          backgroundColor: const Color(0xFFE5E5E5),
          accentColor: accentColor,
          //accentColor: Colors.blueGrey[700],
          accentIconTheme: IconThemeData(color: Colors.white),
          dividerColor: Colors.white54,
          scaffoldBackgroundColor: const Color(0xFFE5E5E5),
          textSelectionHandleColor: Colors.blueGrey[700],
          cursorColor: Colors.black,
          textSelectionColor: Colors.blueGrey[700],

          //scaffoldBackgroundColor: const Color(0xFFFFFF)
        );
}
