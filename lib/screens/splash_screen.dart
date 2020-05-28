
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jam/login/login.dart';
import 'package:jam/main.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/user.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/screens/initial_profile.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}


class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  void getLanguage() async {
    await Preferences.readObject("lang").then((onValue) async {
     // printLog('userdata');
      printLog(onValue);
      setState(() {
        if(onValue == 'SA') {
          MyApp.setLocale(context, Locale('ar' , 'SA'));
          //Directionality.of(context) == TextDirection.rtl;
         // Directionality(textDirection: TextDirection.rtl,);
          //printlog("rtl please");
        } else {
          MyApp.setLocale(context, Locale('en', 'US'));
        }
        loadData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/playstore.png'),
            fit: BoxFit.fill),
      ),
    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Preferences.readObject("profile").then((val) {
      printLog("PROFILE $val");
      if (val == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserLogin(),
            )
        );
      } else if (val == "1") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InitialProfileScreen(),
            ));
      } else {
        setProfile();
      }
    });
  }

  void setProfile() async  {
    await Preferences.readObject("user").then((onValue) async {
      var userdata = json.decode(onValue);
      printLog('userdata');
      printLog(userdata);
      setState(() {
        globals.currentUser = User.fromJson(userdata);
        print(globals.currentUser.roles[0].slug);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      });
    });
  }
}