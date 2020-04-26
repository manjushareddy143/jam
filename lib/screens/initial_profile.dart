
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
//  String _g?ender = "Male";
  String dropdownvalue;

  @override
  void initState() {
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    dropdownvalue = _dropDownTypes[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(title: Text("Complete your Profile", style: TextStyle(color: Colors.black),), automaticallyImplyLeading: false, centerTitle: false, backgroundColor: Colors.white,),
//      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: profileUI(),
        ),
      ),
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
//      constraints: const BoxConstraints(minWidth: double.infinity),
      height: screenSize.height /3.6,
//      width: screenSize.width *2,
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
        color: Colors.green,
//        image: DecorationImage(
//          image: NetworkImage(
//                'https://placeimg.com/640/480/any',
//              ),
//          fit: BoxFit.cover,
//        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        child: GestureDetector(
          onTap: () {
            print("object");
          }, // handle your image tap here
        ),
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://placeimg.com/640/480/any',
              ),
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

  Widget profileUI() {
    return Container(
//        constraints: const BoxConstraints(minWidth: double.infinity),
//        width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(15, 30, 0, 10),
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
//                  enabled: false,
                  decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, textDirection: TextDirection.rtl,),
                      isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: "First name",
//                    isDense: true,
                    hasFloatingPlaceholder: false

                  ),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter name!!';
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
                  controller: TextEditingController()..text = "234",
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.phone,),
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    ),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter name!!';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 20,),

              // Email
              Material(
                elevation: 5.0,shadowColor: Colors.grey,
                child: TextFormField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.email,),
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: "Email"
                  ),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter name!!';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 20,),

              // Gender
              setDropDown(),

              SizedBox(height: 20,),

              Card(
                elevation: 5.0,
                child: Column(
//                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.location_on),
                      subtitle: Text('The Enchanted Nightingale Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.my_location, color: Colors.black54,size: 15,),
                              SizedBox(width: 10,),
                              Text('Set your Location', style: TextStyle(color: Colors.black54),)

                            ],
                          ),
                          onPressed: (


                              ) { /* ... */ },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
            Material(
              elevation: 5.0,shadowColor: Colors.grey,
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),



            ],
          ),
          ),




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
//                  _validateInputs();
                }
            ),
          )


        ],
      )
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
//      TextFormField(
//        enabled: false,
//        controller: TextEditingController()..text = key,
//        decoration: InputDecoration(
//            isDense: true,
//            prefixIcon: Icon((key == "Male") ? Ionicons.ios_male : Ionicons.ios_female , color: Colors.black54,),
//            contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
//            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
//        ),
//        validator: (value){
//          if (value.isEmpty) {
//            return 'Please enter name!!';
//          }
//          return null;
//        },
//      )
      ));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      dropdownvalue = selectedItem;
//      dropdownvalue = selectedItem;
//      print(dropdownvalue);
//      if(selectedItem == "") {
//        isMale = true;
//      } else {
//        isMale = false;
//      }
    });
  }
}