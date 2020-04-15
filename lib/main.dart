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

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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