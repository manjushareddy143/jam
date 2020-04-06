
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  BackButtonAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed:
                () => Navigator.pop(context),
          ),
          title: Text(title, style: TextStyle(
              color: Colors.white
          )),
          actionsIconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.0);
}