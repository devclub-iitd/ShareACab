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

Color chatBubbleBackgroundColorReceiver = Colors
    .lightBlue; // Needs to be changed acc to combinations, requires creativity
Color chatBubbleBackgroundColorSender = Colors
    .lightGreen; // Needs to be changed acc to combinations, requires creativity
Color chatSearchBackgroundColor = Colors.white;

Color getVisibleColorOnPrimaryColor(BuildContext context) {
  return Colors.white;
}

Color getVisibleColorOnAccentColor(BuildContext context) {
  var color = Theme.of(context).colorScheme.secondary;
  var list = [
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.yellowAccent,
    Colors.greenAccent
  ];
  if (list.contains(color)) {
    return Colors.black;
  }
  return Colors.white;
}

Color getVisibleTextColorOnScaffold(BuildContext context) {
  var color = Theme.of(context).colorScheme.secondary;
  var theme;
  if (Theme.of(context).brightness == Brightness.dark) {
    theme = 'dark';
  } else {
    theme = 'light';
  }
  var list = [
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.yellowAccent,
    Colors.greenAccent
  ];
  if (list.contains(color) && theme == 'light') {
    return Colors.black;
  } else {
    return color;
  }
}

Color getVisibleIconColorOnScaffold(BuildContext context) {
  var color = Theme.of(context).colorScheme.secondary;
  var theme;
  if (Theme.of(context).brightness == Brightness.dark) {
    theme = 'dark';
  } else {
    theme = 'light';
  }
  var list = [
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.yellowAccent,
    Colors.greenAccent
  ];
  if (list.contains(color) && theme == 'light') {
    if (color == Colors.cyanAccent) {
      return Colors.cyan;
    }
    if (color == Colors.greenAccent) {
      return Colors.green;
    }
    if (color == Colors.tealAccent) {
      return Colors.teal;
    }
    if (color == Colors.yellowAccent) {
      return Colors.amber;
    }
    return color;
  } else {
    return color;
  }
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
  bool _darkModeOn = true;
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
    if (prefs.getBool('darkMode') == null ||
        prefs.getString('accentColor') == null) {
      prefs.setBool('darkMode', true);
      prefs.setString('accentColor', 'Blue');
    }
  });
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    var _theme = prefs.getString('theme') ?? 'system';
    var chosenAccentColor = prefs.getString('accentColor') ?? 'Blue';
    if (_theme == 'system') {
      var brightness = WidgetsBinding.instance.window.platformBrightness;
      if (brightness == null) {
        darkModeOn = true;
      } else {
        if (brightness == Brightness.dark) {
          darkModeOn = true;
        } else {
          darkModeOn = false;
        }
      }
    }
    if (chosenAccentColor == 'Blue') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.blueAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Cyan') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.cyanAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Teal') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.tealAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Purple') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.purpleAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Red') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.redAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Orange') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.deepOrangeAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Yellow') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.yellowAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else if (chosenAccentColor == 'Green') {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.greenAccent, darkModeOn),
              darkModeOn),
          child: MyApp(),
        ),
      );
    } else {
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(
              getThemeDataForAccentColor(Colors.blue, darkModeOn), darkModeOn),
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
    return StreamProvider<User>.value(
      initialData: FirebaseAuth.instance.currentUser,
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
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
      ),
    );
  }
}

ThemeData getThemeDataForAccentColor(Color accentColor, bool darkTheme) {
  //print('dark theme is $darkTheme');
  return darkTheme
      ? ThemeData(
          bottomAppBarColor: const Color(0xFF212121),
          primaryColor: const Color(0xFF212121),
          primaryColorDark: Colors.black,
          brightness: Brightness.dark,
          backgroundColor: const Color(0xFF212121),
          dividerColor: Colors.black12,
          scaffoldBackgroundColor: Colors.black,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.white,
              selectionColor: Colors.blue,
              selectionHandleColor: Colors.blue),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(secondary: accentColor),
        )
      : ThemeData(
          appBarTheme: AppBarTheme(color: Colors.black),
          bottomAppBarColor: Color(0xFF212121),
          primaryColor: Colors.grey[600],
          primaryColorDark: Colors.grey[800],
          brightness: Brightness.light,
          backgroundColor: const Color(0xFFE5E5E5),
          dividerColor: Colors.white54,
          scaffoldBackgroundColor: const Color(0xFFE5E5E5),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: Colors.blueGrey[700],
            selectionHandleColor: Colors.blueGrey[700],
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(secondary: accentColor),
        );
}
