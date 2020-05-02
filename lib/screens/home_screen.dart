import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/login/login.dart';
import 'package:jam/placeholder_widget.dart';
import 'package:jam/screens/InquiryForm.dart';
import 'package:jam/screens/home_ui_design.dart';
import 'package:jam/screens/myOrders.dart';
import 'package:jam/screens/myProfile.dart';
import 'package:jam/services.dart';
import 'package:jam/utils/preferences.dart';

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

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
          new IconButton(
            icon: new Icon(Icons.shopping_cart),
            onPressed: () {
              Preferences.removePreference("email");
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
        // this  will be set when a new tab is tapped
        currentIndex: _currentIndex,
        // new
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,

        items: [
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
//    HomeDesign(),
    HomeUIDesign(),
    NewPage(),
    Profile(),
    Orders()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
