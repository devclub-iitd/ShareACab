import 'package:flutter/material.dart';
import 'package:shareacab/screens/authenticate/forgotpass.dart';
import 'package:shareacab/screens/rootscreen.dart';
import 'package:shareacab/screens/wrapper.dart';
import 'package:shareacab/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  bottomAppBarColor: Colors.black,
  brightness: Brightness.dark,
  //backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
  scaffoldBackgroundColor: const Color(0xFF212121),
  inputDecorationTheme: const InputDecorationTheme(fillColor: Colors.black),
);

final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    bottomAppBarColor: Colors.white,
    primaryColor: Colors.grey[600],
    //primaryColor: Colors.white,
    brightness: Brightness.light,
    //backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    //accentColor: Colors.blueGrey[700],
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    scaffoldBackgroundColor: const Color(0xFFE5E5E5),
    //scaffoldBackgroundColor: const Color(0xFFFFFF),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.blueGrey[700]));

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);
  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

void main() {
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
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
        home: Wrapper(),
      ),
    );
  }
}
