import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/resources/configurations.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;

class Profile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: ProfileUIPage());
  }
}
class ProfileUIPage extends StatefulWidget {
  @override
  _ProfileUIPageState createState() => _ProfileUIPageState();
}
class _ProfileUIPageState extends State<ProfileUIPage> with TickerProviderStateMixin {
  File _image;
 List<Tab> tabList = List();
  TabController _tabController;
  @override
  void initState(){
    tabList.add(new Tab(text: 'About',));

    _tabController= TabController(vsync: this, length: tabList.length);
    super.initState();
    print("YY");
  }
  Future getimage()async{
//    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
//      _image = image;
    });

  }
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.black),
          title: Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),), backgroundColor: Colors.white,actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.mode_edit),
            onPressed: () {

            },
          ),
        ],
          iconTheme: IconThemeData(
            color: Configurations.themColor,
          ),),
        body: myProfileUI()
    );
  }
  Widget myProfileUI() {
    return SingleChildScrollView(
      child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container( padding:EdgeInsets.fromLTRB(0,40,0,5), width: double.infinity,
             height: 250,
          color: Colors.black,
                 child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[ _image == null ? Container(
                   width: 120, height: 120,
                    decoration: new BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.fill, image: new AssetImage('assets/images/vicky.jpg')) ),
                     ) : Container(
                    width: 120, height: 120,
                    decoration: new BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.fill, image: new FileImage(_image)) ),
                  ),
                    SizedBox(height: 5,),

                    Text(
                      "Hussainali Hamdan",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w400, color: Colors.white),
                    ),

                    FlatButton(
                      child:
                      Text("Upload Photo", textAlign: TextAlign.center,style: TextStyle(fontSize: 10 ,fontWeight: FontWeight.w300, color: Configurations.themColor)),
                      onPressed:getimage,
                    )


                    ]
                  ),
                 ),
          setDetails(),
          /* SizedBox(width: double.infinity,height: 50, child: Container(padding: EdgeInsets.all(15),color: Colors.grey,
            child: Text('About',style: TextStyle(
              decoration: TextDecoration.underline, color: Colors.teal,fontSize: 20, fontWeight: FontWeight.w300
            ),),
          ),), */
          setTabbar(),

        ],
      ),

    );
  }
  Widget setDetails(){
    return Column( crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: "Male", prefixIcon: Icon(Icons.face), enabled: false),
        ),
        TextField(
          decoration: InputDecoration(hintText: "info@partservices.com", prefixIcon: Icon(Icons.email),enabled: false),
        ),
        TextField(
          decoration: InputDecoration(hintText: "+911234567890", prefixIcon: Icon(Icons.call),enabled: false),
        ),


        TextField(
          decoration: InputDecoration(hintText: "Language Knows English and Hindi", prefixIcon: Icon(Icons.library_books), enabled: false),
        ),
        TextField(
          decoration: InputDecoration(hintText: "11th /B Lorem ipsum dolor sit amet, consectetuer", prefixIcon: Icon(Icons.location_on),enabled: false),
        ),





      ],

    );
  }
  Widget setRichText(){
    return Container(padding: EdgeInsets.all(30.0),

      child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ Text(
            'About Us', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ) ),
          SizedBox(height: 10,),


          RichText(
            text:
            TextSpan(text:'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod Color is a form of non verbal communication. It is not a static energy and its meaning can change from one day to the next with any individual - it all depends on what energy they are expressing at that point in time ' ,style: DefaultTextStyle.of(context).style,)

        ),],
      ),
    );


  }
  Widget setTabbar(){
    return Column(
      children: <Widget>[
        new Container(color: Colors.grey,
          width: double.infinity,
          child: TabBar(
            controller: _tabController,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2,
                    color: Configurations.themColor,

                  ),
                  insets: EdgeInsets.only(
                      left: 15,
                      right: 8,
                      bottom: 0)),
            isScrollable: true,
            labelColor: Configurations.themColor,




            //indicatorColor: Colors.teal,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs : tabList
          ),
        ),
         Container(
           height: 200,

           child: TabBarView(

           controller: _tabController,
           children:
           tabList.map((Tab tab){
             return _getPage(tab);
           }).toList(),

         ),),
      ]
    );
  }

  Widget _getPage(Tab tab){
    switch(tab.text){
      case 'About' : return setRichText();

    }
  }
}