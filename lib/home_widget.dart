import 'package:flutter/material.dart';
import 'package:jam/api/detail.dart';
import 'package:jam/login/login.dart';
import 'package:jam/placeholder_widget.dart';
import 'package:jam/services.dart';
import 'package:jam/utils/preferences.dart';

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
        backgroundColor: Colors.white,

        title:Column( crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
        Text('Your Location',
           textAlign: TextAlign.left,style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey,  ), ),
          Container( child: new GestureDetector( //tapping to go the corresponding view linked with it using navigator
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NewPage()));
            },child: Row(children: <Widget>[Text('B Ring Road, Doha, Qatar',style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400 , color: Colors.black),),
            Icon(Icons.arrow_drop_down, color: Colors.teal,)],),),)

            ],),

          actions: <Widget>[
         new IconButton(icon: new Icon(Icons.shopping_cart),
      onPressed: (){
           Preferences.removePreference("email");
           Navigator.pushReplacement(context, MaterialPageRoute(
               builder: (context) => UserLogin()));
      },),

          ],

         iconTheme: IconThemeData(
         color: Colors.grey,
         ),






      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        onTap: onTabTapped,// this  will be set when a new tab is tapped
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
}class NewPage extends StatelessWidget {
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

