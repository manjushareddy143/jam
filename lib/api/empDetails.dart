import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jam/components/back_button_appbar.dart';
class EmpDetails extends StatefulWidget {
  _employee createState() => new _employee();
}

class _employee extends State<EmpDetails> {
 int empIndex =0;

  List<String> empScr = [
    '32','3.5','4'
  ];
 List<String> empTitle = [
   'Job Done',
   'Rating',
   'Experience',

 ];


TabController _tab;

  @override
  Widget build(BuildContext context) {
          // TODO: implement build
      return Scaffold(resizeToAvoidBottomPadding: false,
      appBar: AppBar(leading: BackButton(color:Colors.black), title: Text("Vendor Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),), backgroundColor: Colors.white, ),
        body: SingleChildScrollView(
          child: empScreenUI(),
        ),
      );
  }
  Widget empScreenUI(){
    return Column(
      children: <Widget>[
        Container(padding: EdgeInsets.all(30.0),
          color: Colors.black,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: new BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.fill, image: new AssetImage('assets/images/vicky.jpg')) ),
              ),
              SizedBox(height: 10.0,),
              Text(
                "Himanshu Malik",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w600, color: Colors.white),
              ),
              SizedBox(height: 50,),
              Ratings(),

            ],
          ),

        ),
        SizedBox(height: 10,),
        Container(padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column( crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                    decoration: InputDecoration(hintText: "Male", prefixIcon: Icon(Icons.face), enabled: false),
                  ),
              TextField(
                    decoration: InputDecoration(hintText: "From India", prefixIcon: Icon(Icons.location_on),enabled: false),
                 ),
              TextField(
                decoration: InputDecoration(hintText: "Knows English and Hindi", prefixIcon: Icon(Icons.library_books), enabled: false),
              ),
              TextField(
                decoration: InputDecoration(hintText: "Monday-Friday | 9:30AM - 6:30PM", prefixIcon: Icon(Icons.access_time), enabled: false),
              ),
              TextField(
                decoration: InputDecoration(hintText: "Wet Servicing, Repairing Work", prefixIcon: Icon(Icons.settings), enabled: false),
              ),
              TextField(
                decoration: InputDecoration(hintText: "info@partservices.com", prefixIcon: Icon(Icons.email),enabled: false),
              ),
              TextField(
                decoration: InputDecoration(hintText: "+911234567890", prefixIcon: Icon(Icons.call),enabled: false),
              ),


            ],
          ),
        ),
        SizedBox(height: 30,),
       /*  DefaultTabController( length: 2,
        child: Column(children: <Widget>[Container(
          constraints:  BoxConstraints.expand(height: 30),
           child: TabBar(tabs: <Widget>[Tab(text: "About ",),
             Tab(text: "Reviews",)],),
        ) ,
        Container(child: Container(child: TabBarView(children: <Widget>[
          Container(child: Text("About Us"),),
          Container(child: Text("Reviews"),)
        ],),),),],),
        ), */

      ],

    );
  }
  Widget Ratings()
  {
    return Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column( children: <Widget>[
          Text(empScr[empIndex], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25.0,)),
          Text(empTitle[empIndex], style: TextStyle(color: Colors.white),),]),
         Column( children: <Widget>[
           Text('4.2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25.0,), ),
           Text('Rating', style: TextStyle(color: Colors.white),),]),
         Column( children: <Widget>[
            Text('2 Yr', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25.0,)),
            Text('Experience', style: TextStyle(color: Colors.white),),
        ],),


      ],
    );
  }

}