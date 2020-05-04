import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/user.dart';
import 'package:jam/placeholder_widget.dart';
import 'package:jam/screens/InquiryForm.dart';
import 'package:jam/screens/home_ui_design.dart';
import 'package:jam/screens/myOrders.dart';
import 'package:jam/screens/user_profile.dart';
import 'package:jam/services.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';

class HomeScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: HomePage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

final key = new GlobalKey<ProfileUIPageState>();

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _formKey = GlobalKey<FormState>();






  @override
  void initState() {
    super.initState();
  }

  var editIcon = Icons.mode_edit;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_currentIndex == 0)
              Text(
                'Your Location',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            if (_currentIndex == 0)
              Container(
                child: new GestureDetector(
                  //tapping to go the corresponding view linked with it using navigator
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewPage()));
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        'B Ring Road, Doha, Qatar',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.teal,
                      )
                    ],
                  ),
                ),
              ),
            if (_currentIndex == 1)
              setHeader("Categories"),
            if (_currentIndex == 2)
              setHeader("My Account"),
            if (_currentIndex == 3)
              setHeader("Orders"),

          ],
        ),
        actions: <Widget>[
          if (_currentIndex == 0)
          new IconButton(
            icon: new Icon(Icons.shopping_cart),
            onPressed: () {
//              Preferences.removePreference("user");
//              Navigator.pushReplacement(context,
//                  MaterialPageRoute(builder: (context) => UserLogin()));
            },
          ),
          if (_currentIndex == 2)
          new IconButton(
            icon: new Icon(editIcon),
            onPressed: () {
              setState(() {
                if(editIcon == Icons.mode_edit) {
                  editIcon = Icons.done;
                } else {
                  editIcon = Icons.mode_edit;
                }
                key.currentState.validateform();
              });

            },
          ),
          if (_currentIndex == 2)
          new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () {
              Preferences.removePreference("user");
              Preferences.removePreference("profile");

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserLogin()));
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
      ),
      // Middle Body
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,

        items:[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: new Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
              ),
              title: new Text("Categories")),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity), title: new Text("My Account")),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.train,
            ),
            title: new Text("Orders"),
          ),
        ],
      ),
    );
  }

  Widget setHeader(String title) {
    return Container(
      child: Center(
          child: Text(title,
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center)),
    );
  }


  final List<Widget> _children = [
    HomeUIDesign(),
    NewPage(),
//    Profile(),
    ProfileUIPage(key: key),
    OrderUIPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
