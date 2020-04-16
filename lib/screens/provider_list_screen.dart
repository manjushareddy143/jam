import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:math' as math;

class ProviceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: ProviceListPage());
  }
}

class ProviceListPage extends StatefulWidget {
//  const ProviceListPage ({ Key key }): super(key: key);

  @override
  _ProviceListState createState() => _ProviceListState();
}

class _ProviceListState extends State<ProviceListPage> {
  int acIndex = 0;
  List<String> acImage = [
    'assets/images/vicky.jpg',
    'assets/images/ayu.jpg',
    'assets/images/shah.jpg',
    'assets/images/sal.jpg',
  ];
  List<String> acName = [
    'Himanshu Malik',
    'Afrar Sheikh',
    'Abdur Rahman',
    'Osama',
  ];
  List<String> acExp = ['1', '3', '3.5', '4'];
  List<String> acRev = ['3', '3', '5', '2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Text(
            '1100 +  AC Services',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: listOfCards(),
          ),
        )
    );
  }

  List<Widget> listOfCards() {
    List<Widget> list = new List();

    list.add(Image.asset(
      "assets/images/actop.jpg",
      fit: BoxFit.contain,
    ));
    list.add(setupCard());

    return list;
  }


  Widget setupCard() {
    return new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            onTap: ()=> {
              print('tap on card')
            },
            leading: Container(
              width: 60,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    image: NetworkImage(
                        "http://jam.savitriya.com/images/category/737712221.jpeg"),
                    fit: BoxFit.fill,
                  )),
            ),
            title: Text('Himansu Malik'),
            subtitle: Text('Experience: 2 Years'),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton.icon(
//                          color: Colors.red,
                        icon: Icon(Icons.monetization_on, color: Colors.teal), //`Icon` to display
                        label: Text('Get Quotes', style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.teal)), //`Text` to display
                        onPressed: () {
                          print('Quotes Press');
                        },
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: FlatButton.icon(
                      icon: Icon(Icons.call, color: Colors.teal), //`Icon` to display
                      label: Text('Call', style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.teal)), //`Text` to display
                      onPressed: () {
                        print('Call Press');
                        //Code to execute when Floating Action Button is clicked
                        //...
                      },
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}
