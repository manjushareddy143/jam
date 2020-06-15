import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/user.dart';
import 'package:jam/placeholder_widget.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/InquiryForm.dart';
import 'package:jam/screens/home_ui_design.dart';
import 'package:jam/screens/customer_order_list.dart';
import 'package:jam/screens/user_profile.dart';
import 'package:jam/services.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/login/masterSignupScreen.dart';
import 'package:jam/screens/category_screen.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/screens/vendor_order_list.dart';

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
    // TODO: implement initState
    super.initState();
//    print(globals.currentUser.roles[0].slug);
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
                AppLocalizations.of(context).translate('home_txt_location'),
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
                        color: Configurations.themColor,
                      )
                    ],
                  ),
                ),
              ),
            if (_currentIndex == 1)
              setHeader(AppLocalizations.of(context).translate('tab_categories')),
            if (_currentIndex == 2)
              setHeader(AppLocalizations.of(context).translate('tab_account')),
            if (_currentIndex == 3)
              setHeader(AppLocalizations.of(context).translate('tab_orders')),

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
              globals.isCustomer = true;
              if(globals.currentUser.social_signin == "facebook") {
                logoutFacebook();
              } else if(globals.currentUser.social_signin == "gmail") {
//                signOutGoogle();
              }

              globals.currentUser = null;
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
      body: (globals.guest == true) ? _guestChildren[_currentIndex] : _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        // new
        selectedItemColor: Configurations.themColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,

        items:[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: new Text(AppLocalizations.of(context).translate('tab_home'))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
              ),
              title: new Text(AppLocalizations.of(context).translate('tab_categories'))),
          if(globals.guest == false)
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity), title: new Text(AppLocalizations.of(context).translate('tab_account'))),
          if(globals.guest == false)
          BottomNavigationBarItem(
            icon: Icon(
              Icons.train,
            ),
            title: new Text(AppLocalizations.of(context).translate('tab_orders')),
          ),
        ],
      ),
    );
  }

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> logoutFacebook() async {
    await facebookSignIn.logOut();
//    _showMessage('Logged out.');
  }


    Widget setHeader(String title) {
    return Container(
      child: Center(
          child: Text(title,
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center)),
    );
  }
//  final GoogleSignIn googleSignIn = GoogleSignIn();
//  void signOutGoogle() async{
//    await googleSignIn.signOut();
//    print("User Sign Out");
//  }


  final List<Widget> _guestChildren = [

    HomeUIDesign(),
    CategoryScreen(),



  ];


  final List<Widget> _children = [

    HomeUIDesign(),
    CategoryScreen(),
    if(globals.guest == false)
    ProfileUIPage(key: key),
    if(globals.guest == false)
    if(globals.currentUser.roles[0].slug == 'customer')
    OrderUIPage(url: Configurations.BOOKING_URL, isCustomer: true,),
    if(globals.guest == false)
    if(globals.currentUser.roles[0].slug == 'provider')
      VendorOrderUIPage(),

  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
