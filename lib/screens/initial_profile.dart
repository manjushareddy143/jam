
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class InitialProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: InitialProfilePage(title:  AppLocalizations.of(context).translate('profile_txt_title'),),
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
  List _lstType = ["Male"
    ,"Female"];
  String dropdownvalue;
  File _image;
  String user_id;

  @override
  void initState() {
    super.initState();
    setProfile();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    dropdownvalue = _dropDownTypes[0].value;
  }

  void setProfile() async  {
    await Preferences.readObject("user").then((onValue) async {
      var userdata = json.decode(onValue);
      printLog('userdata');
      printLog(userdata);
      User user = User.fromJson(userdata);
      user_id = user.id.toString();
      setState(() {
        firstName = user.first_name;
        phoneNumber = user.contact;
        email = user.email;
        imageUrl =  user.image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: profileUI(),
        ),
      ),
    );
  }

  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
            imageQuality: 50,
        );
    setState(() {
      if(image != null) {
        imageUrl = null;
      }
      _image = image;
      print("IMAGE:::::::::: $_image");
    });
  }


  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height /3.4,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30),
          if(imageUrl == null)
            _buildProfileImage(),
          if(imageUrl != null)
            _buildProfileImageForSocial(),

          SizedBox(height: 10),
          Text(AppLocalizations.of(context).translate('profile_txt_img'), style: TextStyle(color: Colors.white70),),
          Text(AppLocalizations.of(context).translate('profile_txt_img2'), style: TextStyle(color: Colors.white70)),
        ],
      ),
      decoration: BoxDecoration(
        color: Configurations.themColor,
      ),
    );
  }

  Widget _buildProfileImageForSocial() {
    print("IMG");
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
        decoration:
        BoxDecoration(
          image: DecorationImage(
            image: (imageUrl == null) ? setImgPlaceholder() : NetworkImage(imageUrl),
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

  AssetImage setImgPlaceholder() {
    return AssetImage("assets/images/BG-1x.jpg");
  }

  Widget _buildProfileImage() {
    print("NO DATA");
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
        decoration:
        BoxDecoration(
          image: DecorationImage(
            image: (_image == null) ? setImgPlaceholder() : FileImage(_image),
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

  String addressString = "";
  String firstName = "";
  String phoneNumber = "";
  String email = "";
  String imageUrl = "";

  final prfl_fname =TextEditingController();
  final prfl_email =TextEditingController();
  Widget profileUI() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding (padding: EdgeInsets.fromLTRB(15, 30, 0, 10),
          child:
          Text( AppLocalizations.of(context).translate('profile_txt_title'), style: TextStyle(color: Colors.black, fontSize: 20),)
            ,),

          _buildCoverImage(MediaQuery.of(context).size),

//          SizedBox(height: 10),
          
          Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            children: <Widget>[

              // First Name
              Material(
                elevation: 5.0,shadowColor: Colors.grey,
                child: TextFormField(
                  controller: (firstName == "") ? prfl_fname : prfl_fname..text = firstName,
                  decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, textDirection: TextDirection.rtl,),
//                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: AppLocalizations.of(context).translate('signin_firstname_placeholder'),
                    hasFloatingPlaceholder: false
                  ),
                  validator: (value){
                    if (value.isEmpty) {
                      return AppLocalizations.of(context).translate('profile_txt_enterfirstname');
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20,),

              // Mobile
              Material(
                elevation: 5.0,shadowColor: Colors.grey,
                child: TextFormField(
                  enabled: false,
                  controller: TextEditingController()..text = phoneNumber,
                  decoration: InputDecoration(
//                    isDense: true,
                    prefixIcon: Icon(Icons.phone,textDirection: TextDirection.rtl),
//                    contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: AppLocalizations.of(context).translate('signin_phone_placeholder'),
                  hasFloatingPlaceholder: false,
                    ),
                ),
              ),
              SizedBox(height: 20,),

              // Email
              Material(
                elevation: 5.0,shadowColor: Colors.grey,
                child: TextFormField(
                  controller: (prfl_email == "") ? prfl_email : prfl_email..text = email,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email,),
//                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: AppLocalizations.of(context).translate('profile_email_placeholder'),
                    hasFloatingPlaceholder: false,
                  ),
                  validator: (value){
                    if (value.isEmpty) {
                      return AppLocalizations.of(context).translate('profile_txt_enteremail');
                    }
                    return validateEmail(value);
                  },
                ),
              ),
              SizedBox(height: 20,),

              // Gender
              setDropDown(),
            ],
          ),
          ),
        /*setServiceListVendor(),
          Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Card(
              elevation: 5.0,
              child: ListTile(
                onTap: enterServices,
                leading: Icon(Icons.work),
                title: Text((adrs_name.text == "") ?  "Click to select SERVICES" : adrs_name.text),
                subtitle: Text(addressString),
              ),
            ),
          ), */


          // ADDRESS
          Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Card(
            elevation: 5.0,
            child: Column(
                mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                 onTap: addressEnter,
                  leading: Icon(Icons.location_on),
                  title: Text((adrs_name.text == "") ?  AppLocalizations.of(context).translate('address') : adrs_name.text),
                  subtitle: Text(addressString),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.my_location, color: Configurations.themColor, size: 15,),
                          SizedBox(width: 10,),
                          Text(AppLocalizations.of(context).translate('profile_txt_location'), style: TextStyle(color: Configurations.themColor),)
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



          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width - 20,
            child:  RaisedButton(
                color: Configurations.themColor,
                textColor: Colors.white,
                child:  Text(
                    AppLocalizations.of(context).translate('btn_save'),
                    style: TextStyle(fontSize: 16.5)
                ),
                onPressed: () {
                  print("api call");
                  initialProfileCall();
//                  _validateInputs();
                }
            ),
          )


        ],
      )
    );
  }

  void initialProfileCall() async {
    if(_autoValidateAddress) {
      addressEnter();
    } else {
      if(_image == null && imageUrl == null) { //||
        showInfoAlert(context, AppLocalizations.of(context).translate('profile_txt_selectimg'));
      } else {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        _autoValidate = false;
        setState(() {
          var data = new Map<String, String>();
          data["id"] = user_id;
          data["first_name"] = prfl_fname.text;
          data["gender"] = dropdownvalue;
          data["email"] =prfl_email.text;

          var addressData = new Map<String, dynamic>();
          addressData["name"] = adrs_name.text;
          addressData["address_line1"] = adrs_line1.text;
          addressData["address_line2"] = adrs_line2.text;
          addressData["landmark"] = adrs_landmark.text;
          addressData["district"] = adrs_disctric.text;
          addressData["city"] = adrs_city.text;
          addressData["postal_code"] = adrs_postalcode.text;
          data["address"] = jsonEncode(addressData);

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

    if(_image != null) {
      print('COME FOR API IMAGE');
//    files.add(await http.MultipartFile.fromPath('profile_photo', _image.path));
      files.add(
          http.MultipartFile.fromBytes('profile_photo',
              _image.readAsBytesSync(),
              filename: _image.path.split("/").last
          )
      );
      printLog(files);
    }


    HttpClient httpClient = new HttpClient();
    Map responseData =
    await httpClient.postMultipartRequest(context, Configurations.PROFILE_URL, data, files);
    //Request(context, Configurations.PROFILE_URL, data);
    processProfileResponse(responseData);
  }

  void processProfileResponse(Map res) {
    print("come for response");
    print(res);
    if(res != null) {
      globals.currentUser = User.fromJson(res);
      Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
      Preferences.saveObject("profile", "0");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          )
      );
    }

  }

  final GlobalKey<FormState> _formAddressKey = GlobalKey<FormState>();
  bool _autoValidateAddress = true;

  final adrs_name =TextEditingController();
  final adrs_line1 =TextEditingController();
  final adrs_line2 =TextEditingController();
  final adrs_landmark =TextEditingController();
  final adrs_disctric =TextEditingController();
  final adrs_city =TextEditingController();
  final adrs_postalcode =TextEditingController();

  Widget _buildAddressDialog(BuildContext context) {
    return new AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(Icons.location_on),
    Text(AppLocalizations.of(context).translate('address'), ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate('address_placeholder'),
                ),
                controller: adrs_name,
                validator: (value){
                  if (value.isEmpty) {
                    return AppLocalizations.of(context).translate('profile_txt_address');
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
                        labelText: AppLocalizations.of(context).translate('address1_placeholder'),
                      ),
                      controller: adrs_line1,
                      validator: (value){
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).translate('profile_txt_address1');
                        }
                        return null;
                      },
                    ),

                  ),
                  SizedBox(width: 10,),
                  // Address Line 2
                  Container(
                    width: 100.0,
                    child:
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).translate('address2_placeholder'),
                      ),
                      controller: adrs_line2,
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
                          labelText: AppLocalizations.of(context).translate('landmark_placeholder'),
                        ),
                        controller: adrs_landmark
                    ),
                  ),

                  SizedBox(width: 10,),

                  // District
                  Container(
                    width: 100.0,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).translate('district_placeholder'),
                      ),
                      controller: adrs_disctric,
                      validator: (value){
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).translate('profile_txt_district');
                        }
                        return null;
                      },
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
                        labelText: AppLocalizations.of(context).translate('city_placeholder'),
                      ),
                      controller: adrs_city,
                      validator: (value){
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).translate('profile_txt_city');
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(width: 10,),

                  // postal Code
                  Container(
                    width: 100.0,
                    child:
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).translate('postalcode_placeholder'),
                      ),
                      controller: adrs_postalcode,
                      validator: (value){
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).translate('profile_txt_postalcode');
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              ButtonTheme(
                minWidth: 300.0,
                child:  RaisedButton(
                    color: Configurations.themColor,
                    textColor: Colors.white,
                    child:  Text(
                        AppLocalizations.of(context).translate('btn_save'),
                        style: TextStyle(fontSize: 16.5)
                    ),
                    onPressed: () {
                      addressSave();
                    }
                ),
              ),
            ],
          ),
            key: _formAddressKey,
            autovalidate: _autoValidateAddress,
          ),


        ),
//      actions: <Widget>[
//          new FlatButton(
//            onPressed: () {
//              addressSave();
//              },
////            textColor: Theme.of(context).primaryColor,
//            child: Text('Save'),
//          ),
//        ],
    );
  }

  void addressSave() {
    if (_formAddressKey.currentState.validate()) {
      _formAddressKey.currentState.save();
      _autoValidateAddress = false;


      setState(() {
        print(adrs_line1.text);
        print(adrs_line2.text);
        print(adrs_landmark.text);

        addressString = adrs_line1.text;
        if(adrs_line2.text.isNotEmpty) {
          addressString += "\n" + adrs_line2.text;
        }

        if(adrs_landmark.text.isNotEmpty) {
          addressString += "\n" + adrs_landmark.text;
        }
        addressString += "\n" + adrs_disctric.text
            + "\n" + adrs_city.text + "\n" + adrs_postalcode.text;
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
    return Material(elevation: 5.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,5,10,5),
        child: Row(
          children:[
            Icon((dropdownvalue == "Male") ? Ionicons.ios_male : Ionicons.ios_female ),
            SizedBox(width: 20,),
            Expanded(child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                value: dropdownvalue,
                icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
                items: _dropDownTypes,
                onChanged: changedDropDownItem),
            ),

          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key) {
      items.add(DropdownMenuItem(value:key , child: Text(key)
      ));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      dropdownvalue = selectedItem;
    });
  }
  /* void enterServices() {
    showDialog(
      context: context,
      builder: (BuildContext context) => setServiceListVendor(context),
    );
  }
  bool _value1 = false;
  void _value1Changed(bool value) => setState(() => _value1 = value);
  Widget setServiceListVendor(BuildContext contest){
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Icon(Icons.work),
          Text("SERVICES",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent,), ),
        ],
      ),
    content: SingleChildScrollView(
      child: Card(margin: EdgeInsets.fromLTRB(10, 10, 10, 10),

        child: Row(
          children: <Widget>[
            Checkbox(value: _value1, onChanged: _value1Changed),
            Container(padding: EdgeInsets.all(10),
              child:   new Image.asset("assets/images/jamLogo.png",
                height: 40.0, width: 80.0 , fit: BoxFit.contain, ),
            ),

            Padding(padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: Text("Carpenter",maxLines: 2,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,

              ),
            ),
          ],
        ),

      ),
    )

    );
    Card(margin: EdgeInsets.fromLTRB(10, 10, 10, 10),

      child: Row(
        children: <Widget>[
          Checkbox(value: _value1, onChanged: _value1Changed),
          Container(padding: EdgeInsets.all(10),
            child:   new Image.asset("assets/images/jamLogo.png",
              height: 40.0, width: 80.0 , fit: BoxFit.contain, ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
            child: Text("Carpenter",maxLines: 2,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,

            ),
          ),
        ],
      ),

    )

  } */
}