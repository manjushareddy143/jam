import 'package:flutter/material.dart';
class HelloWorldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Material(
        child: new Center(
          child: new Text("Service view of the tapped one!"),

        ),

      ),
    );
  }
}