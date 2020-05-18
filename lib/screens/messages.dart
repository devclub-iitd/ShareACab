import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';
import 'package:shareacab/screens/chatscreen/chat_modules/chat_page.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title:  Text('Messages'), iconButton: IconButton(icon: Icon(Icons.search), onPressed: (){
          showSearch(context: context, delegate: DataSearch());
        }),),

        body:  ChatPage()
    );
  }
}

class DataSearch extends SearchDelegate{

  final chats =[
    'Arpit Sir',
    'Vishal Sir',
    'Shashwat Sir',
    'Ishaan',
    'Kshitij'
  ];
  final recent =[
      'Shashwat Sir',
    'Kshitij'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = '';
      })
    ];

  }

  @override
  Widget buildLeading(BuildContext context) {
  return IconButton(icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: (){
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
    return ListView.builder(itemBuilder: (context, index)=>
      ListTile(leading: Icon(Icons.person),
      title: Text(suggestionList[index]),),
        itemCount: suggestionList.length,
    );

  }
  @override
  ThemeData appBarTheme(BuildContext context) {

    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Theme.of(context).primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: Theme.of(context).primaryColorBrightness,
      primaryTextTheme: Theme.of(context).primaryTextTheme,
    );
  }

}