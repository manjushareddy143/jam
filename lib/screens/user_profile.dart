import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;
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
//  User user;
  FocusNode focus_email, focus_no, focus_address;





  @override
  void initState(){

    print("PROFILE ${globals.guest}");

    tabList.add(new Tab(text: 'Address',));
    _tabController= TabController(vsync: this, length: tabList.length);

    super.initState();
    focus_email = FocusNode();
    focus_no = FocusNode();
    focus_address = FocusNode();
    printLog("globals.currentUser ${globals.currentUser.first_name}");
//    if(globals.guest == true) {
//
//    } else {
////      getProfile();
//    }

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
        globals.currentUser = User.fromJson(userdata);
      });
    });
  }

  Future getImage() async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    if(image != null)
      print("image is not null");
    setState(() {
        _image = image;
    });
  //  print("image is null so returning this statement");
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

  Widget setDetails(){

//    printLog(globals.currentUser.address);
    String addressString = "";
    if(globals.currentUser.address != null) {
      if(globals.currentUser.address.length > 0) {
        addressString = globals.currentUser.address[0].address_line1;
        if(globals.currentUser.address[0].address_line2 != "") {
          addressString += ", " + globals.currentUser.address[0].address_line2;
        }

        if(globals.currentUser.address[0].landmark != "") {
          addressString += ", " + globals.currentUser.address[0].landmark;
        }
        addressString += ", " + globals.currentUser.address[0].district
            + ", " + globals.currentUser.address[0].city + ", " + globals.currentUser.address[0].postal_code + ".";
      }

    }

    return Padding(
      padding:  EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility( visible: !isEditProfile,
            child: TextField(

              decoration: InputDecoration(
                  hintText: (gender == "")?globals.currentUser.gender : gender, prefixIcon: Icon(Icons.face), enabled: isEditProfile
              ),
            ),
          ),
          Visibility(visible: isEditProfile,
          child: setDropDown(),),
          TextField(
            focusNode: focus_email,style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: globals.currentUser.email, prefixIcon: Icon(Icons.email),enabled: isEditProfile),
          ),
          TextField(
            focusNode: focus_no, style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(hintText: globals.currentUser.contact, prefixIcon: Icon(Icons.call),enabled: isEditProfile, ),
          ),



          Visibility( visible: !isEditProfile,
            child: TextField(style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(hintText: (globals.currentUser.languages == null) ? "NOT SELECTED" : globals.currentUser.languages, prefixIcon: Icon(Icons.library_books), enabled: isEditProfile),
            ),
          ),
          Visibility( visible: isEditProfile,
           child:   Padding(padding: EdgeInsets.all(10),
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
                    SizedBox(width: 1,),
                    Text("Hindi"),
                    Checkbox(value: _hindi, onChanged: _selecteHindi),
                  ],
                ),)),
          Visibility( visible: !isEditProfile,
            child: TextField(style: TextStyle(color: Colors.grey),
              focusNode: focus_address,
              decoration: InputDecoration(hintText: addressString, prefixIcon: Icon(Icons.location_on),enabled: isEditProfile,
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
                  onTap: addressEnter,
                  leading: Icon(Icons.location_on),
                  title: Text((adrs_name.text == "")
                     ? ""//
                     : adrs_name.text),
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
                        addressEnter();
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
  String addressString = "";
  final GlobalKey<FormState> _formAddressKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formServiceKey = GlobalKey<FormState>();
  bool _autoValidateAddress = true;
  // bool _autoValidateService = true;
  bool showMap = false;

  final adrs_name = TextEditingController();
  final adrs_line1 = TextEditingController();
  final adrs_line2 = TextEditingController();
  final adrs_landmark = TextEditingController();
  final adrs_disctric = TextEditingController();
  final adrs_city = TextEditingController();
  final adrs_postalcode = TextEditingController();


  String mapAddressTitle = "Set Location Map";
  void addressEnter() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildAddressDialog(context),
    );
  }
  Widget _buildAddressDialog(BuildContext context) {

    print("showMap $showMap ::: ${globals.addressLocation.thoroughfare}");
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
                                mapAddressTitle = "Set Location Map";
                              } else {

                                showMap = true;
                                mapAddressTitle = "Enter Location";
                                setCustomMapPin(pinLocationIcon).then((onValue) {
                                  pinLocationIcon = onValue;
                                });
                              }
                              print("showMap === $showMap");
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
                                  controller: adrs_name,
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
                                        controller: (globals.addressLocation.featureName == "")
                                            ? adrs_line1 : adrs_line1 ..text = globals.addressLocation.featureName,
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
                                          controller: (globals.addressLocation.subLocality == "") ? adrs_line2 : adrs_line2
                                            ..text = globals.addressLocation.subLocality
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
                                          controller: adrs_landmark
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
                                        controller: (globals.addressLocation.subAdminArea == "") ?
                                        adrs_disctric : adrs_disctric
                                          ..text = globals.addressLocation.subAdminArea,
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
                                        controller: (globals.addressLocation.locality == "") ?
                                        adrs_city : adrs_city
                                          ..text = globals.addressLocation.locality,
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
                                        controller: (globals.addressLocation.postalCode == "") ?
                                        adrs_postalcode : adrs_postalcode
                                          ..text = globals.addressLocation.postalCode,
                                        //adrs_postalcode,
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
//        mapType: MapType.hybrid,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          print("ADDDRESS::: ${controller}");
          _controller.complete(controller);

//          getAddress(globals.location);
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

          print("latLogn::: $latLogn");

          setState(() {

            getAddress(LatLng(latLogn.latitude, latLogn.longitude)).then((onValue) {
              globals.addressLocation = onValue;
              addressString = globals.addressLocation.addressLine;
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
  List<String> languages = new List<String>();
  void _selecteEnglish(bool value) {
    setState(() {
     // lastName = prfl_lname.text;
     // firstName = prfl_fname.text;
      _english = value;

      if(languages.contains("English")) {
        languages.remove("English");
      } else {
        languages.add("English");
      }
      print("language :: $languages $value");
    });
  }
  void _selecteArabic(bool value) {
    setState(() {
      _arabic = value;
     // lastName = prfl_lname.text;
     // firstName = prfl_fname.text;
      if(languages.contains("Arabic")) {
        languages.remove("Arabic");
      } else {
        languages.add("Arabic");
      }
    });
  }
  void _selecteHindi(bool value) {
    setState(() {
      _hindi = value;
      //lastName = prfl_lname.text;
     // firstName = prfl_fname.text;
      if(languages.contains("Hindi")) {
        languages.remove("Hindi");
      } else {
        languages.add("Hindi");
      }
    });
  }
  bool _english = false;
  bool _arabic = false;
  bool _hindi = false;

  Widget setRichText(){
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Address', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ) ),
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
  String dropdownvalue = "Male";
  void changedDropDownItem(String selectedItem) {
    setState(() {
      //dropdownvalue = selectedItem;
    });
  }
  String gender= "";
  String address = "";

  List<DropdownMenuItem<String>> _dropDownTypes;

  Widget setDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
    );
  }
}