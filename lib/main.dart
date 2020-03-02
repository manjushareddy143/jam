
import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:flutter_demo/api/network.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}



const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';



class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List<Post> data;
  List tempData;









  @override
  void initState(){
    super.initState();
    this.getMyData();
    this.setState(() {



    });




  }


   Future<List<Post>> getMyData() async{
    MyNet network = MyNet('$apiUrl');
    var response = await network.getData();
    tempData = json.decode(response);
    data= tempData.map<Post>((json) => Post.fromJson(json)).toList();
    return data;




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
                child: Text(data[index].title),

              );}
        ));
  }
/* Future<List<Post>> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Accept": "application/json"
        }
    );
*/
/* Future<List<Post>> getMyData() async{
   MyNet n = MyNet('https://jsonplaceholder.typicode.com/posts');
   var res = await network.getData();
    this.setState(() {
      tempData = json.decode(res.body);

    });
    data= tempData.map<Post>((json) => Post.fromJson(json)).toList();
    print(Post);
  }
*/}







class Post {
  int userId;
  int id;
  String title;

  Post({this.userId, this.id, this.title});

  factory Post.fromJson(Map<String, dynamic> json){print(Post(
    userId: json['userId'],
    id: json['id'],
    title: json['title'],
  ),);
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}