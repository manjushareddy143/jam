import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/models/address.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
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
class ProfileUIPageState extends State<ProfileUIPage> with TickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
//  bool isEdit = false;
  bool isEditProfile = false;



  File _image;
 List<Tab> tabList = List();
  TabController _tabController;
//  User user;
  FocusNode focus_email, focus_fName, focus_lName, focus_no, focus_address;


  Address singleAddress = Address(0, "", "", "", "", "", "", "", globals.currentUser.id, "");



  @override
  void initState(){
    print("PROFILE ${globals.currentUser.toJson()}");
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
    focus_address = FocusNode();
    isEditProfile = false;

//    print("languages  = ${globals.currentUser.languages}");
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
      print("languages  = ${globals.currentUser.languages.split(',')}");
    }



  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focus_email.dispose();
    focus_fName.dispose();
    focus_lName.dispose();
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

  void getProfile() async  {
    await Preferences.readObject("user").then((onValue) async {
      var userdata = json.decode(onValue);
      setState(() {
        globals.currentUser = User.fromJson(userdata);
      });
    });
  }

  String imageUrl = "";
  Future getImage() async {
    final imageSrc = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select the image source"),
        actions: <Widget>[
          MaterialButton(
            child: Text("Camera"),
            onPressed: () => Navigator.pop(
              context,
              ImageSource.camera,
            ),
          ),
          MaterialButton(
            child: Text("Gallery"),
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
    // TODO: implement build
    if(globals.currentUser == null) {
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
          SizedBox(height: 20,),
          setTabbar(),
        ],
      ),
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height /3.6,
      child: Padding( padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Column(
          children: <Widget>[
            //SizedBox(height: 20),
            _buildProfileImage(),
           // SizedBox(height: 10),
        Text(globals.currentUser.first_name,
          textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
          style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w400,
              color: Colors.white),
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
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  Widget _buildProfileImage() {
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
            (_image == null) ? NetworkImage(globals.currentUser.image) : FileImage(_image),
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
  String addressString = "";

  Widget setDetails(){

    if(globals.currentUser.address != null) {
      print("ADDRESS GET");
      if(globals.currentUser.address.length > 0) {
        addressString = singleAddress.address_line1;
        if(singleAddress.address_line2 != "") {
          addressString += ", " + singleAddress.address_line2;
        }

        if(singleAddress.landmark != "") {
          addressString += ", " + singleAddress.landmark;
        }
        addressString += ", " + singleAddress.district
            + ", " + singleAddress.city + ", " + singleAddress.postal_code + ".";
      }
    }

    print("addressString===== $addressString");

    return Padding(
      padding:  EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // FistName
          TextField(
            focusNode: focus_fName,style: (isEditProfile) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: (globals.currentUser.first_name == "" || globals.currentUser.first_name == null) ? "First Name" : globals.currentUser.first_name, prefixIcon: Icon(Icons.person),enabled: isEditProfile),
            controller: (globals.currentUser.first_name == "")
                ? prfl_fname : prfl_fname ..text = globals.currentUser.first_name,
          ),

          // LastName
          TextField(
            focusNode: focus_lName,style: (isEditProfile) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: (globals.currentUser.last_name == null || globals.currentUser.last_name == "") ? "Last Name" : globals.currentUser.last_name, prefixIcon: Icon(Icons.person),enabled: isEditProfile),
            controller: (globals.currentUser.last_name == "")
                ? prfl_lname : prfl_lname ..text = globals.currentUser.last_name,
          ),

          // EMAIL
          TextField(
            focusNode: focus_email,style: (isEditProfile) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: (globals.currentUser.email == null || globals.currentUser.email == "") ? "Email" : globals.currentUser.email, prefixIcon: Icon(Icons.email),enabled: isEditProfile),
            controller: (globals.currentUser.email == "")
                ? prfl_email : prfl_email ..text = globals.currentUser.email,
          ),

          // PHONE
          TextField(
            focusNode: focus_no, style: (isEditProfile) ? TextStyle(color: Colors.black) : TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: (globals.currentUser.contact == "" || globals.currentUser.contact == null) ? "Phone number" : globals.currentUser.contact, prefixIcon: Icon(Icons.call),enabled: isEditProfile, ),
            controller: (globals.currentUser.contact == "")
                ? prfl_contact : prfl_contact ..text = globals.currentUser.contact,
          ),

          Visibility( visible: !isEditProfile,
            // Gender
            child: TextField(
              decoration: InputDecoration(
                  hintText: (gender == "" || gender == null) ? "NOT SELECTED" : globals.currentUser.gender, prefixIcon: Icon(Icons.face), enabled: isEditProfile
              ),
            ),
          ),

          Visibility(
            visible: isEditProfile,
            child: setDropDown(),
          ),



          Visibility( visible: !isEditProfile,
            child: TextField(style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(hintText: (globals.currentUser.languages == null) ? "NOT SELECTED" : globals.currentUser.languages, prefixIcon: Icon(Icons.language), enabled: isEditProfile),
            ),
          ),

          Visibility( visible: isEditProfile,
           child: Container(
               decoration: myBoxDecoration(),
               child: Padding(padding: EdgeInsets.all(1),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Icon(Icons.language),
                     SizedBox(width: 10,),
                     Text("English"),
                     Checkbox(value: _english, onChanged: _selecteEnglish),
                     SizedBox(width: 1,),
                     Text("Arabic"),
                     Checkbox(value: _arabic, onChanged: _selecteArabic),
                   ],
                 ),)),
           ),

          Visibility( visible: !isEditProfile,
            child: TextField(style: TextStyle(color: Colors.grey),
              focusNode: focus_address,
              decoration: InputDecoration(hintText: (addressString == null || addressString == "") ? "NOT SET" : addressString, prefixIcon: Icon(Icons.location_on),enabled: isEditProfile,
              helperMaxLines: 5, hintMaxLines: 5),
            ),
          ),

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

    if(globals.currentUser.contact != prfl_contact.text && globals.currentUser.contact != null) {
      data["contact"] = prfl_contact.text;
    }

    if(globals.currentUser.gender != dropdownvalue && globals.currentUser.gender != null) {
      data["gender"] = dropdownvalue;
    }

    print(globals.currentUser.email);
    if(globals.currentUser.email != prfl_email.text && globals.currentUser.email != null) {
      data["email"] = prfl_email.text;
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



//    if(globals.currentUser.roles[0].slug == "provider") {
//      String rawJson = jsonEncode(ServiceSelectionUIPageState.selectedServices);
//      print(rawJson);
//      data["services"] = rawJson;
//      data["service_radius"] = prfl_servcerds.text;
//    }
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
      build(context);
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
              "Address",
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
                                mapAddressTitle = "Enter Location";
                              } else {

                                showMap = true;
                                mapAddressTitle = "Set Location Map";
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
                                  ),
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
                                        ),
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
                                          ),
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
                                        ),
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
                                        ),
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
                                        ),
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
                                addressSave(isNewAddress);
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
//              singleAddress = Address(0, , , "",
//                  , , , "", globals.currentUser.id, "");
////              Address(id, , , , , , postal_code, location, user_id, name)
                adrs_line1.text = globals.addressLocation.featureName;
                adrs_line2.text = globals.addressLocation.subLocality;
                adrs_disctric.text = globals.addressLocation.subAdminArea;
                adrs_city.text = globals.addressLocation.locality;
                adrs_postalcode.text = globals.addressLocation.postalCode;
                print("adrs_line1.text == ${adrs_line1.text}" );
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

      ),
    );
  }

  void addressSave(bool isNewAddress) {
    showMap = false;
    if (_formAddressKey.currentState.validate()) {
      _formAddressKey.currentState.save();
      _autoValidateAddress = false;

      setState(() {
        if(isNewAddress) {
          print(isNewAddress);
          String newAddressString = adrs_line1.text;
          if (adrs_line2.text.isNotEmpty) {
            newAddressString += "\n" + adrs_line2.text;
          }

          if (adrs_landmark.text.isNotEmpty) {
            newAddressString += "\n" + adrs_landmark.text;
          }
          newAddressString += "\n" +
              adrs_disctric.text +
              "\n" +
              adrs_city.text +
              "\n" +
              adrs_postalcode.text;
          print("NEW addressString == $newAddressString");

        } else {
          print(isNewAddress);
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
          print("addressString == $addressString");
          singleAddress = Address(singleAddress.id, adrs_line1.text, adrs_line2.text,
              adrs_landmark.text, adrs_disctric.text, adrs_city.text, adrs_postalcode.text, "", globals.currentUser.id, adrs_name.text);
        }
        Navigator.of(context).pop();
      });


    } else {
      setState(() {
        _autoValidateAddress = true;
      });
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

  Widget setRichText()
  {
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
          SizedBox(height: 10,),
          Container(margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
            border: Border.all(
              color: Configurations.themColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
            height: 140,
            child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Align(alignment:Alignment.center,
                      child: ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text((adrs_name.text == "")
                          ? AppLocalizations.of(context).translate('address')
                          : adrs_name.text),
                      subtitle: Text(addressString),),
                    )
                    ],

                  );
                },
              itemCount: globals.currentUser.address.length,
                ))
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
           height: 270,

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
  String dropdownvalue = "Male";

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
    return Container(
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