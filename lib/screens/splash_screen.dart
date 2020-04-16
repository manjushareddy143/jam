
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jam/home_widget.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/service.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';

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
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/Splash-1x.jpg'),
            fit: BoxFit.fill),
      ),
    );
//    return Scaffold(
//      body: new Center(
//        child: new Image.asset(
//          "assets/images/Splash-1x.jpg",
//          fit: BoxFit.fill,
//          height: double.infinity,
//          width: double.infinity,
//        ),
//      ),
//    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Preferences.readObject("email").then((val) {
      if (val == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserLogin(),
            ));
      } else {
//        getServices();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    });
  }

//  void getServices() async {
//    try {
//      Map<String, String> data = new HashMap();
//      HttpClient httpClient = new HttpClient();
//      var syncReportResponse =
//      await httpClient.getRequest(context, "http://jam.savitriya.com/api/all_services", null, null, true, false);
//      processReportResponse(syncReportResponse);
//    } on Exception catch (e) {
//      if (e is Exception) {
//        printExceptionLog(e);
//      }
//    }
//  }

//  void processReportResponse(Response res) {
//    print('get daily format');
//    if (res != null) {
//      if (res.statusCode == 200) {
//        var data = json.decode(res.body);
//        print(data);
//        List roles = data;
//        List<Service> listofRoles = Service.processServices(roles);
//        // Preferences.saveObject('reportformate', jsonEncode(listofRoles));
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => HomeScreen(),
//            ));
//      } else {
//        printLog("login response code is not 200");
//      }
//    } else {
//      print('no data');
//    }
//  }
}