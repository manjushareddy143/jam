
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_geofence/geofence.dart';
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
import 'package:geopoint/geopoint.dart';
import 'package:geopoint_location/geopoint_location.dart';


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
    getcordinates();
//    getLanguage();
  }

  Future getcordinates() async {
    printLog("getcordinates");

    GeoPoint geoPoint = await geoPointFromLocation(
        name: "Current position", withAddress: true, verbose: false);
    printLog("geoPoint === ${geoPoint.country}" );
    globals.longitude = geoPoint.longitude;
    globals.latitude = geoPoint.latitude;
    getAddress(LatLng(geoPoint.latitude, geoPoint.longitude)).then((onValue) {
      print("getAddress ${onValue.toMap()}");
      globals.addressLocation = onValue;
    });
    getLanguage();
//    globals.location = geoPoint;
//    print("geoPoint:::: ${jsonEncode(geoPoint)}");
//    print("street:::: ${geoPoint.street}");
//    print("region:::: ${geoPoint.region}");
//    print("postalCode:::: ${geoPoint.postalCode}");
//    print("number:::: ${geoPoint.number}");
//    print("sublocality:::: ${geoPoint.sublocality}");
//    print("locality:::: ${geoPoint.locality}");
//    print("country:::: ${geoPoint.country}");
//    print("accuracy:::: ${geoPoint.accuracy}");
//    print("timestamp:::: ${geoPoint.timestamp}");
  }
  void getLanguage() async {
    printLog("getLanguage");
    await Preferences.readObject("lang").then((onValue) async {
     // printLog('userdata');
      printLog("getLanguage::: $onValue");
      setState(() {
        if(onValue == 'SA') {
          MyApp.setLocale(context, Locale('ar' , 'SA'));
        } else {
          MyApp.setLocale(context, Locale('en', 'US'));
        }
        setProfile();
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
        globals.guest = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InitialProfileScreen(),
            ));
      } else if (val == "0"){
        globals.guest = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    });
  }

  void setProfile() async  {
    printLog('setProfile');
    await Preferences.readObject("user").then((onValue) async {
      printLog('userdata');
      printLog(onValue);
      if(onValue == null) {
        loadData();
      } else {
        var userdata = json.decode(onValue);

        setState(() {
          globals.currentUser = User.fromJson(userdata);
          print(globals.currentUser.roles);
          loadData();
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => HomeScreen(),
//            ));
        });
      }

    });
  }
}