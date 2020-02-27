import 'package:flutter/material.dart';

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
            void getCatData() async {
              var result = await CatAPI().getCatBreeds();
              print(result);
            }
            //Code to execute when Floating Action Button is clicked
            //...
          },
        ),
      ),
    );
  }
}