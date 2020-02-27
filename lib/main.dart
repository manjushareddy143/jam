import 'package:flutter/material.dart';
import 'package:flutter_demo/api/cat_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Button(),
    );
  }
}
class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button'),
      ),
      body: Center(
        child: FlatButton.icon(
          color: Colors.pink,
          icon: Icon(Icons.apps), //`Icon` to display
          label: Text('GET API'), //`Text` to display
          onPressed: () {
           Future<http.Response> fetchPost() {
              return http.get('https://jsonplaceholder.typicode.com/posts/1');
    }
            }
            //Code to execute when Floating Action Button is clicked
            //...
          },
        ),
      ),
    );
  }
}