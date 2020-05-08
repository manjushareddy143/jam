import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:jam/api/detail.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/service.dart';
import 'package:jam/screens/splash_screen.dart';
import 'package:jam/services.dart';

import 'package:flutter/material.dart';
import 'package:jam/home_widget.dart';
import 'package:jam/api/network.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';
main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  void setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
       localizationsDelegates:[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), //English
          const Locale('ar', 'SA'), //Arabic
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == deviceLocale.languageCode &&
                supportedLocale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },

        home: SplashScreen());
  }
}

//class HomePage extends StatefulWidget {
//  @override
//  HomePageState createState() => new HomePageState();
//}
//
//class HomePageState extends State<HomePage> {
//  List<Post> data;
//  List tempData;
//
//  @override
//  void initState() {
//    super.initState();
//    this.setState(() {});
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Testing"),
//      ),
//      body: ServicesList(),
//    );
//  }
//}
//
//class Post {
//  int userId;
//  int id;
//  String title;
//
//  Post({this.userId, this.id, this.title});
//
//  factory Post.fromJson(Map<String, dynamic> json) {
//    return new Post(
//      userId: json['userId'] as int,
//      id: json['id'] as int,
//      title: json['title'] as String,
//    );
//  }
//}
