//import 'package:flutter/material.dart';
//import 'package:jam/api/detail.dart';
//import 'package:jam/placeholder_widget.dart';
//import 'package:jam/services.dart';
//
//class HomeStart extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _HomeStart();
//  }
//}
//class _HomeStart extends State<HomeStart> {
//  int _currentIndex = 0;
//  final List<Widget> _children = [
//    HomeDesign(),
//    PlaceholderWidget(Colors.white),
//    PlaceholderWidget(Colors.deepOrange),
//    PlaceholderWidget(Colors.green)
//  ];
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.white70,
//        title:
//          Text('1100 +  AC Services',
//            textAlign: TextAlign.left,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.black,  ), ),
//      ),
//      body: DetailPage(),
//      //_children[_currentIndex],
//      bottomNavigationBar: BottomNavigationBar(
//
//        onTap: onTabTapped,// this will be set when a new tab is tapped
//        currentIndex: _currentIndex, // new
//        selectedItemColor: Colors.teal,
//        unselectedItemColor: Colors.grey,
//        backgroundColor: Colors.white,
//        iconSize: 30,
//        type: BottomNavigationBarType.fixed,
//
//        items: [ BottomNavigationBarItem(
//            icon: Icon(
//              Icons.home,),
//            title: new Text("Home")
//        ),
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.category,),
//              title: new Text("Categories")
//          ),
//          BottomNavigationBarItem(
//              icon: Icon(
//                  Icons.perm_identity),
//              title: new Text("My Account")
//          ),
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.train,),
//              title: new Text("Orders")
//
//          ),
//        ],
//      ),
//    );
//  }
//  void onTabTapped(int index) {
//    setState(() {
//      _currentIndex = index;
//    });
//  }
//}
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Page")),
      body: Center(
          child: Text("New Page",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
    );
  }
}
//
