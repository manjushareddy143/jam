import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class OrderDetail extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: DetailUIPage());
  }
}
class DetailUIPage extends StatefulWidget {
  @override
  _DetailUIPageState createState() => _DetailUIPageState();
}
class _DetailUIPageState extends State<DetailUIPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.black),
    title: Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),),
      body: detailUI(),

    );
  }
  Widget detailUI(){
     return SingleChildScrollView(
         child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         //crossAxisAlignment: CrossAxisAlignment.end,
         children: <Widget>[
           Material(elevation: 5.0,shadowColor: Colors.grey,
               child: Container(
                 child: setFirst(),
               )),
           Material(elevation: 5.0,shadowColor: Colors.grey,
               child: Container()),
           Material(elevation: 5.0,shadowColor: Colors.grey,
               child: Container()),
         ]),
     );

  }
   Widget setFirst(){
    return Column(
      children: <Widget>[
        Text("Order Number : #A5990245"),

        Row(
          children: <Widget>[

            setDate(),
            setTime(),

          ],
        )
      ],
    );
   }
   Widget setDate(){

   }
   Widget setTime()
}