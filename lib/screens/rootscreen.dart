import 'package:flutter/material.dart';
import 'package:shareacab/screens/dashboard.dart';
import 'messages.dart';
import 'profile/userprofile.dart';
import 'notifications/notifications.dart';
import 'requests/myrequests.dart';
import 'package:shareacab/services/auth.dart';
import 'package:shareacab/shared/loading.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';
  Widget choose;

  // String _appBarTitle = '';
  bool justLoggedin = true;
  bool isHome = true;

  int _selectedPage = 0;
  List<Widget> buildBottomNavBarItems() {
    return [
      Tooltip(
        message: 'Dashboard',
        child: Icon(
          Icons.home,
          size: 20.0,
          color: _selectedPage == 0 ? Theme.of(context).colorScheme.secondary : Colors.white,
        ),
      ),
      Tooltip(
        message: 'My Requests',
        child: Icon(
          Icons.format_list_bulleted,
          size: 20.0,
          color: _selectedPage == 1 ? Theme.of(context).colorScheme.secondary : Colors.white,
        ),
      ),
      Tooltip(
        message: 'Messages',
        child: Icon(
          _selectedPage == 2 ? Icons.chat_bubble : Icons.chat_bubble_outline,
          size: 20.0,
          color: _selectedPage == 2 ? Theme.of(context).colorScheme.secondary : Colors.white,
        ),
      ),
      Tooltip(
        message: 'Notifications',
        child: Icon(
          _selectedPage == 3 ? Icons.notifications : Icons.notifications_none,
          size: 20.0,
          color: _selectedPage == 3 ? Theme.of(context).colorScheme.secondary : Colors.white,
        ),
      ),
      Tooltip(
        message: 'Profile',
        child: Icon(
          _selectedPage == 4 ? Icons.person : Icons.person_outline,
          size: 20.0,
          color: _selectedPage == 4 ? Theme.of(context).colorScheme.secondary : Colors.white,
        ),
      ),
    ];
  }

  List<Widget> pagelist = <Widget>[];
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: pagelist,
    );
  }

  @override
  void initState() {
    pagelist.add(Dashboard());
    pagelist.add(MyRequests());
    pagelist.add(Messages());
    pagelist.add(Notifications());
    pagelist.add(MyProfile(_auth));
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _selectedPage = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            body: buildPageView(),
            bottomNavigationBar: CurvedNavigationBar(
              color: Color(0xFF212121),
              //color: Theme.of(context).bottomAppBarColor,
              backgroundColor: Colors.black,
              //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              animationDuration: Duration(milliseconds: 200),
              index: _selectedPage,
              onTap: (index) {
                bottomTapped(index);
              },
              items: buildBottomNavBarItems(),
            ),
          );
  }
}
