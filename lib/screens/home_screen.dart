import 'dart:convert';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

//import 'package:google_sign_in/google_sign_in.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/user.dart';
import 'package:jam/placeholder_widget.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/InquiryForm.dart';
import 'package:jam/screens/home_ui_design.dart';
import 'package:jam/screens/customer_order_list.dart';
import 'package:jam/screens/service_selection.dart';
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
  Future<bool> onBackPressed() {
    return showDialog(
      context: globals.context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('header')),
        content: Text(AppLocalizations.of(context).translate('exit_prompt')),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).translate('no')),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            /*Navigator.of(context).pop(true)*/
            child: Text(AppLocalizations.of(context).translate('yes')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: HomePage(title: 'Home'),
      ),
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
    editIcon = Icons.mode_edit;
    _currentIndex = 0;
    isShowAppBar = true;
//    print(globals.currentUser.roles[0].slug);
  }

  var editIcon = Icons.mode_edit;
  bool isShowAppBar = false;

  Widget build(BuildContext context) {
    globals.context = context;
//    printLog(globals.addressLocation);
//    printLog(globals.newAddress);
//    printLog(globals.addressChange);
    return new Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: isShowAppBar
            ? new AppBar(
                backgroundColor: Colors.deepOrange,
                automaticallyImplyLeading: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_currentIndex == 0)
                      Text(
                        AppLocalizations.of(context)
                            .translate('home_txt_location'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    if (_currentIndex == 0)
                      Container(
                        child: new GestureDetector(
                          //tapping to go the corresponding view linked with it using navigator
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewPage()));
                          },
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  (globals.addressChange == true)
                                      ? globals.newAddress.addressLine
                                          .toString()
                                      : globals.addressLocation.addressLine
                                          .toString(),

                                  //newAddress.addressL// current location
                                  maxLines: 2,

                                  style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    if (_currentIndex == 1)
                      setHeader(
                        AppLocalizations.of(context).translate(
                          'tab_categories',
                        ),
                      ),
                    if (_currentIndex == 2)

//              setHeader(AppLocalizations.of(context).translate('tab_orders')),
                      if (_currentIndex == 3)
                        setHeader(AppLocalizations.of(context)
                            .translate('tab_account')),
                  ],
                ),
                actions: <Widget>[
                  if (_currentIndex == 0)
                    if (globals.guest == true)
                      new IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(AppLocalizations.of(context)
                                  .translate('header')),
                              content: Text(AppLocalizations.of(context)
                                  .translate('logout_prompt')),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(AppLocalizations.of(context)
                                      .translate('no')),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    if (globals.guest == true) {
                                      globals.guest = false;
                                      globals.isCustomer = true;
                                      globals.currentUser = null;
                                      Navigator.popUntil(
                                          context,
                                          (Route<dynamic> route) =>
                                              route.isFirst);

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserLogin()));
                                    }
                                  },
                                  /*Navigator.of(context).pop(true)*/
                                  child: Text(AppLocalizations.of(context)
                                      .translate('yes')),
                                ),
                              ],
                            ),
                          );

//              Preferences.removePreference("user");
//              Navigator.pushReplacement(context,
//                  MaterialPageRoute(builder: (context) => UserLogin()));
                        },
                      ),
//          if (_currentIndex == 3)

//         new IconButton(
//            icon: new Icon(editIcon),
//            onPressed: () {
//              setState(() {
//                if(editIcon == Icons.mode_edit) {
//                  editIcon = Icons.done;
//                } else {
//                  editIcon = Icons.mode_edit;
//                }
//                key.currentState.validateform();
//              });
//
//            },
//          ),
//          if (_currentIndex == 3)
//          new IconButton(
//            icon: new Icon(Icons.exit_to_app),
//            onPressed: () {
//              Preferences.removePreference("user");
//              Preferences.removePreference("profile");
//
//              if(globals.currentUser.social_signin == "facebook") {
//                logoutFacebook();
//              } else if(globals.currentUser.social_signin == "gmail") {
//                signOutGoogle();
//              }
//              globals.isCustomer = true;
//              globals.currentUser = null;
//              globals.customRadius = null;
//              globals.customImage = null;
//              globals.customGender = null;
//              globals.customContact = null;
//              globals.customFirstName = null;
//              globals.customLanguage = null;
//              ServiceSelectionUIPageState.serviceNamesString = null;
//              ServiceSelectionUIPageState.selectedServices = null;
//              Navigator.pushReplacement(context,
//                  MaterialPageRoute(builder: (context) => UserLogin()));
//           },
//         ),
                ],
                iconTheme: IconThemeData(
                  color: Colors.grey,
                ),
              )
            : null,
        // Middle Body
        body: (globals.guest == true)
            ? _guestChildren[_currentIndex]
            : _children[_currentIndex],
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.deepOrange,
            selectedItemBorderColor: Colors.white,
            selectedItemBackgroundColor: Colors.deepOrange,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.white,
            unselectedItemIconColor: Colors.white,
            unselectedItemLabelColor: Colors.white,
            selectedItemTextStyle: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0.8,  fontFamily: 'Courier_Prime'),
            unselectedItemTextStyle: TextStyle(letterSpacing: 0.8,fontFamily: 'Courier_Prime'),
            showSelectedItemShadow: true,
          ),
          selectedIndex: _currentIndex,
          onSelectTab: (index) {
            setState(() {
              onTabTapped(index);
            });
          },
          items: [
            FFNavigationBarItem(

              iconData: Icons.home,
              label: AppLocalizations.of(context).translate('home'),
            ),
            FFNavigationBarItem(
              iconData: Icons.grid_on,
              label: AppLocalizations.of(context).translate('bottom_categories'),
            ),
            if (globals.guest == false)
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: AppLocalizations.of(context).translate('bottom_orders'),
              ),
            if (globals.guest == false)
              FFNavigationBarItem(
                iconData: Icons.person_pin,
                label: AppLocalizations.of(context).translate('profile'),
              ),
          ],
        ));
  }

  /*BottomNavigationBar(
        elevation: 0.2,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        showSelectedLabels: true,
//        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.orange[50],
        backgroundColor: Colors.deepOrange,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              title: SizedBox.shrink()),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.grid_on,
                size: 30,
              ),
              title: SizedBox.shrink()),
          if (globals.guest == false)
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: 30,
              ),
              title: SizedBox.shrink(),
            ),
//          if(globals.guest == false)
//            BottomNavigationBarItem(
//                icon: Icon(Icons.place),
//                title: SizedBox.shrink()),
          if (globals.guest == false)
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_pin,
                  size: 30,
                ),
                title: SizedBox.shrink()),
        ],
      ),*/

  Widget setHeader(String title) {
    return Container(
      child: Center(
          child: Text(title,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center)),
    );
  }

  final List<Widget> _guestChildren = [
    HomeUIDesign(),
    CategoryScreen(),
  ];

  final List<Widget> _children = [
    HomeUIDesign(),
    CategoryScreen(),

    if (globals.guest == false)
      if (globals.currentUser.roles[0].slug == 'customer')
        OrderUIPage(
          url: Configurations.BOOKING_URL,
          isCustomer: true,
        ),
    if (globals.guest == false)
      if (globals.currentUser.roles[0].slug == 'provider') VendorOrderUIPage(),
    if (globals.guest == false) ProfileUIPage(key: key),
//    if(globals.guest == false)
//      ProfileUIPage(key: key),
  ];

  void onTabTapped(int index) {
    setState(() {
      if (index == 0) isShowAppBar = true;
      if (index == 1) isShowAppBar = true;
      if (index == 2) isShowAppBar = false;
      if (index == 3) isShowAppBar = false;
      _currentIndex = index;
    });
  }
}
