import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:package_info/package_info.dart';
//import 'package:pulse/components/widget_helper.dart';
//import 'package:pulse/resources/about_screen.dart';
import 'package:jam/resources/configurations.dart';
//import 'package:pulse/resources/my_colors.dart';
//import 'package:pulse/resources/my_strings.dart';
//import 'package:pulse/screens/login_screen.dart';
//import 'package:pulse/screens/report_screen.dart';
//import 'package:pulse/screens/settings_screen.dart';
//import 'package:pulse/screens/splash_screen.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/globals.dart' as globals;
//import 'package:pulse/models/helper.dart' as helper;


// ignore: missing_return
Future<bool> checkInternetConnection() async {
  try {
    //If we are connected to wifi, but not logged in to any network security like cyberome,sophos, then we need to put time out, otherwise this method keeps on executing without any result
    final result = await InternetAddress.lookup('google.com')
        .timeout(new Duration(seconds: Configurations.CHECK_INTERNET_TIMEOUT));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  //time out indicates no internet access
  on TimeoutException catch (_) {
    return false;
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}

Widget loadingBar([double size]) {
  size ??= 50.0;
  return Align(
      alignment: Alignment.center,
      child: SpinKitRing(
        color: Colors.blue,
        size: size,
      ));
}

void navigateToOtherScreen(BuildContext context, Widget screen) {
  //if we use pushReplacement, when user clicks back he will not see previous screen
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => screen));
}

void processSettings(BuildContext context) {
//  navigateToOtherScreen(context, SettingsScreen());
}

void processJitsiSupport(BuildContext context) {
  printLog('JITSSI........');
}



void processAbout(BuildContext context) {
//  _buildAboutDialog(context);
//  showDialog(
//    context: context,
//    builder: (BuildContext context) => AboutScreen.buildAboutDialog(context),
//  );
}
//const TextStyle linkStyle = const TextStyle(
//  color: Colors.blue,
//  decoration: TextDecoration.underline,
//);





void processLogout(BuildContext context) {
  Preferences.setAppToken("");
  Preferences.setLoggedIn(false);


  printLog("user will be logged out");
  //redirect back to login
//  navigateToOtherScreen(context, LoginScreen());
}

void pushInfoAlert(BuildContext context, String title ,String message) {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        key: _keyLoader,
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
            },
          ),
        ],
      );
    },
  );
}
//info alert,with ok button
void showInfoAlert(BuildContext context, String message) {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        key: _keyLoader,
        title: new Text("JAM"),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
            },
          ),
        ],
      );
    },
  );
}

//to print logs
void printLog(Object msg) {
  //print only if we have enabled the error logs
  if (Configurations.IS_ERROR_LOG_ENABLED) {
    print(msg);
  }
}

//to print errors in log
void printExceptionLog(Exception e) {
  //print only if we have enabled the error logs
  if (Configurations.IS_ERROR_LOG_ENABLED) {
    print("Exception $e");
  }
}
