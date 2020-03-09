
import 'dart:async';
import 'dart:convert';
import 'package:jam/services.dart';

import 'package:flutter/material.dart';

import 'package:jam/api/network.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}



const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';




/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Collapsing List Demo')),
        body: CollapsingList(),
      ),
    );
  }
}*/






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
   //this.getMyData();
    this.setState(() {
    });
  }


    getMyData() async{
    MyNet network = MyNet('$apiUrl');
    var response = await network.getData();

    tempData = json.decode(response);

    data=tempData.map<Post>((m) => new Post.fromJson(m)).toList();
    setState(() {

    });



   // return data;

  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Testing"),

        ),
        body:      CollapsingList(),

       /*   ListView.builder(
            itemCount: data == null ? 0 : data.length,

            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child:

                Text(data[index].title),

              );}
        )   */
    );
  }

}







class Post {
    int userId;
   int id;
   String title;

  Post({this.userId, this.id, this.title});

  factory Post.fromJson(Map<String, dynamic> json){
    return new Post(userId: json['userId'] as int,
     id: json['id'] as int,
     title: json['title'] as String,
    );

  }
}