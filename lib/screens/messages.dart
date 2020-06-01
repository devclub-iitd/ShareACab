import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_widgets/chat_users_list.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ChatUsersList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate {
  final chats = ['Arpit Sir', 'Vishal Sir', 'Shashwat Sir', 'Ishaan', 'Kshitij'];
  final recent = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recent : chats;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.person),
          title: Text(suggestionList[index]),
        ),
        itemCount: suggestionList.length,
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    return getSearchAppBarTheme(context);
  }
}
