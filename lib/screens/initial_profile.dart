
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

class InitialProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: InitialProfilePage(title: "Complete your Profile"),
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
  List _lstType = ["Male","Female"];
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
        );
    setState(() {
      _image = image;
      print("IMAGE:::::::::: $_image");
    });
  }


  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height /3.6,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30),
          _buildProfileImage(),
          SizedBox(height: 10),
          Text("Image format jpeg or png", style: TextStyle(color: Colors.white70),),
          Text("Image size upto 3MB", style: TextStyle(color: Colors.white70)),
        ],
      ),
      decoration: BoxDecoration(
        color: Configurations.themColor,
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

  String addressString = "";
  String firstName = "";
  String phoneNumber = "";
  String email = "";

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
          Text("Complete your Profile", style: TextStyle(color: Colors.black, fontSize: 20),)
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
                    labelText: "First name",
                    hasFloatingPlaceholder: false
                  ),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter first name!!';
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
                    labelText: "Email",
                    hasFloatingPlaceholder: false,
                  ),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter email!!';
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
                  title: Text((adrs_name.text == "") ? "Enter Address" : adrs_name.text),
                  subtitle: Text(addressString),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.my_location, color: Configurations.themColor, size: 15,),
                          SizedBox(width: 10,),
                          Text('Set your Location', style: TextStyle(color: Configurations.themColor),)
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
                color: Colors.teal,
                textColor: Colors.white,
                child: const Text(
                    'Save',
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
      if(_image == null) {
        showInfoAlert(context, "Please select Profile Picture");
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

    print('COME FOR API CALL');
    List<http.MultipartFile> files = new List<http.MultipartFile>();
//    files.add(await http.MultipartFile.fromPath('profile_photo', _image.path));
    files.add(
        http.MultipartFile.fromBytes('profile_photo',
            _image.readAsBytesSync(),
            filename: _image.path.split("/").last
        )
    );
    printLog(files);

    HttpClient httpClient = new HttpClient();
    Map responseData =
    await httpClient.postMultipartRequest(context, Configurations.PROFILE_URL, data, files);
    //Request(context, Configurations.PROFILE_URL, data);
    processProfileResponse(responseData);
  }

  void processProfileResponse(Map res) {
    print("come for response");
    print(res);
    User user = User.fromJson(res);

        Preferences.saveObject("user", jsonEncode(user.toJson()));
        Preferences.saveObject("profile", "0");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
        ///////////////////
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
    Text('Enter Address', ),
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
                  labelText: "Address Name",
                ),
                controller: adrs_name,
                validator: (value){
                  if (value.isEmpty) {
                    return 'Please enter Address name!!';
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
                        labelText: "Address 1",
                      ),
                      controller: adrs_line1,
                      validator: (value){
                        if (value.isEmpty) {
                          return 'Enter Address!!';
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
                        labelText: "Address 2",
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
                          labelText: "Landmark",
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
                        labelText: "District",
                      ),
                      controller: adrs_disctric,
                      validator: (value){
                        if (value.isEmpty) {
                          return 'Please enter District!!';
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
                        labelText: "City",
                      ),
                      controller: adrs_city,
                      validator: (value){
                        if (value.isEmpty) {
                          return 'Please enter City!!';
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
                        labelText: "Postal Code",
                      ),
                      controller: adrs_postalcode,
                      validator: (value){
                        if (value.isEmpty) {
                          return 'Please enter postal code!!';
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
                    color: Colors.teal,
                    textColor: Colors.white,
                    child: const Text(
                        'Save',
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
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal,),
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
}