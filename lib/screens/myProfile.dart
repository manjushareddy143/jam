import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
//import 'package:image_picker/image_picker.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  File _image;
 List<Tab> tabList = List();
  TabController _tabController;
  User user;

  @override
  void initState(){
    tabList.add(new Tab(text: 'About',));
    _tabController= TabController(vsync: this, length: tabList.length);
    super.initState();
    getProfile();
  }

  void getProfile() async  {
    await Preferences.readObject("user").then((onValue) async {
      var userdata = json.decode(onValue);
      setState(() {
        user = User.fromJson(userdata);
      });
    });
  }

  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = image;
      print("IMAGE:::::::::: $_image");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(user == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else {
      return Scaffold(
          body: SingleChildScrollView(
            child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: myProfileUI(),
            ),
          )
      );
    }

  }


  Widget myProfileUI() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildCoverImage(MediaQuery.of(context).size),
          SizedBox(height: 10,),
          setDetails(),
//          setTabbar(),
        ],
      ),
    );
  }


  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height /3.6,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          _buildProfileImage(),
          SizedBox(height: 10),
      Text(this.user.first_name,
        textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
        style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w400,
            color: Colors.white),
      ),
//          Text("Image size upto 3MB", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 5),
       GestureDetector(
         onTap: () {
           getImage();
           },
           child: Text("Upload Photo", textAlign: TextAlign.center,
               style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.w500,
                   color: Colors.teal)
           )
       )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }


  Widget _buildProfileImage() {
    return Center(
      child: Container(
        child: GestureDetector(
          onTap: () {
            print("object");
            getImage();
          }, // handle your image tap here
        ),
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          image:
          DecorationImage(
            image: (_image == null) ? AssetImage("assets/images/BG-1x.jpg") : FileImage(_image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 5.0,
          ),
        ),
      ),
    );
  }

  Widget setDetails(){
    return Column( crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              hintText: "Male", prefixIcon: Icon(Icons.face), enabled: false
          ),
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
                    color: Colors.teal,

                  ),
                  insets: EdgeInsets.only(
                      left: 15,
                      right: 8,
                      bottom: 0)),
            isScrollable: true,
            labelColor: Colors.teal,




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