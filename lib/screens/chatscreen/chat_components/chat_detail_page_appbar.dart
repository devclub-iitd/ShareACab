import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shareacab/main.dart';

class ChatDetailPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor,),
              ),
              SizedBox(width: 2,),
              CircleAvatar(
                backgroundImage: AssetImage('images/userImage1.jpeg'),
                maxRadius: 20,
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Arpit Sir',
                      style: TextStyle(fontWeight: FontWeight.w600),),
                    SizedBox(height: 6,),
                    Text('Online',
                      style: TextStyle(color: userIsOnline(context), fontSize: 12),),
                  ],
                ),
              ),
              Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}