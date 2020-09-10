import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:geopoint_location/geopoint_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jam/models/service.dart';
import 'package:jam/screens/service_selection.dart';
import 'package:tree_view/tree_view.dart';

import 'package:flutter/cupertino.dart';

//import 'package:flutter/mdart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:http/http.dart' as http;
import 'package:jam/app_localizations.dart';
import 'package:jam/globals.dart' as globals;
import 'package:flutter/src/cupertino/date_picker.dart';

class InitialProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: InitialProfilePage(
        title: AppLocalizations.of(context).translate('profile_txt_title'),
      ),
    );
  }
}

class InitialProfilePage extends StatefulWidget {
  InitialProfilePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InitialProfilePageState createState() => _InitialProfilePageState();
}

class _InitialProfilePageState extends State<InitialProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<DropdownMenuItem<String>> _dropDownTypes;
  List _lstType = ["Male", "Female"];
  String dropdownvalue;
  File _image;
  List<Service> listofServices;
  bool isLoadin = true;
  FocusNode focus_fname, focus_lname, focus_phnno, focus_mail, focus_gender, focus_language, focus_adress,focus_radius;
  @override
  void initState() {
    super.initState();
    focus_fname = FocusNode();
    focus_lname = FocusNode();
    focus_phnno = FocusNode();
    focus_mail = FocusNode();
    focus_gender = FocusNode();
    focus_language = FocusNode();
    focus_adress = FocusNode();
    focus_radius = FocusNode();
    globals.context = context;
    setState(() {
//      if (globals.currentUser.roles[0].slug == "provider")
//        print("provider");
//      else
//        print("RE INIT");
      if(globals.customFirstName != null) {
        print(globals.customFirstName);
        firstName = globals.customFirstName;
      } else {
        firstName = globals.currentUser.first_name;
      }

      lastName = globals.currentUser.last_name;
      phoneNumber = globals.currentUser.contact;

      print("languages ${globals.currentUser.languages}");
      if(globals.currentUser.languages != null) {
      var lang = globals.currentUser.languages;
       if (lang.contains("Arabic"))
         _arabic = true;
       if(lang.contains("English"))
         _english = true;
      }
      if(globals.currentUser.gender != null){
        dropdownvalue =globals.currentUser.gender;
        print("gender ${dropdownvalue}");
      }



      if(phoneNumber == "" || phoneNumber == null) {
        print("no phone");
        phoneNumber = globals.customContact;
      } else {
        print("yes phone ${phoneNumber}");


      }

      print("yes ${ServiceSelectionUIPageState.serviceNamesString}");
      email = globals.currentUser.email;
      print(globals.currentUser.toString());


      if(globals.customLanguage != null) {

        globals.customLanguage.forEach((element) {
          if(element == 'English') {
            _english = true;
            language.add("English");
          }

          if(element == 'Arabic') {
            _arabic = true;
            language.add("Arabic");
          }
        });
      }

    });






//    if(globals.customLanguage != null) {
//      language.addAll(globals.customLanguage);
//    }
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    if(globals.customGender !=  null) {
     dropdownvalue = globals.customGender;
     printLog("gender"+globals.customGender.toString());
    } else {
      dropdownvalue = _dropDownTypes[0].value;
    }

    imageUrl = globals.currentUser.image;
    if(globals.customImage != null) {
      _image = globals.customImage;
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focus_fname.dispose();
    focus_lname.dispose();
    focus_phnno.dispose();
    focus_mail.dispose();
    focus_gender.dispose();
    focus_language.dispose();
    focus_adress.dispose();
    focus_radius.dispose();

  }

  void processServiceResponse(Response res) {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print(data);
        List roles = data;
        setState(() {
          listofServices = Service.processServices(roles);
          isLoadin = false;
        });
      } else {
        setState(() {
          isLoadin = false;
        });
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: profileUI(),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final imageSrc = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text( AppLocalizations.of(context)
            .translate('profile_txt_img')),
        actions: <Widget>[
          MaterialButton(
            child: Text( AppLocalizations.of(context)
                .translate('profile_camera')),
            onPressed: () => Navigator.pop(
              context,
              ImageSource.camera,
            ),
          ),
          MaterialButton(
            child: Text( AppLocalizations.of(context)
                .translate('profile_gallery')),
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
          globals.customImage = _image;
        });
      }
    }
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 3.3,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30),
          if (imageUrl == null) _buildProfileImage(),
          if (imageUrl != null) _buildProfileImageForSocial(),
          SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).translate('profile_txt_img'),
            style: TextStyle(color: Colors.grey),
          ),
          Text(AppLocalizations.of(context).translate('profile_txt_img2'),
              style: TextStyle(color: Colors.white70)),
        ],
      ),
      decoration: BoxDecoration(
        color: Configurations.themColor,
      ),
    );
  }

  Widget _buildProfileImageForSocial() {
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
          image: DecorationImage(
            image: (imageUrl == null) ? getImage() : NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Configurations.themColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  AssetImage setImgPlaceholder() {

    return AssetImage("assets/images/BG-1x.jpg");
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        child: GestureDetector(
          onTap: () {
            getImage();
          }, // handle your image tap here
        ),
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (_image == null) ? setImgPlaceholder() : FileImage(_image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Configurations.themColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  String addressString = "";
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  String email = "";
  String imageUrl = "";

  final prfl_fname = TextEditingController();
  final prfl_email = TextEditingController();
  final prfl_lname = TextEditingController();
  final prfl_servcerds = TextEditingController();
  final prfl_phone = TextEditingController();

  bool _english = false;
  bool _arabic = false;

  Widget profileUI() {
    final double circleRadius = 100.0;
    final double circleBorderWidth = 8.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        Container(
          height: 50,
          color: Colors.grey[800],
        ),

        Container(
          width: 400,
          height: 100,
          child: Image.asset("assets/images/jamLogoWhite.png", fit: BoxFit.contain, height: 50
            ,width: 18,
          ),
          color: Colors.grey[800],
        ),

        Stack(
          alignment: Alignment.topCenter,

          children: <Widget>[
            Container(color: Colors.grey[800], height: 150,),





            Padding(
              padding: EdgeInsets.only(top: circleRadius / 2.0, left: 10, right: 10),


              child: Container(
//                  color: Colors.transparent,

                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular( 16.0)
                    )
                ),


                child: Column(
                  children: <Widget>[

                    Column(
                      children: <Widget>[

                        Material( elevation: 5.0,
                          shadowColor: Colors.grey,
                          child: Column(
                            children: <Widget>[

                              // First Name
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20,top: 55),
                                child: TextFormField(
                                  focusNode: focus_fname,
                                  controller: (firstName == "") ? prfl_fname : prfl_fname
                                    ..text = firstName,
                                  decoration: InputDecoration(
                                    //                          prefixIcon: Icon(Icons.person,
                                    //                            textDirection: TextDirection.rtl,
                                    //                          ),
                                    //                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Configurations.themColor,
                                          width: 1,
                                        ),
                                      ),
                                      labelText: AppLocalizations.of(context)
                                          .translate('signin_firstname_placeholder'),

                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Configurations.themColor),
                                      ),
                                      hasFloatingPlaceholder: false),
                                  cursorColor: Configurations.themColor,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate('signup_txt_enterlast');
                                    }
                                    return null;
                                  },
                                  onChanged: setFirstName,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              // Last Name
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: TextFormField(
                                  focusNode: focus_lname,
                                  controller: (lastName == "") ? prfl_lname : prfl_lname
                                    ..text = lastName,
                                  decoration: InputDecoration(
                                    //                        prefixIcon: Icon(
                                    //                          Icons.person,
                                    //                        ),
                                    //                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Configurations.themColor,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: AppLocalizations.of(context)
                                        .translate('signin_lastname_placeholder'),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Configurations.themColor),
                                    ),
                                    hasFloatingPlaceholder: false,
                                  ),
                                  cursorColor: Configurations.themColor,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate('signup_txt_enterlast');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              // Mobile
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: TextFormField(
                                  focusNode: focus_phnno,
                                  controller: (phoneNumber == "") ? prfl_phone : prfl_phone
                                    ..text = phoneNumber,
                                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                  onChanged: setContact,
                                  decoration: InputDecoration(
                                    suffixIcon:
                                    Icon(Icons.phone, color: Colors.grey,textDirection: TextDirection.rtl),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Configurations.themColor,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: AppLocalizations.of(context)
                                        .translate('signin_phone_placeholder'),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Configurations.themColor),
                                    ),
                                    hasFloatingPlaceholder: false,

                                  ),cursorColor: Configurations.themColor,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              // Email
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: TextFormField(focusNode: focus_mail,
                                  controller: (email == "") ? prfl_email : prfl_email
                                    ..text = email,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.email,color: Colors.grey,
                                    ),
                                    //                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Configurations.themColor,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: AppLocalizations.of(context)
                                        .translate('profile_email_placeholder'),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Configurations.themColor),
                                    ),
                                    hasFloatingPlaceholder: false,
                                  ),cursorColor: Configurations.themColor,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate('profile_txt_enteremail');
                                    }
                                    return validateEmail(value);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              // Gender
                              setDropDown(),
                              SizedBox(
                                height: 20,
                              ),

                              // languages
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),

                                child: Container(
                                  decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
                                      border: Border.all(width: 0.9,color: Configurations.themColor)),
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 4,),
                                      Icon(Icons.language),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("English"),
                                      Checkbox(
                                        value: _english, onChanged: _selecteEnglish , focusNode: focus_language,),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Arabic"),
                                      Checkbox(value: _arabic, onChanged: _selecteArabic, focusNode: focus_language,),
                                    ],
                                  ),
                                ),
                              ),

                              if (globals.currentUser.roles[0].slug == "provider")
                                SizedBox(
                                  height: 20,
                                ),
                              // Service Radius
                              if (globals.currentUser.roles[0].slug == "provider")
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: TextFormField(
                                    focusNode: focus_radius,
                                    controller: (globals.customRadius == "") ? prfl_servcerds : prfl_servcerds
                                      ..text = globals.customRadius,
                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.location_searching,color: Colors.grey
                                      ),

                                      //                        suffix: Text("KM"),
                                      suffixText: AppLocalizations.of(context).translate('km'),
                                      //                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Configurations.themColor,
                                          width: 1,
                                        ),
                                      ),
                                      labelText: AppLocalizations.of(context)
                                          .translate('init_radius'),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Configurations.themColor),
                                      ),
                                      hasFloatingPlaceholder: false,
                                    ), cursorColor: Configurations.themColor,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return AppLocalizations.of(context).translate('rad');
                                      }
                                      return null;
                                    },

                                    onChanged: setRadius,
                                  ),
                                ),
                              if (globals.currentUser.roles[0].slug == "provider")
                                SizedBox(
                                  height: 20,
                                ),

                              // SERVICE
                              if (globals.currentUser.roles[0].slug == "provider")
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
                                        border: Border.all(width: 0.9,color: Configurations.themColor)),

                                    child: ListTile(
                                      onTap: enterServices,
                                      leading: Icon(Icons.work),
                                      title: Text(
                                          (ServiceSelectionUIPageState.serviceNamesString == "")
                                              ? AppLocalizations.of(context)
                                              .translate('init_services')
                                              : AppLocalizations.of(context)
                                              .translate('init_your_services')),
                                      subtitle:
                                      Text((ServiceSelectionUIPageState.serviceNamesString == null || ServiceSelectionUIPageState.serviceNamesString == "") ? "" : ServiceSelectionUIPageState.serviceNamesString),
                                    ),
                                  ),
                                ),

                              // ADDRESS
                              Padding(
                                padding: EdgeInsets.only(left: 20,top: 20,bottom: 20, right: 20),
                                child: Container(
                                  decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
                                      border: Border.all(width: 0.9,color: Configurations.themColor)),


                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(

                                        onTap: addressEnter,
                                        leading: Icon(Icons.location_on),
                                        title: Text((adrs_name.text == "")
                                            ? AppLocalizations.of(context).translate('address')
                                            : adrs_name.text),
                                        subtitle: Text(addressString),
                                      ),
                                      ButtonBar(

                                        children: <Widget>[
                                          FlatButton( focusNode: focus_adress,
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
                                              addressEnter();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 7,),

                        RaisedButton(
                            color: Configurations.themColor,
                            textColor: Colors.white,
                            child: Text(
                                AppLocalizations.of(context).translate('btn_save'),
                                style: TextStyle(fontSize: 16.5)),
                            onPressed: () {

                              print("api call");
                              initialProfileCall();
//                  _validateInputs();
                            }),

                        if (globals.currentUser.roles[0].slug != "provider")
                        FlatButton(

                            child: Text(AppLocalizations.of(context)
                                .translate('init_skip'),
                              textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),
                            onPressed: () {
                              Preferences.saveObject("profile", "0");
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                                      (route) => false);

//                              Navigator.pushReplacement(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) => HomeScreen(),
//                                  ));
                            }),

                        SizedBox(height: 120,),
                      ],
                    ),


                  ],
                ),
              ),
            ),



            Positioned(child: new Image.asset("assets/images/bottomSignup.png",
              height: 130.0, width: double.infinity, fit: BoxFit.fill, ),
              bottom: 0,
              left: 0,
              right: 0,
            ),







//    Padding(padding: EdgeInsets.only(top: ),
//              child: ,),




            Container(
              width: circleRadius,
              height: circleRadius,
              decoration:
              ShapeDecoration(shape: CircleBorder(), color: Colors.white),
              child: Stack(
                children: [
                  if (imageUrl == null) _buildProfileImage(),
                  if (imageUrl != null) _buildProfileImageForSocial(),
                ],
              ),
            ),



          ],
        ),

      ],
    );
  }

  void setContact (String str) {
    globals.customContact = str;
  }
  void setFirstName(String str) {
    globals.customFirstName = str;
  }

  void setRadius(String str) {
    globals.customRadius = str;
  }

  List<String> language = new List<String>();
  void initialProfileCall() async {
    printLog("test = ${ServiceSelectionUIPageState.selectedServices}");
    if (ServiceSelectionUIPageState.selectedServices == null &&
        globals.currentUser.roles[0].slug == "provider") {
      print("provider");

          enterServices();
    }
//    else if(ServiceSelectionUIPageState.selectedServices.length == 0 || globals.currentUser.roles[0].slug == "provider") {
//      enterServices();
//    }
    else if (_autoValidateAddress) {
      print("address");
      addressEnter();
    } else
      {
      print("LANAGNE CHECH");
      if (language.length == 0) {
        print("no language");
        showInfoAlert(context, AppLocalizations.of(context).translate('lang'));
      } else {
        print("DONe");
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          _autoValidate = false;
          setState(() {
            var data = new Map<String, String>();
            data["id"] = globals.currentUser.id.toString();
            data["first_name"] = prfl_fname.text;
            data["last_name"] = prfl_lname.text;

            data["contact"] = prfl_phone.text;
            data["gender"] = dropdownvalue;
            data["email"] = prfl_email.text;
            String lang = language.join(',');
            print("lang ${globals.currentUser.roles[0].slug}");
            data["languages"] = lang;
            var addressData = new Map<String, dynamic>();
            addressData["name"] = adrs_name.text;
            addressData["address_line1"] = adrs_line1.text;
            addressData["address_line2"] = adrs_line2.text;
            addressData["landmark"] = adrs_landmark.text;
            addressData["district"] = adrs_disctric.text;
            addressData["city"] = adrs_city.text;
            addressData["postal_code"] = adrs_postalcode.text;
            addressData["location"] = globals.latitude.toString() +
                ',' +
                globals.longitude.toString();

            data["address"] = jsonEncode(addressData);

            if (globals.currentUser.roles[0].slug == "provider") {
              String rawJson =
                  jsonEncode(ServiceSelectionUIPageState.selectedServices);
              print(rawJson);
              data["services"] = rawJson;
              data["service_radius"] = prfl_servcerds.text;
            }
            printLog(data);
            apiCall(data);
          });
        } else {
          setState(() {
            _autoValidate = true;
          });
        }
      }
    }
  }

  void apiCall(Map data) async {
    List<http.MultipartFile> files = new List<http.MultipartFile>();

    print('img==== ${data}');
    if (_image != null) {
 //     print('COME FOR API IMAGE');
//    files.add(await http.MultipartFile.fromPath('profile_photo', _image.path));
      files.add(http.MultipartFile.fromBytes(
          'profile_photo', _image.readAsBytesSync(),
          filename: _image.path.split("/").last));
      printLog(files.length);
    }

    HttpClient httpClient = new HttpClient();
    Map responseData = await httpClient.postMultipartRequest(
        context, Configurations.PROFILE_URL, data, files);
    //Request(context, Configurations.PROFILE_URL, data);
    processProfileResponse(responseData);
  }

  void processProfileResponse(Map res) {
    if (res != null) {
      globals.currentUser = User.fromJson(res);
      print("come for response ==  ${globals.currentUser.toJson()}");
      Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
      Preferences.saveObject("profile", "0");
      if(ServiceSelectionUIPageState.selectedServices != null) {
        ServiceSelectionUIPageState.selectedServices.clear();
        ServiceSelectionUIPageState.serviceNamesString = "";
      }

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
              (route) => false);

//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//            builder: (context) => HomeScreen(),
//          ));
    }
  }

  final GlobalKey<FormState> _formAddressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formServiceKey = GlobalKey<FormState>();
  bool _autoValidateAddress = true;
  bool _autoValidateService = true;
  bool showMap = false;

  final adrs_name = TextEditingController();
  final adrs_line1 = TextEditingController();
  final adrs_line2 = TextEditingController();
  final adrs_landmark = TextEditingController();
  final adrs_disctric = TextEditingController();
  final adrs_city = TextEditingController();
  final adrs_postalcode = TextEditingController();

  String mapAddressTitle = "Set Location Map";
  Widget _buildAddressDialog(BuildContext context) {
    print("showMap $showMap ::: ${globals.addressLocation.thoroughfare}");
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
                color: Configurations.themColor,
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
                            AppLocalizations.of(context)
                                .translate('profile_txt_location'),
                            style: TextStyle(color: Configurations.themColor),
                          )
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          if (showMap == true) {
                            showMap = false;
                            _markers.clear();
                            mapAddressTitle = AppLocalizations.of(context).translate('profile_txt_location');
                          } else {
                            showMap = true;
                            mapAddressTitle = AppLocalizations.of(context).translate('txt_enter_location');
                            setCustomMapPin(pinLocationIcon).then((onValue) {
                              pinLocationIcon = onValue;
                            });
                          }
                          print("showMap === $showMap");
                        });
                      },
                    ),
                    Visibility(
                      child: mapBuild(setState),
                      visible: showMap,
                    ),
                    Visibility(
                        visible: !showMap,
                        child: Column(
                          children: <Widget>[
                            // Name
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('address_placeholder'),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Configurations.themColor),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                    color: Configurations.themColor, width: 1,  ), ),
                                ),cursorColor: Configurations.themColor,
                                controller: adrs_name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .translate('profile_txt_address');
                                  }
                                  return null;
                                },
                              ),
                            ),



                                // Address Line 1
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate('address1_placeholder'),
                                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                        color: Configurations.themColor, width: 1,  ), ),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Configurations.themColor),
                                      ),
                                    ),cursorColor: Configurations.themColor,
                                    controller: (globals
                                                .addressLocation.featureName ==
                                            "")
                                        ? adrs_line1
                                        : adrs_line1
                                      ..text =
                                          globals.addressLocation.featureName,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return AppLocalizations.of(context)
                                            .translate('profile_txt_address1');
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Address Line 2
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)
                                            .translate('address2_placeholder'),
                                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                          color: Configurations.themColor, width: 1,  ), ),
                                        labelStyle: TextStyle(color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Configurations.themColor),
                                        ),
                                      ),cursorColor: Configurations.themColor,
                                      controller: (globals.addressLocation
                                                  .subLocality ==
                                              "")
                                          ? adrs_line2
                                          : adrs_line2
                                        ..text = globals
                                            .addressLocation.subLocality),
                                ),





                                // Landmark
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)
                                            .translate('landmark_placeholder'),
                                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                          color: Configurations.themColor, width: 1,  ), ),
                                        labelStyle: TextStyle(color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Configurations.themColor),
                                        ),
                                      ),cursorColor: Configurations.themColor,
                                      controller: adrs_landmark),
                                ),



                                // District
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate('district_placeholder'),
                                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                        color: Configurations.themColor, width: 1,  ), ),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Configurations.themColor),
                                      ),
                                    ),cursorColor: Configurations.themColor,
                                    controller: (globals
                                                .addressLocation.subAdminArea ==
                                            "")
                                        ? adrs_disctric
                                        : adrs_disctric
                                      ..text =
                                          globals.addressLocation.subAdminArea,
                                  ),
                                ),




                                // City
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate('city_placeholder'),
                                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                        color: Configurations.themColor, width: 1,  ), ),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Configurations.themColor),
                                      ),
                                    ),cursorColor: Configurations.themColor,
                                    controller:
                                        (globals.addressLocation.locality == "")
                                            ? adrs_city
                                            : adrs_city
                                          ..text =
                                              globals.addressLocation.locality,
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



                                // postal Code
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate('postalcode_placeholder'),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Configurations.themColor),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                        color: Configurations.themColor, width: 1,  ), ),
                                    ),cursorColor: Configurations.themColor,
                                    controller: (globals
                                                .addressLocation.postalCode ==
                                            "")
                                        ? adrs_postalcode
                                        : adrs_postalcode
                                      ..text =
                                          globals.addressLocation.postalCode,
                                    //adrs_postalcode,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return AppLocalizations.of(context)
                                            .translate(
                                                'profile_txt_postalcode');
                                      }
                                      return null;
                                    },
                                  ),
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
                              AppLocalizations.of(context)
                                  .translate('btn_save'),
                              style: TextStyle(fontSize: 16.5)),
                          onPressed: () {
                            addressSave();
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
  CameraPosition initialLocation =
      CameraPosition(zoom: 16, bearing: 30, target: pinPosition);

  Completer<GoogleMapController> _controller = Completer();

  Widget mapBuild(StateSetter setState) {
    setCustomMapPin(pinLocationIcon).then((onValue) {
      pinLocationIcon = onValue;
    });
    return Container(
      height: 400,
      width: 250,
      child: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
//        mapType: MapType.hybrid,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          print("ADDDRESS::: ${controller}");
          _controller.complete(controller);

//          getAddress(globals.location);
          setState(() {
            _markers.add(Marker(
                markerId: MarkerId("User"),
                position: pinPosition,
                icon: pinLocationIcon));
          });
        },

        onTap: (latLogn) {
          print("latLogn::: $latLogn");

          setState(() {
            getAddress(LatLng(latLogn.latitude, latLogn.longitude))
                .then((onValue) {
              globals.longitude = latLogn.longitude;
              globals.latitude = latLogn.latitude;
              globals.addressLocation = onValue;
              addressString = globals.addressLocation.addressLine;
            });

            _markers.add(Marker(
                markerId: MarkerId("User"),
                position: latLogn,
                icon: pinLocationIcon));
          });
        },
      ),
    );
  }

  void addressSave() {
    showMap = false;
    if (_formAddressKey.currentState.validate()) {
      _formAddressKey.currentState.save();
      _autoValidateAddress = false;

      setState(() {
        print(adrs_line1.text);
        print(adrs_line2.text);
        print(adrs_landmark.text);

        addressString = adrs_line1.text;
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
      });
      Navigator.of(context).pop();
    } else {
      setState(() {
        _autoValidateAddress = true;
      });
    }
  }

  void addressEnter() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildAddressDialog(context),
    );
  }

  Widget setDropDown() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
      decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
      border: Border.all(width: 0.9,color: Configurations.themColor)),

        child: Row(
          children: [
            SizedBox(width: 4,),
            Icon((dropdownvalue == "Male")
                ? Ionicons.ios_male
                : Ionicons.ios_female),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: DropdownButton(
                focusNode: focus_gender,
                  underline: SizedBox(),
                  isExpanded: true,
                  value: dropdownvalue,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Configurations.themColor,
                  ),
                  items: _dropDownTypes,
                  onChanged: changedDropDownItem),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(
      List reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key) {
      items.add(DropdownMenuItem(value: key, child: Text(key)));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      dropdownvalue = selectedItem;
      globals.customGender = dropdownvalue;
    });
  }

  void enterServices() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ServiceSelectionUIPage()));
//    showDialog(
//      context: context,
//      builder: (BuildContext context) => setServiceListVendor(context),
//    );
  }

  bool _value1 = false;

  void _value1Changed(bool value) => setState(() => _value1 = value);

  void _selecteEnglish(bool value) {
    setState(() {
      lastName = prfl_lname.text;
      firstName = prfl_fname.text;
      _english = value;
      if (language.contains("English")) {
        language.remove("English");
      } else {
        language.add("English");

      }

      if(globals.customLanguage != null ) {
        if (globals.customLanguage.contains("English")) {
          globals.customLanguage.remove("English");
        } else {
          globals.customLanguage.add("English");
        }
      } else {
        globals.customLanguage = new List<String>();
        globals.customLanguage.add("English");
      }


      print("language :: ${language} $value");
    });
  } // => setState(() => );

  void _selecteArabic(bool value) {
    setState(() {
      _arabic = value;
      lastName = prfl_lname.text;
      firstName = prfl_fname.text;
      if (language.contains("Arabic")) {
        language.remove("Arabic");
      } else {
        language.add("Arabic");
      }


      if(globals.customLanguage != null) {
        if (globals.customLanguage.contains("Arabic")) {
          globals.customLanguage.remove("Arabic");
        } else {
          globals.customLanguage.add("Arabic");
        }
      } else {
        globals.customLanguage = new List<String>();
        globals.customLanguage.add("Arabic");
      }

    });
  }

  bool Value = false;

  Duration initialtimer = new Duration();

  Widget setServiceListVendor(BuildContext context) {
    if (!isLoadin)
      return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.work),
              Text(
                "SERVICES",
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
                child: Column(children: <Widget>[
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: listOfCards(setState),
                      ),
                    ),
                    height: 400,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    minWidth: 300.0,
                    child: RaisedButton(
                        color: Configurations.themColor,
                        textColor: Colors.white,
                        child: Text(
                            AppLocalizations.of(context).translate('btn_save'),
                            style: TextStyle(fontSize: 16.5)),
                        onPressed: () {
                          serviceSave();
                        }),
                  ),
                ]),
              ),
            );
          }));
  }

  List<Service> selectedListOfService = new List<Service>();
  List<int> selectedListOfId = new List<int>();

  void serviceSave() {
//    serviceNamesString = "";
//    if (_formServiceKey.currentState.validate()) {
//      _formServiceKey.currentState.save();
    setState(() {
      print(selectedListOfService);
      print(selectedListOfId);

//        print(adrs_line2.text);
//        print(adrs_landmark.text);
//
//        addressString = adrs_line1.text;
//        if (adrs_line2.text.isNotEmpty) {
//          addressString += "\n" + adrs_line2.text;
//        }
//
//        if (adrs_landmark.text.isNotEmpty) {
//          addressString += "\n" + adrs_landmark.text;
//        }
//        addressString += "\n" +
//            adrs_disctric.text +
//            "\n" +
//            adrs_city.text +
//            "\n" +
//            adrs_postalcode.text;
    });
    Navigator.of(context).pop();
//    } else {
////      setState(() {
////        _autoValidateAddress = true;
////      });
//    }
  }

  List<Widget> listOfCards(StateSetter setState) {
    List<Widget> list = new List();
    for (int orderCount = 0; orderCount < listofServices.length; orderCount++) {
      listofServices[orderCount].isSelected = true;
      listofServices[orderCount].index = orderCount;
      list.add(SetupCard(listofServices[orderCount], setState));
    }
    return list;
  }

  // resultHolder = 'Checkbox is UN-CHECKED';

  Widget SetupCard(Service service, StateSetter setState) {
    return Card(
      margin: EdgeInsets.fromLTRB(0.5, 5, 0.5, 5),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: (selectedListOfService.contains(service)) ? true : false,
            onChanged: (bool value) {
              printLog(value);

              setState(() {
                service.isSelected = value;
                if (selectedListOfService.contains(service)) {
                  selectedListOfService.remove(service);
                  selectedListOfId.remove(service.id);
                } else {
                  selectedListOfService.add(service);
                  selectedListOfId.add(service.id);
                }

//                listofServices.insert(service.index, service);
              });
              printLog(service.isSelected);
              printLog(selectedListOfService);
            },
          ),
          Container(
            padding: EdgeInsets.all(2),
            child: Image.network(
              service.icon_image,
              height: 40.0,
              width: 40.0,
              fit: BoxFit.contain,
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Text(
                service.name,
                maxLines: 3,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }

/*  */
}
