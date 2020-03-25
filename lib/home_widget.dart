import 'package:flutter/material.dart';
import 'package:jam/placeholder_widget.dart';
import 'package:jam/services.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}
class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    CollapsingList(),
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Bottom Bar'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        onTap: onTabTapped,// this will be set when a new tab is tapped
        currentIndex: _currentIndex, // new
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,

        items: [ BottomNavigationBarItem(
            icon: Icon(
              Icons.home,),
            title: new Text("Home")
        ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.category,),
              title: new Text("Categories")
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.perm_identity),
              title: new Text("My Account")
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.train,),
              title: new Text("Orders")

          ),
        ],
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}