import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/classes/language.dart';
import 'package:jam/login/login.dart';
import 'package:jam/main.dart';
import 'package:jam/models/address.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/service_selection.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:jam/utils/httpclient.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
class ProfileUIPageState extends State<ProfileUIPage> with TickerProviderStateMixin,
    AutomaticKeepAliveClientMixin<ProfileUIPage> {

  @override
  bool get wantKeepAlive => true;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool isEditProfile = false;



  File _image;
 List<Tab> tabList = List();
  TabController _tabController;
  FocusNode focus_email, focus_fName, focus_lName, focus_no, focus_address, focus_radius;

  Address singleAddress = Address(0, "", "", "", "", "", "", "", globals.currentUser.id, "");

  var editIcon = Icons.mode_edit;

  @override
  void initState(){
    globals.context = context;
    if(globals.currentUser.address != null && globals.currentUser.address.length > 0) {
      singleAddress = globals.currentUser.address[0];
    } else {
      print("no address");
    }
    tabList.add(new Tab(text: 'Address',));
    _tabController= TabController(vsync: this, length: tabList.length);

    super.initState();
    focus_fName = FocusNode();
    focus_lName = FocusNode();
    focus_email = FocusNode();
    focus_no = FocusNode();
    focus_radius = FocusNode();
    focus_address = FocusNode();
    isEditProfile = false;

    if(globals.currentUser.languages != null) {
      List langs = globals.currentUser.languages.split(',');
      langs.forEach((element) {
        if(element == 'English') {
          _english = true;
          languages.add("English");
        }

        if(element == 'Arabic') {
          _arabic = true;
          languages.add("Arabic");
        }
      });
    }



  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focus_email.dispose();
    focus_fName.dispose();
    focus_lName.dispose();
    focus_no.dispose();
    focus_radius.dispose();
    focus_address.dispose();
    super.dispose();
  }

  void validateform() {
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a Snackbar.

      print('EDIT');
      setState(() {
        if(isEditProfile == true) {

          updateProfile();
          isEditProfile = false;
        } else {
          if(globals.currentUser.address != null && globals.currentUser.address.length > 0) {
            singleAddress = globals.currentUser.address[0];
          }
          isEditProfile = true;
        }
      });
    }
  }

//  void getProfile() async  {
//    await Preferences.readObject("user").then((onValue) async {
//      var userdata = json.decode(onValue);
//      setState(() {
//        globals.currentUser = User.fromJson(userdata);
//      });
//    });
//  }

  String imageUrl = "";
  Future getImage() async {
    final imageSrc = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select the image source"),
        actions: <Widget>[
          MaterialButton(
            child: Text(AppLocalizations.of(context).translate('profile_camera')),
            onPressed: () => Navigator.pop(
              context,
              ImageSource.camera,
            ),
          ),
          MaterialButton(
            child: Text(AppLocalizations.of(context).translate('profile_gallery')),
            onPressed: () => Navigator.pop(
              context,
              ImageSource.gallery,
            ),
          ),
        ],
      ),
    );
    if (imageSrc != null) {
      final image = await ImagePicker.pickImage(
        source: imageSrc,
        imageQuality: 20,
      );
      if (image != null) {
        setState(() {
          imageUrl = null;
          _image = image;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.orange[50],
        resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,

              child: profile(),
              //myProfileUI(),
            ),
          )
      ),
    );
  }

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> logoutFacebook() async {
    await facebookSignIn.logOut();
//    _showMessage('Logged out.');
  }
  final GoogleSignIn googleSignIn = GoogleSignIn();
  void signOutGoogle() async{
    await googleSignIn.signOut();
    print("User Sign Out");
  }

  void logOut_app() {
    Preferences.removePreference("user");
    Preferences.removePreference("profile");

    if(globals.currentUser.social_signin == "facebook") {
      logoutFacebook();
    } else if(globals.currentUser.social_signin == "gmail") {
      signOutGoogle();
    }
    globals.isCustomer = true;
    globals.currentUser = null;
    globals.customRadius = null;
    globals.customImage = null;
    globals.customGender = null;
    globals.customContact = null;
    globals.customFirstName = null;
    globals.customLanguage = null;
    ServiceSelectionUIPageState.serviceNamesString = null;
    ServiceSelectionUIPageState.selectedServices = null;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => UserLogin()));
  }
  Widget profile(){

    print("isEditProfile = ${isEditProfile}");

    EdgeInsets margin1 = EdgeInsets.only(left: MediaQuery.of(context).size.width - 100,top: 50);
    EdgeInsets margin2 = EdgeInsets.only(left: MediaQuery.of(context).size.width - 50, top: 50);
    EdgeInsets margin3 = EdgeInsets.only(left: MediaQuery.of(context).size.width - 150, top: 50);

    if(globals.localization == 'ar_SA') {
      margin1 = EdgeInsets.only(right: MediaQuery.of(context).size.width - 100,top: 50);
      margin2 = EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.87, top: 50);
      margin3 = EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.55, top: 50);
    }

    return Stack(

      children:
      [

        new Container(
          height: MediaQuery.of(context).size.height * .30,
//          width: MediaQuery.of(context).size.height * .50,
          color: Colors.grey[800],
          child: Container(
            padding: EdgeInsets.only(left: 50, right: 50, bottom: 50, top: 50),
            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/jamLogoWhite.png", fit: BoxFit.contain, height: 100,
                  width: 100.0,
                ),
              ],
            )
          ),
        ),


        if(isEditProfile)
        Padding(padding: margin1,

        child: IconButton(icon: Icon(Icons.done, size: 30, color: Configurations.themColor,), onPressed: ()=> {
          validateform()
        }),),

        Padding(padding: margin2,
          child: IconButton(icon: Icon(Icons.exit_to_app, size: 30, color: Configurations.themColor, ), onPressed: ()=> {
            logOut_app()
          }),),

        if(!isEditProfile)
        Padding(padding: margin3,
          child: DropdownButton(
            underline: SizedBox(),
            onChanged: ( Language language){
              _changeLanguage(language);
            },
            icon: Icon(Icons.language, color: Configurations.themColor,),
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
              value:  lang,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget> [
                  Text(lang.flag),
                  Text(lang.name)
                ],
              ) ,
            )).toList(),
          ),),

        new Container(
          alignment: Alignment.topCenter,
          padding: new EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .20,
              right: 2.0,
              left: 2.0),
          child: Column(
            children: <Widget>[

              Visibility( visible: !isEditProfile,
                  child: myProfile()),
              Visibility( visible: isEditProfile,
                  child: myProfileUI())

            ],
          )
//          new Container(
////            height: 80.0,
//            width: MediaQuery.of(context).size.width,
//            child: ,
//          ),
        ),

//        new Container(
////              height: MediaQuery.of(context).size.height * .75,
//          color: Colors.white,
//        ),


      ],
    );
  }

  void _changeLanguage(Language language){
    Locale _temp;
    switch(language.languageCode){
      case 'en': _temp = Locale(language.languageCode, 'US');
      break;
      case 'ar': _temp = Locale(language.languageCode, 'SA');
      break;
      default: _temp = Locale(language.languageCode, 'US');
    }
    printLog("testet"+_temp.languageCode);
    Preferences.saveObject('lang', _temp.countryCode);
    MyApp.setLocale(context, _temp);
  }


  Widget myProfile(){
    print("MAYUR");
    return Container(

        height: 600.0,
        margin: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
    ),
      child: SingleChildScrollView(
          child: Stack(
            children: [

              setProfileCard(),


              setProfilePic()
            ],
          )
      ),


    );
  }
 Widget setProfileCard(){
   if(globals.currentUser.address != null) {

     if(globals.currentUser.address.length > 0) {
       addressString = singleAddress.address_line1;
       if(singleAddress.address_line2 != "" && singleAddress.address_line2 != null) {
         addressString += ", " + singleAddress.address_line2;
       }

       if(singleAddress.landmark != "" && singleAddress.landmark != null) {
         addressString += ", " + singleAddress.landmark;
       }
       addressString += ", " + singleAddress.district
           + ", " + singleAddress.city + ", " + singleAddress.postal_code + ".";
     }
   }



   String ServiceRadiusHint = "Service Radius";
   if(globals.currentUser.provider != null) {

     ServiceRadiusHint = globals.currentUser.provider.service_radius.toString();
   }

   String services = "";
   if(globals.currentUser.services  != null) {
     globals.currentUser.services.forEach((element) {
       if (services.isEmpty) {
         services = element.service.name;
       } else {
         if(!services.contains(element.service.name)) {
           services += ", " +element.service.name;
         }
       }

       if(element.categories != null) {
         if (services.isEmpty) {
           services = " - " + element.categories.name;
         } else {
           services += " - " +element.categories.name;
         }
       }
     });
   }

String name = globals.currentUser.first_name+" " +globals.currentUser.last_name;
String gender = globals.currentUser.gender;
String num = globals.currentUser.contact;
String email = globals.currentUser.email;
int AddressLength =  (globals.currentUser.address == null) ? 0 : globals.currentUser.address.length;

//  print(globals.currentUser.toJson());

   return Container(
//      height: 900,
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 22),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),),
      child: Padding(
        padding:  EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
       // padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 50,),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(
                  children :[
                    SizedBox(width: 100,
                      child: Flexible(
                        child: Text((name == "" || name == null)? AppLocalizations.of(context).translate('txt_no_name_set') : name, style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 15),maxLines: 2,
                        ),
                    flex: 3,
                  ),
                ),
                SizedBox(width: 10,),
                IconButton(icon: Icon(Icons.edit, size: 14,), onPressed: ()=> {
                  validateform()
                }),


//                IconButton(
//                  icon: new Icon(editIcon),
//                  onPressed: () {
//                    setState(() {
//                      if(editIcon == Icons.mode_edit) {
//                        editIcon = Icons.done;
//                      } else {
//                        editIcon = Icons.mode_edit;
//                      }
//                      validateform();
//                    });
//
//                  },
//                ),
              ]
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,0.0,0,0),
              child: Row(children :[
                Text((gender == "" || gender== null)? AppLocalizations.of(context).translate('gender') : gender, style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300,fontSize: 14),),
                SizedBox(width: 10,),
                Icon((gender == 'Female')?Ionicons.ios_female : Ionicons.ios_male, color: Colors.grey, size: 14,),
              ]
              ),
            ),
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(children :[

                Icon(Icons.call, color: Configurations.themColor, size: 14,),
                SizedBox(width: 10,),
                Text((num == "" || num == null)? AppLocalizations.of(context).translate('txt_no_email_set') : num, style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300,fontSize: 14),),

              ]
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(children :[

                Icon(Icons.email, color: Configurations.themColor, size: 14,),
                SizedBox(width: 10,),
                Text((email == "" || email == null)? AppLocalizations.of(context).translate('txt_no_email_set') : email, style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300,fontSize: 14),),

              ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(children :[

                Icon(Icons.language, color: Configurations.themColor, size: 14,),
                SizedBox(width: 10,),
                Text((globals.currentUser.languages == "" || globals.currentUser.languages == null)? AppLocalizations.of(context).translate('txt_no_lang_set'): globals.currentUser.languages, style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300,fontSize: 14),),

              ]
              ),
            ),
            if(globals.currentUser.roles[0].slug == "provider")
            Padding(
              padding: EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(
                  children :[
                    Icon(Icons.settings, color: Configurations.themColor, size: 14,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Text(
                        (services == "" ) ? AppLocalizations.of(context).translate('txt_no_service_set'): services,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 14),
//                      overflow: TextOverflow.ellipsis,
//                      maxLines: 0,
//                      softWrap: true,
                      ),
                    )

                  ]
              ),
            ),
            if(globals.currentUser.roles[0].slug == "provider")
            Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(children :[

                Icon(Icons.location_searching, color: Configurations.themColor, size: 14,),
                SizedBox(width: 10,),
                Text((ServiceRadiusHint == "" )? AppLocalizations.of(context).translate('txt_radius') : ServiceRadiusHint, style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300,fontSize: 14),),

              ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(children :[

                Icon(Icons.location_on, color: Configurations.themColor, size: 14,),
                SizedBox(width: 10,),
                Expanded(child: Text((addressString == "" || address == null )? AppLocalizations.of(context).translate('txt_no_address_set') : addressString, style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300,fontSize: 14),
                  maxLines: 3,)),

              ]
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
              child: Row(children :[
                Text(AppLocalizations.of(context).translate('address'), style:
                TextStyle(color: Colors.deepOrange,
                    fontWeight: FontWeight.w600,fontSize: 18),),

                IconButton(
                  onPressed: () {
                    addressEnter(true);
                  },
                  icon: Icon(Icons.add),
                )
              ]
              ),
            ),

            if(AddressLength > 0)
              for(int i =0; i < AddressLength ; i++)
                Card(
                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

//                      Text(globals.currentUser.address[i].name, style:
//                      TextStyle(color: Colors.deepOrange,
//                          fontWeight: FontWeight.bold,fontSize: 16),),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                        child:
                        Row(children :[
                          Icon(Icons.location_on, color: Configurations.themColor, size: 18,),
                          SizedBox(width: 10,),




                          Expanded(child: Text(addressListString(globals.currentUser.address[i]), style:
                          TextStyle(color: Colors.deepOrange,
                              fontWeight: FontWeight.w300,fontSize: 16),),)


                        ]
                        ),
                      ),
//                      SizedBox(
//                        height: 10.0,
//                      )
//                      Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//                        child: SizedBox(
//                          height: 1.0,
//                          child: new Center(
//                            child: new Container(
//                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                              height: 0.4,
//                              color: Colors.grey,
//                            ),
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                )








          ],
        ),
      ),
    );

  }

  Widget setProfilePic(){

    if(globals.localization == 'ar_SA') {
      return Positioned(
        top: 30,
        left: 20,
        child: profileImageView(),
      );
    } else {
      return Positioned(
        top: 30,
        right: 20,
        child: profileImageView(),
      );
    }

  }

  Widget profileImageView() {
    print("ima == ${_image}");
    print("USER DETAIL == ${globals.currentUser.image}");
    return Container(

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
        image: (globals.currentUser.image == null) ?
        DecorationImage(
          image:
          (_image == null) ? AssetImage("assets/images/BG-1x.jpg") : FileImage(_image),
          fit: BoxFit.cover,
        ) :

        DecorationImage(
          image:
          (_image == null) ? (globals.currentUser.social_signin == "") ? NetworkImage(Configurations.BASE_URL + globals.currentUser.image) : NetworkImage(globals.currentUser.image) : FileImage(_image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(80.0),
        border: Border.all(
          color: Configurations.themColor,
          width: 0.9,
        ),
      ),
    );
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
          SizedBox(height: 20,),
          setTabbar(),
        ],
      ),
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height /3.6,
//      color: Colors.transparent,
      child: Padding( padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Column(
          children: <Widget>[
            //SizedBox(height: 20),
            _buildProfileImage(),
           // SizedBox(height: 10),
        Text(globals.currentUser.first_name,
          textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
          style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
            //SizedBox(height: 5),

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
                     color: Configurations.themColor)
             )
         )
          ],
        ),
      ),
//      decoration: BoxDecoration(
//        color: Colors.transparent,
//      ),
    );
  }

  Widget 
  _buildProfileImage() {
    if(globals.currentUser.image == null) {
      return Expanded(
        child: Center(
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
           // (globals.currentUser.image == null) ? AssetImage("assets/images/BG-1x.jpg") : NetworkImage(globals.currentUser.image),
            (_image == null) ? (globals.currentUser.social_signin == "") ? NetworkImage(Configurations.BASE_URL + globals.currentUser.image) : NetworkImage(globals.currentUser.image) : FileImage(_image),
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

  final prfl_fname = TextEditingController();
  final prfl_lname = TextEditingController();
  final prfl_email = TextEditingController();
  final prfl_contact = TextEditingController();
  final prfl_radius = TextEditingController();
  String addressString = "";

  Widget setDetails(){


    if(globals.currentUser.address != null) {
      //print("ADDRESS GET  ${globals.currentUser.address[0].address_line1}");
      if(globals.currentUser.address.length > 0) {
        addressString= singleAddress.name;
        addressString += ", " +  singleAddress.address_line1;
        if(singleAddress.address_line2 != "" && singleAddress.address_line2 != null) {
          addressString += ", " + singleAddress.address_line2;
        }

        if(singleAddress.landmark != "" && singleAddress.landmark != null) {
          addressString += ", " + singleAddress.landmark;
        }
        addressString += ", " + singleAddress.district
            + ", " + singleAddress.city + ", " + singleAddress.postal_code + ".";
      }
    }



    String ServiceRadiusHint = "Service Radius";
    if(globals.currentUser.provider != null) {

      ServiceRadiusHint = globals.currentUser.provider.service_radius.toString();
    }


    String services = "";

    if(globals.currentUser.services  != null) {
      globals.currentUser.services.forEach((element) {
        if (services.isEmpty) {
          services = element.service.name;
        } else {
          if(!services.contains(element.service.name)) {
            services += ", " +element.service.name;
          }
        }

        if(element.categories != null) {
          if (services.isEmpty) {
            services = " - " + element.categories.name;
          } else {
            services += " - " +element.categories.name;
          }
        }
      });
    }

    print("SOCIAL == ${globals.currentUser.social_signin}");
    bool enableEmail = false;
    if(globals.currentUser.social_signin == null || globals.currentUser.social_signin == "") {
      enableEmail = true;
      print("enableEmail == ${enableEmail}");
    }
    print("after enableEmail == ${enableEmail}");


    return Padding(
      padding:  EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // FistName
          TextField(
            focusNode: focus_fName,style: (isEditProfile) ?
          TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: (globals.currentUser.first_name == null
                || globals.currentUser.first_name == "" ) ?
            AppLocalizations.of(context).translate('signin_firstname_placeholder')  : globals.currentUser.first_name,
                prefixIcon: Icon(Icons.person, color: Colors.grey,),enabled: isEditProfile, labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Configurations.themColor),
              ),),cursorColor: Configurations.themColor,
            controller: (globals.currentUser.first_name == "")
                ? prfl_fname : prfl_fname ..text = globals.currentUser.first_name,
          ),

          // LastName
          TextField(
            focusNode: focus_lName,style: (isEditProfile) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: (globals.currentUser.last_name == null || globals.currentUser.last_name == "") ?
            AppLocalizations.of(context).translate('signin_lastname_placeholder') : globals.currentUser.last_name,
                prefixIcon: Icon(Icons.person,color: Colors.grey,),enabled: isEditProfile,
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Configurations.themColor),
              ),),cursorColor: Configurations.themColor,
            controller: (globals.currentUser.last_name == "")
                ? prfl_lname : prfl_lname ..text = globals.currentUser.last_name,
          ),

          // EMAIL
          TextField(
            focusNode: focus_email,style: (enableEmail) ?
          TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: (globals.currentUser.email == null || globals.currentUser.email == "") ? AppLocalizations.of(context).translate('inquiry_txt_email')  : globals.currentUser.email,
                prefixIcon: Icon(Icons.email,  color: Colors.grey,),enabled: enableEmail,
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Configurations.themColor),
              ),), cursorColor: Configurations.themColor,

            controller: (globals.currentUser.email == "")
                ? prfl_email : prfl_email ..text = globals.currentUser.email,

          ),

          // PHONE
          TextField(
            focusNode: focus_no, style: (isEditProfile) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: ( globals.currentUser.contact == null ) ? AppLocalizations.of(context).translate('txt_phn_no')  : globals.currentUser.contact,
              prefixIcon: Icon(Icons.call,color: Colors.grey,),enabled: isEditProfile,  labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Configurations.themColor),
              ),), cursorColor: Configurations.themColor,
            controller: (globals.currentUser.contact == "")
                ? prfl_contact : prfl_contact ..text = globals.currentUser.contact,
            keyboardType: TextInputType.phone,
          ),

          Visibility( visible: !isEditProfile,
            // Gender
            child: TextField(
              decoration: InputDecoration(
                  hintText: ( gender == null) ? AppLocalizations.of(context).translate('txt_not_selected'): globals.currentUser.gender,
                  prefixIcon: Icon(Icons.face,color: Colors.grey,), enabled: isEditProfile, labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Configurations.themColor),
                ),
              ),cursorColor: Configurations.themColor,
            ),
          ),
       //   setDropDown(),
          Visibility(
            visible: isEditProfile,
            child: Padding(padding: EdgeInsets.only(left: 10), child: setDropDown(),),
          ),



//         //  Language
//          Visibility( visible: !isEditProfile,
//            child: TextField(style: TextStyle(color: Colors.grey),
//              decoration: InputDecoration(hintText: (globals.currentUser.languages == null) ? "NOT SELECTED" : globals.currentUser.languages,
//                  prefixIcon: Icon(Icons.language), enabled: isEditProfile),
//            ),
//          ),
//          Container(
//              decoration: myBoxDecoration(),
//              child: Padding(padding: EdgeInsets.all(1),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Icon(Icons.language),
//                    SizedBox(width: 10,),
//                    Text("English"),
//                    Checkbox(value: _english, onChanged: _selecteEnglish),
//                    SizedBox(width: 1,),
//                    Text("Arabic"),
//                    Checkbox(value: _arabic, onChanged: _selecteArabic),
//                  ],
//                ),)),

          Visibility( visible: isEditProfile,
           child: Container(
               decoration: myBoxDecoration(),
               child: Padding(padding: EdgeInsets.only(left: 10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Icon(Icons.language, color: Colors.grey,),
                     SizedBox(width: 10,),
                     Text("English"),
                     Checkbox(value: _english, onChanged: _selecteEnglish),
                     SizedBox(width: 1,),
                     Text("Arabic"),
                     Checkbox(value: _arabic, onChanged: _selecteArabic),
                   ],
                 ),)),
           ),


          // Services
//          if(globals.currentUser.roles[0].slug == "provider")
//            Visibility( visible: !isEditProfile,
//              child:  TextField(style: TextStyle(color: Colors.grey),
//                focusNode: focus_address,
//                decoration: InputDecoration(hintText: (services == null || services == "") ? "NOT SET" : services,
//                    prefixIcon: Icon(Icons.settings),enabled: isEditProfile,
//                    helperMaxLines: 5, hintMaxLines: 5),
//              ),
//            ),


          // Radius
          if(globals.currentUser.roles[0].slug == "provider")
          TextField(
            focusNode: focus_radius, style: (isEditProfile) ?
          TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: ServiceRadiusHint,
              prefixIcon: Icon(Icons.location_searching,color: Colors.grey),
              enabled: isEditProfile,
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Configurations.themColor),
              ),),cursorColor: Configurations.themColor,
            controller: (ServiceRadiusHint == "0")
                ? prfl_radius : prfl_radius ..text = ServiceRadiusHint ,
            keyboardType: TextInputType.number,
          ),

          // SERVICES
          if (globals.currentUser.roles[0].slug == "provider" && globals.currentUser.org_id == null)

            Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Container(
//                decoration: BoxDecoration(
//                    border: Border.all(width: 0.9)),
                child: ListTile(
                  onTap: enterServices,
                  leading: Icon(Icons.work),
                  title: Text(
                      (ServiceSelectionUIPageState.serviceNamesString == "")
                          ? AppLocalizations.of(context).translate('init_services')
                          : AppLocalizations.of(context).translate('init_your_services')),
                  subtitle:
                  Text((ServiceSelectionUIPageState.serviceNamesString == null || ServiceSelectionUIPageState.serviceNamesString == "") ? services : ServiceSelectionUIPageState.serviceNamesString),
                ),
              ),
            ),

         //  Address
          Visibility( visible: !isEditProfile,
            child: TextField(style: TextStyle(color: Colors.grey),
              focusNode: focus_address,
              decoration: InputDecoration(hintText: (addressString == null || addressString == "") ?
              AppLocalizations.of(context).translate('txt_no_email_set'): addressString, prefixIcon: Icon(Icons.location_on, color: Colors.grey,),enabled: isEditProfile,
              helperMaxLines: 5, hintMaxLines: 5,
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Configurations.themColor),
                ),), cursorColor: Configurations.themColor,
            ),
          ),
//          Padding(
//            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                ListTile(
//                  onTap: showAddress,
//                  leading: Icon(Icons.location_on),
//                  title: Text( (singleAddress != null) ? (singleAddress.name == "") ? "" : adrs_name.text : "")  ,
//                  subtitle: Text(addressString),
//                ),
//                ButtonBar(
//                  children: <Widget>[
//                    FlatButton(
//                      child: Row(
//                        children: <Widget>[
//                          Icon(
//                            Icons.my_location,
//                            color: Configurations.themColor,
//                            size: 15,
//                          ),
//                          SizedBox(
//                            width: 10,
//                          ),
//                          Text(
//                            AppLocalizations.of(context)
//                                .translate('profile_txt_location'),
//                            style:
//                            TextStyle(color: Configurations.themColor),
//                          )
//                        ],
//                      ),
//                      onPressed: () {
//                        /* ... */
//                        addressEnter(false);
//                      },
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//
          Visibility(visible: isEditProfile,
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: showAddress,
                  leading: Icon(Icons.location_on),
                  title: Text( (singleAddress != null) ? (singleAddress.name == "") ? "" : adrs_name.text : "")  ,
                  subtitle: Text(addressString),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.my_location,
                            color: Configurations.themColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate('profile_txt_location'),
                            style:
                            TextStyle(color: Configurations.themColor),
                          )
                        ],
                      ),
                      onPressed: () {
                        /* ... */
                        addressEnter(false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),)
        ],

      ),
    );
  }

  void enterServices() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ServiceSelectionUIPage(isInitialScreen: 0,)));
  }

  void showAddress() {
    addressEnter(false);
  }

  void updateProfile() {
    print("update");
    var data = new Map<String, String>();
    if(globals.currentUser.first_name != prfl_fname.text && globals.currentUser.first_name != null) {
      data["first_name"] = prfl_fname.text;
    }

    if(globals.currentUser.last_name != prfl_lname.text && globals.currentUser.last_name != null) {
      data["last_name"] = prfl_lname.text;
    }


    if(globals.currentUser.contact != prfl_contact.text && globals.currentUser.contact == null && globals.currentUser.contact == "") {
      data["contact"] = prfl_contact.text;
    }

    if(globals.currentUser.gender != dropdownvalue && globals.currentUser.gender != null) {
      data["gender"] = dropdownvalue;
    }
    print(globals.currentUser.gender);
    print(dropdownvalue);
    print(data['gender']);
    print(globals.currentUser.email);
    if(globals.currentUser.email != prfl_email.text && globals.currentUser.email != null) {

      data["email"] = prfl_email.text;
    }
    print(data['email']);
    if(globals.currentUser.provider != null) {

      if(globals.currentUser.provider.service_radius.toString() != prfl_radius.text && globals.currentUser.provider.service_radius != null) {

        data["service_radius"] = prfl_radius.text;
      }
    }

    String lang = languages.join(',');
    if(globals.currentUser.languages != lang && globals.currentUser.languages != null) {
      data["languages"] = lang;
    }


    if(isAdddressUpdate) {
      var addressData = new Map<String, dynamic>();
      addressData["id"] = singleAddress.id;
      addressData["name"] = adrs_name.text;
      addressData["address_line1"] = adrs_line1.text;
      addressData["address_line2"] = adrs_line2.text;
      addressData["user_id"] = globals.currentUser.id.toString();
      addressData["landmark"] = adrs_landmark.text;
      addressData["district"] = adrs_disctric.text;
      addressData["city"] = adrs_city.text;
      addressData["postal_code"] = adrs_postalcode.text;
      addressData["location"] = globals.latitude.toString() + ',' + globals.longitude.toString();
      data["address"] = jsonEncode(addressData);
    }



    if(globals.currentUser.roles[0].slug == "provider") {
      print("LENGTH == ${ServiceSelectionUIPageState.selectedServices}");
      if(ServiceSelectionUIPageState.selectedServices != null) {
        if(ServiceSelectionUIPageState.selectedServices.length > 0) {
          String rawJson = jsonEncode(ServiceSelectionUIPageState.selectedServices);
          data["services"] = rawJson;
        }
      }

    }
    print("data");
    printLog(data);
    if(data.isNotEmpty && data.length > 0) {
      apiCall(data);
    } else if(_image != null) {
      apiCall(data);
    }
  }

  void apiCall(Map data) async {
    List<http.MultipartFile> files = new List<http.MultipartFile>();
    if (_image != null) {
      files.add(http.MultipartFile.fromBytes(
          'profile_photo', _image.readAsBytesSync(),
          filename: _image.path.split("/").last));
    }

    HttpClient httpClient = new HttpClient();
    Map responseData = await httpClient.postMultipartRequest(
        context, Configurations.UPDATE_USER_URL + globals.currentUser.id.toString(), data, files);
    processUpodateUserResponse(responseData);
  }

  void processUpodateUserResponse(Map res) {
    if (res != null) {

      globals.currentUser = User.fromJson(res);
      Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
      Preferences.saveObject("profile", "0");
      _image = null;
      setState(() {
        build(context);
      });

    }
  }



  final GlobalKey<FormState> _formAddressKey = GlobalKey<FormState>();
  bool _autoValidateAddress = true;
  bool showMap = false;

  final adrs_name = TextEditingController();
  final adrs_line1 = TextEditingController();
  final adrs_line2 = TextEditingController();
  final adrs_landmark = TextEditingController();
  final adrs_disctric = TextEditingController();
  final adrs_city = TextEditingController();
  final adrs_postalcode = TextEditingController();

  String mapAddressTitle = "Set Location Map";

  bool isAdddressUpdate = false;
  void addressEnter(bool isNewAddress) {
    isAdddressUpdate = true;
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildAddressDialog(context, isNewAddress),
    );
  }

  Widget _buildAddressDialog(BuildContext context, bool isNewAddress) {
    if(isNewAddress) {
      singleAddress = Address(0, "", "", "",
          "", "", "", "", globals.currentUser.id, "");
    } else {
      if(singleAddress.name == null || singleAddress.name == "") {
        singleAddress = Address(singleAddress.id, globals.addressLocation.featureName, globals.addressLocation.subLocality, "",
            globals.addressLocation.subAdminArea, globals.addressLocation.locality, globals.addressLocation.postalCode, "", globals.currentUser.id, "");
      }
    }

    return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.location_on),
            Text(
              AppLocalizations.of(context)
                  .translate('address'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.my_location,
                                color: Configurations.themColor,
                                size: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                mapAddressTitle,
                                style:
                                TextStyle(color: Configurations.themColor),
                              )
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              if(showMap == true) {
                                showMap = false;
                                _markers.clear();
                                mapAddressTitle = AppLocalizations.of(context)
                                    .translate('txt_enter_location');
                              } else {

                                showMap = true;
                                mapAddressTitle = AppLocalizations.of(context)
                                    .translate('profile_txt_location');
//                                setCustomMapPin(pinLocationIcon).then((onValue) {
//                                  pinLocationIcon = onValue;
//                                });
                              }
                            });
                          },
                        ),

                        Visibility(child: mapBuild(setState),
                          visible: showMap,),

                        Visibility(
                            visible: !showMap,
                            child: Column(
                              children: <Widget>[
                                // Name
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate('address_placeholder'),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Configurations.themColor),
                                    ),
                                  ),cursorColor: Configurations.themColor,
                                  controller: (singleAddress.name == "")
                                      ? adrs_name : adrs_name ..text = singleAddress.name,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate('profile_txt_address');
                                    }
                                    return null;
                                  },
                                ),

                                Row(
                                  children: <Widget>[
                                    // Address Line 1
                                    Container(
                                      width: 100.0,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context)
                                              .translate('address1_placeholder'),
                                          labelStyle: TextStyle(color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Configurations.themColor),
                                          ),
                                        ),cursorColor: Configurations.themColor,
                                        controller: (singleAddress.address_line1 == "")
                                            ? adrs_line1 : adrs_line1 ..text = singleAddress.address_line1,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return AppLocalizations.of(context)
                                                .translate('profile_txt_address1');
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // Address Line 2
                                    Container(
                                      width: 100.0,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: AppLocalizations.of(context)
                                                .translate('address2_placeholder'),
                                            labelStyle: TextStyle(color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Configurations.themColor),
                                            ),
                                          ),cursorColor: Configurations.themColor,
                                          controller: (singleAddress.address_line2 == "") ? adrs_line2 : adrs_line2
                                            ..text = singleAddress.address_line2
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    // Landmark
                                    Container(
                                      width: 100.0,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: AppLocalizations.of(context)
                                                .translate('landmark_placeholder'),
                                          ),
                                          controller: (singleAddress.landmark == "") ? adrs_landmark : adrs_landmark
                                            ..text = singleAddress.landmark
                                      ),
                                    ),

                                    SizedBox(
                                      width: 10,
                                    ),

                                    // District
                                    Container(
                                      width: 100.0,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context)
                                              .translate('district_placeholder'),
                                          labelStyle: TextStyle(color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Configurations.themColor),
                                          ),
                                        ),cursorColor: Configurations.themColor,
                                        controller: (singleAddress.district == "") ?
                                        adrs_disctric : adrs_disctric
                                          ..text = singleAddress.district,
                                      ),
                                    )
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    // City
                                    Container(
                                      width: 100.0,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context)
                                              .translate('city_placeholder'),
                                          labelStyle: TextStyle(color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Configurations.themColor),
                                          ),
                                        ),cursorColor: Configurations.themColor,
                                        controller: (singleAddress.city == "") ?
                                        adrs_city : adrs_city
                                          ..text = singleAddress.city,
                                        //adrs_city,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return AppLocalizations.of(context)
                                                .translate('profile_txt_city');
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),

                                    // postal Code
                                    Container(
                                      width: 100.0,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context)
                                              .translate('postalcode_placeholder'),
                                          labelStyle: TextStyle(color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Configurations.themColor),
                                          ),
                                        ),cursorColor: Configurations.themColor,
                                        controller: (singleAddress.postal_code == "") ?
                                        adrs_postalcode : adrs_postalcode
                                          ..text = singleAddress.postal_code,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return AppLocalizations.of(context)
                                                .translate('profile_txt_postalcode');
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )),



                        ButtonTheme(
                          minWidth: 300.0,
                          child: RaisedButton(
                              color: Configurations.themColor,
                              textColor: Colors.white,
                              child: Text(
                                  AppLocalizations.of(context).translate('btn_save'),
                                  style: TextStyle(fontSize: 16.5)),
                              onPressed: () {
                                addressSave(isNewAddress, setState);
                              }),
                        ),
                      ],
                    ),
                    key: _formAddressKey,
                    autovalidate: _autoValidateAddress,
                  ),
                ),
              );
            }));
  }
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  static LatLng pinPosition = LatLng(globals.latitude, globals.longitude);

  // these are the minimum required values to set
  // the camera position
  CameraPosition initialLocation = CameraPosition(
      zoom: 16,
      bearing: 30,
      target: pinPosition
  );

  Completer<GoogleMapController> _controller = Completer();

  bool isMapAdrs = false;
  Widget  mapBuild(StateSetter setState) {
    setCustomMapPin(pinLocationIcon).then((onValue) {
      pinLocationIcon = onValue;
    });
    return Container(
      height: 400,
      width: 250,
      child: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(
                Marker(
                    markerId: MarkerId("User"),
                    position: pinPosition,
                    icon: pinLocationIcon
                )
            );
          });
        },

        onTap: (latLogn) {
          setState(() {
            getAddress(LatLng(latLogn.latitude, latLogn.longitude)).then((onValue) {
              globals.addressLocation = onValue;
              globals.latitude = latLogn.latitude;
              globals.longitude = latLogn.longitude;
              addressString = globals.addressLocation.addressLine;
              adrs_line1.text = globals.addressLocation.featureName;
              adrs_line2.text = globals.addressLocation.subLocality;
              adrs_disctric.text = globals.addressLocation.subAdminArea;
              adrs_city.text = globals.addressLocation.locality;
              adrs_postalcode.text = globals.addressLocation.postalCode;
              print("adrs_line1.text == ${adrs_line1.text}");
              isMapAdrs = true;
            });
            _markers.add(
                Marker(
                    markerId: MarkerId("User"),
                    position: latLogn,
                    icon: pinLocationIcon
                )
            );
          });
        },
      )
    );
  }

  void addressSave(bool isNewAddress, StateSetter setState) {
    _markers.clear();
    if(isMapAdrs == true) {
      print("isMapAdrs == $isMapAdrs");
      print("showMap == $showMap");
      setState(() {
        showMap = false;
        isMapAdrs = false;
        singleAddress = Address(0, adrs_line1.text, adrs_line2.text,
        "", adrs_disctric.text, adrs_city.text, adrs_postalcode.text, "", globals.currentUser.id, "");
        print("adrs_line1.text == ${adrs_line1.text}");
      });
    }
    else {
      showMap = false;
      if (_formAddressKey.currentState.validate()) {
        _formAddressKey.currentState.save();
        _autoValidateAddress = false;
        setState(() {
          if(isNewAddress) {
            AddAddress(setState);
            singleAddress = globals.currentUser.address[0];
          }
          else {
            print("OLD ADDESSS");
            addressString= adrs_name.text;

            addressString += "\n" + adrs_line1.text;
            if (adrs_line2.text.isNotEmpty) {
              addressString += "\n" + adrs_line2.text;
            }

            if (adrs_landmark.text.isNotEmpty) {
              addressString += "\n" + adrs_landmark.text;
            }
            addressString += "\n" +
                adrs_disctric.text +
                "\n" +
                adrs_city.text +
                "\n" +
                adrs_postalcode.text;
            print("addressString == $addressString");
            singleAddress = Address(singleAddress.id, adrs_line1.text, adrs_line2.text,
                adrs_landmark.text, adrs_disctric.text, adrs_city.text, adrs_postalcode.text, "", globals.currentUser.id, adrs_name.text);
            Navigator.of(context).pop();
          }
        });
      }
      else {
        print("ELEXC");
        setState(() {
          _autoValidateAddress = true;
        });
      }
    }

  }

  void AddAddress(StateSetter setState) {
    var addressData = new Map<String, dynamic>();
    addressData["name"] = adrs_name.text;
    addressData["address_line1"] = adrs_line1.text;
    addressData["address_line2"] = adrs_line2.text;
    addressData["user_id"] = globals.currentUser.id.toString();
    addressData["landmark"] = adrs_landmark.text;
    addressData["district"] = adrs_disctric.text;
    addressData["city"] = adrs_city.text;
    addressData["postal_code"] = adrs_postalcode.text;
    addressData["location"] = globals.latitude.toString() + ',' + globals.longitude.toString();
    apiCallAddAddress(addressData, setState);
  }

  void apiCallAddAddress(Map data, StateSetter setState) async {
    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, Configurations.ADD_USER_ADDRESS, data, true);
      processAddressResponse(syncUserResponse, setState);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processAddressResponse(Response res, StateSetter setState) {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("data::::::::$data");
        List addresses = data;
        setState(() {
          globals.currentUser.address = Address.processListOfAddress(addresses);
          print("ADDRESS LENT == ${globals.currentUser.address.length}");
          Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
          new Future<String>.delayed(new Duration(microseconds: 100), () => null)
              .then((String value) {
            Navigator.of(context).pop();
            build(context);
          });

        });
      } else {
        showInfoAlert(context, "Unknown error from server side");
      }
    } else {
      printLog("login response code is not 200");
      var data = json.decode(res.body);
      showInfoAlert(context, data['message']);
    }
  }



  List<String> languages = new List<String>();
  void _selecteEnglish(bool value) {
    setState(() {
      _english = value;
      if(languages.contains("English")) {
        languages.remove("English");
      } else {
        languages.add("English");
      }
    });
  }
  void _selecteArabic(bool value) {
    setState(() {
      _arabic = value;
      if(languages.contains("Arabic")) {
        languages.remove("Arabic");
      } else {
        languages.add("Arabic");
      }
    });
  }

  bool _english = false;
  bool _arabic = false;

  String addressListString(Address address) {

    String newAddressString = address.address_line1;
    if(address.address_line2 != "" && address.address_line2 != null) {
      newAddressString += ", " + address.address_line2;
    }

    if(address.landmark != "" && address.landmark != null) {
      newAddressString += ", " + address.landmark;
    }
    newAddressString += ", " + address.district
        + ", " + address.city + ", " + address.postal_code + ".";

    print("NEW addressString == $newAddressString");
    return newAddressString;
  }

  Widget setRichText()
  {
    int AddressLength =  (globals.currentUser.address == null) ? 0 : globals.currentUser.address.length;
    return Container(
      padding: EdgeInsets.only(left:15, right: 15),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  addressEnter(true);
                  },
                icon: Icon(Icons.add),
              )
          ),
          if(AddressLength > 0)
          Container(
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Configurations.themColor,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 100,
              child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(alignment:Alignment.center,
                          child: ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(globals.currentUser.address[index].name),
                            subtitle: Text(addressListString(globals.currentUser.address[index])),
                          ),
                        ),
                      ],
                    );
                  },
                itemCount: AddressLength,
              )
          )
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
      case 'Address' : return setRichText();

    }
  }

  String dropdownvalue = globals.currentUser.gender;

  String gender= "";
  String address = "";

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(width: 0.5, color: Color(0xFFFF7F7F7F)),
        bottom: BorderSide(width: 0.5, color: Color(0xFFFF7F7F7F)),
      ),
    );
  }
  Widget setDropDown() {
    return

      Container(
      decoration: myBoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Row(
          children: [
            Icon((dropdownvalue == "Male")
                ? Ionicons.ios_male
                : Ionicons.ios_female),

            SizedBox(
              width: 20,
            ),
            Expanded(
              child: DropdownButton<String>(
                underline: SizedBox(),

                isExpanded: true,
                value: dropdownvalue,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Configurations.themColor,
                ),
                items: <String>['Male', 'Female'
                ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownvalue = newValue;
                    gender = newValue;
                  });},
              ),)
          ],
        ),
      ),
    );

  }
}