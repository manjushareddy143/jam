import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:jam/app_localizations.dart';

class Profile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ProfileUIPage();
      //Center(child: );
  }
}
class ProfileUIPage extends StatefulWidget {

  ProfileUIPage({ Key key }) : super(key: key);
  @override
  ProfileUIPageState createState() => new ProfileUIPageState();
}
class ProfileUIPageState extends State<ProfileUIPage> with TickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
//  bool isEdit = false;
  bool isEditProfile = false;


  File _image;
 List<Tab> tabList = List();
  TabController _tabController;
  User user;
  FocusNode focus_email, focus_no, focus_address;





  @override
  void initState(){
    tabList.add(new Tab(text: 'About',));
    _tabController= TabController(vsync: this, length: tabList.length);

    super.initState();
    focus_email = FocusNode();
    focus_no = FocusNode();
    focus_address = FocusNode();
    getProfile();
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focus_email.dispose();
    focus_no.dispose();
    focus_address.dispose();


    super.dispose();
  }

  void validateform() {
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a Snackbar.
      print('EDIT');
      setState(() {
        if(isEditProfile == true) {
          isEditProfile = false;
        } else {
          isEditProfile = true;
        }
      });
    }
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
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
        _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(user == null) {
      return new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    } else {
      return GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            body: SingleChildScrollView(
              child: new Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: myProfileUI(),
              ),
            )
        ),
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
          setTabbar(),
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
          SizedBox(height: 5),
       GestureDetector(
         onTap: () {
           if(isEditProfile) {
             getImage();
           } else {
             showInfoAlert(context, "Please enable edit mode");
           }
         },
           child: Text(AppLocalizations.of(context).translate('upload'), textAlign: TextAlign.center,
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
    if(user.image == null) {
      return Center(
        child: Container(
          child: GestureDetector(
            onTap: () {
              print("object");
              if(isEditProfile) {
                getImage();
              }else {
                showInfoAlert(context, "Please enable edit mode");
              }

            }, // handle your image tap here
          ),
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            image:
            DecorationImage(
              image:
              (_image == null) ? AssetImage("assets/images/BG-1x.jpg") : FileImage(_image),
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
    } else {
      return Center(
      child: Container(
        child: GestureDetector(
          onTap: () {
            print("object");
            if(isEditProfile) {
              getImage();
            }else {
              showInfoAlert(context, "Please enable edit mode");
            }

          }, // handle your image tap here
        ),
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          image:
          DecorationImage(
            image:
            (user.image == null) ? AssetImage("assets/images/BG-1x.jpg") : NetworkImage(user.image),
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
  }

  Widget setDetails(){

    String addressString = user.address.address_line1;
    if(user.address.address_line2 != "") {
      addressString += ", " + user.address.address_line2;
    }

    if(user.address.landmark != "") {
      addressString += ", " + user.address.landmark;
    }
    addressString += ", " + user.address.district
        + ", " + user.address.city + ", " + user.address.postal_code + ".";

    return Column( crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextField(

          decoration: InputDecoration(
              hintText: user.gender, prefixIcon: Icon(Icons.face), enabled: isEditProfile
          ),
        ),
        TextField(
          focusNode: focus_email,
          decoration: InputDecoration(hintText: user.email, prefixIcon: Icon(Icons.email),enabled: isEditProfile),
        ),
        TextField(
          focusNode: focus_no,
          decoration: InputDecoration(hintText: user.contact, prefixIcon: Icon(Icons.call),enabled: isEditProfile),
        ),


        TextField(
          decoration: InputDecoration(hintText: (user.languages == null) ? "NOT SELECTED" : user.languages, prefixIcon: Icon(Icons.library_books), enabled: isEditProfile),
        ),
        TextField(
          focusNode: focus_address,
          decoration: InputDecoration(hintText: addressString, prefixIcon: Icon(Icons.location_on),enabled: isEditProfile,
          helperMaxLines: 5, hintMaxLines: 5),
        ),
      ],

    );
  }

  Widget setRichText(){
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'About Us', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ) ),
          SizedBox(height: 10,),
//          SingleChildScrollView(
//            child: RichText(
//              softWrap: true,
//              textWidthBasis: TextWidthBasis.parent,
//              overflow: TextOverflow.ellipsis,
//              maxLines: 150,
////              text: Text("Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod Color is a form of non verbal communication. It is not a static energy and its meaning can change from one day to the next with any individual - it all depends on what energy they are expressing at that point in time "
////              ),
//            ),
//          )

//          Container(
////            child:
////            RichText(
////                overflow: TextOverflow.ellipsis,
////                maxLines: 50,
////                text:
////                TextSpan(
////                  text:'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod Color is a form of non verbal communication. It is not a static energy and its meaning can change from one day to the next with any individual - it all depends on what energy they are expressing at that point in time ' ,style: DefaultTextStyle.of(context).style,
////                )
////
////            ),
//            height: 250,
//          )
        ],
      ),
    );


  }

  Widget setTabbar(){
    return Column(
      children: <Widget>[
        new Container(color: Colors.black12,
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