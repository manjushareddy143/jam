import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Accept": "application/json"
        }
    );

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data[1]["title"]);

    return data.map<Post>((json) => Post.fromJson(json)).toList();
  }

  class Post{
    final int userId;
    final int id;
    final String title;

    Post(
  {this.userId, this.id, this.title});

    factory Post.fromJson(Map<String, dynamic> json){
      return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      );
  }

  }

  @override
  void initState(){
    super.initState();
    this.getData();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("List"),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Text(data[index]["title"]),

          );
        },
      ),
    );
  }
}