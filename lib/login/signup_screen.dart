

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jam/components/back_button_appbar.dart';
import 'package:jam/home_widget.dart';
import 'package:jam/models/service.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/widget/widget_helper.dart';

enum GenderEnum {  Male, Female  }

class SignupScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SignupPage(title: "Sign up"),
    );
  }
}

class SignupPage extends StatefulWidget {

  SignupPage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isMale = false;
  String dropdownvalue;
  List<DropdownMenuItem<String>> _dropDownTypes;
  Map<String, dynamic> _lstType = {"N":"","M":"Male","F": "Female",};


  String _gender = "Male";

  bool arabic = false;
  bool english = false;
  final txtLname=TextEditingController();
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPass = TextEditingController();
  final txtConfPass = TextEditingController();
  final txtContact = TextEditingController();
  //final txtExp = TextEditingController();
  bool _value1 = false;
  void _value1Changed(bool value) => setState(() => _value1 = value);

  @override
  void initState() {
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    dropdownvalue = _dropDownTypes[0].value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(resizeToAvoidBottomPadding: false,

      body: SingleChildScrollView(
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: signupScreenUI(),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Widget signupScreenUI() {
    return Container(margin: EdgeInsets.all(20),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          new Image.asset("assets/images/Logo-1x.png",
            height: 60.0, width: 120.0 , fit: BoxFit.fill, ),
          new Text(
            'SIGN UP',
            textAlign: TextAlign.center,

            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 32.0,),
          ),
          // NORMAL
          SizedBox(height: 30,),

          Column( mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  <Widget>[
              Material(elevation: 10.0,shadowColor: Colors.grey,
                child: TextFormField(
                  decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),


                      labelText: 'First Name',),
                  controller: txtName,//..text = 'KAR-MT30',
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter name!!';
                    }
                    return null;
                  },
                  onSaved: (String val) {
//            _account = val;
                  },
                ),
              ),

               SizedBox(height: 10,),

               Material(elevation: 10.0,shadowColor: Colors.grey,
                 child: TextFormField(
                   decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                   labelText: 'Last Name',),
                   controller: txtLname,//..text = 'KAR-MT30',
                   validator: (value){
                     if (value.isEmpty) {
                       return 'Please enter last name!!';
                     }
                     return null;
                   },
                   onSaved: (String val) {
//            _account = val;
                   },
                 ),
               ),
              SizedBox(height: 10,),

              setDropDown(),

              SizedBox(height: 10,),



              Material(elevation: 10.0,shadowColor: Colors.grey,
                child: TextFormField(
                  decoration: InputDecoration( suffixIcon: Icon(Icons.email),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: 'Email',),
                  controller: txtEmail,//..text = 'KAR-MT30',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter username!!';
                    }
                    return validateEmail(value);
                  },
                  onSaved: (String val) {
//            _account = val;
                  },
                ),
              ),
              SizedBox(height: 10,),
              Material(elevation: 10.0,shadowColor: Colors.grey,
                child: TextFormField(
                  decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: 'Phone',),
                  controller: txtContact,//..text = 'KAR-MT30',
                  keyboardType: TextInputType.phone,
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter contact number!!';
                    }
                    return null;
                  },
                  onSaved: (String val) {
//            _account = val;
                  },
                ),
              ),
              SizedBox(height: 10,),
              Material(elevation: 10.0,shadowColor: Colors.grey,
                child: TextFormField(
                  decoration: InputDecoration( suffixIcon: Icon(Icons.lock),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: 'Password',),
                  obscureText: true,
                  controller: txtPass,//..text = 'KAR-MT30',
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter password!!';
                    }
                    return null;
                  },
                  onSaved: (String val) {
                  },
                ),
              ),
              SizedBox(height: 10,),
              Material(elevation: 10.0,shadowColor: Colors.grey,
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.lock),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1,  ), ),
                    labelText: 'Confirm Password',),
//                controller: TextEditingController(),//..text = 'KAR-MT30',
                  validator:  (value){
                    print("val = $value");
                    print(txtPass.text);
                    if (value != txtPass.text) {
                      return 'Confirm password mismatch!!';
                    }
                    return null;
                  },
                  onSaved: (String val) {
//            _account = val;
                  },
                ),
              ),
              SizedBox(height: 10,),

            // setRadio(),
            // checkBox(),
             Row(
               children: <Widget>[
                Checkbox(value: _value1, onChanged: _value1Changed),
                Text("Agree With Terms And Condition", style: TextStyle(color: Colors.grey),),])
             // dropdown setup
             // setDropDown(),

            ],
          ),

          // DETAILS
        /*  Visibility(
          visible: isISP,
            child: Column(
              children: <Widget>[
                setRadio(),
                checkBox(),
                setTimer(),
                TextFormField(
                  decoration: InputDecoration(hintText: "Experience"),
                  controller: txtExp,//..text = 'KAR-MT30',
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter Experience!!';
                    }
                    return null;
                  },
                  onSaved: (String val) {
//            _account = val;
                  },
                ),
      ],
            )
          ), */

          SizedBox(height: 10),

          RaisedButton(
            color: Colors.teal,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(150,10,150,10),
//          color: MyColors.turquoise,
            onPressed: () {
              _validateInputs();
            },
            child: const Text('Sign Up', style: TextStyle(fontSize: 20,color: Colors.white)),
          ),
        ],
      ),
    );
  }

  bool _autoValidate = false;

  void _validateInputs() {

    if (_formKey.currentState.validate()) {
//    If all data are correct then do API call
      _formKey.currentState.save();
      printLog('validate');
      callLoginAPI();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future callLoginAPI() async {
    Map<String, String> data = new Map();

    data["name"] = txtName.text;
    data["password"] = txtPass.text;
    data["contact"] = txtContact.text;
   /* if(_type == "ISP") {
      data["type"] = "Individual service provider";
    } else {
      data["type"] = "Corporate Service Provider";
    }
*/
    data["type"] = "SC";
    data["gender"] = _gender;
//    String lang = "";
//    if(arabic) {
//      lang += "arabic,";
//    }
//    if(english) {
//      lang += "english,";
//    }
//  data["language"] = lang;
//    data["language"] = "arabic,english";
 //   String lang = languages.join(', ');
   // print(lang);
   // data["language"] = lang;//"arabic,english";
   // data["start_time"] = startTime;
   // data["end_time"] = endTime;
   // data["experience"] = txtExp.text;
    data["email"] = txtEmail.text;
    print(data["gender"]);
    print(data["name"]);
    print(data["email"]);
    print(data["language"]);
    print(data["password"]);
    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, 'http://jam.savitriya.com/api/customer_register', data);
      processLoginResponse(syncUserResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processLoginResponse(Response res) {
    print("come for response");
    if (res != null) {

      if (res.statusCode == 200) {
//        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> Home()));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
//        getServices();
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }

//  void getServices() async {
//    try {
//      Map<String, String> data = new HashMap();
//      HttpClient httpClient = new HttpClient();
//      var syncReportResponse =
//      await httpClient.getRequest(context, "http://jam.savitriya.com/api/all_services", null, null, true, false);
//      processReportResponse(syncReportResponse);
//    } on Exception catch (e) {
//      if (e is Exception) {
//        printExceptionLog(e);
//      }
//    }
//  }

//  void processReportResponse(Response res) {
//    print('get daily format');
//    if (res != null) {
//      if (res.statusCode == 200) {
//        var data = json.decode(res.body);
//        print(data);
//        List roles = data;
//        List<Service> listofRoles = Service.processServices(roles);
//        printLog(listofRoles.length);
//        // Preferences.saveObject('reportformate', jsonEncode(listofRoles));
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => HomeScreen(),
//            ));
//      } else {
//        printLog("login response code is not 200");
//      }
//    } else {
//      print('no data');
//    }
//  }

 /* String startTime = null;
  String endTime = null;
  
  Widget setTimer() {
    return Container(
      child: Row(
        children: <Widget>[
          Text("Timing"),
          SizedBox(width: 20,),
          FlatButton(
              onPressed: () {
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        startTime = new DateFormat("H:mm:ss").format(date);
                      });
                    }, currentTime: DateTime.now());
              },
              child: startTime == null ? Text('Start Time', style: TextStyle(color: Colors.blue),): Text(startTime
                , style: TextStyle(color: Colors.blue),),
    ),
          
          Text("To"),

          FlatButton(
              onPressed: () {
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        endTime = new DateFormat("H:mm:ss").format(date);
                      });
                    }, currentTime: DateTime.now());
              },
              child: endTime == null ? Text('End Time', style: TextStyle(color: Colors.blue),): Text(endTime
                , style: TextStyle(color: Colors.blue),),
              ),


        ],
      ),
    );
  }

  Widget setDropDown() {
    return Container(
//      padding: const EdgeInsets.all(10),
      child: Row(
        children:[
          Text("Type" , style: TextStyle(fontSize: 17 , color: Colors.black45)),
          SizedBox(width: 50,),
          Expanded(child: DropdownButton(
              isExpanded: true,
              value: _type,
              items: _dropDownTypes,
              onChanged: changedDropDownItem),
          ),

        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(Map<String, dynamic> reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key, val) {
      items.add(DropdownMenuItem(value: key, child: Text(val)));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      _type = selectedItem;
      print(_type);
      if(selectedItem == "ISP") {
        isISP = true;
      } else {
        isISP = false;
      }
    });
  }
*/

/* List languages = new List();

  Widget checkBox() {
    return Container(
      child: Column(
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: arabic,
                onChanged: (bool value) {
                  if(value) {
                    if(!languages.contains('arabic')) {
                      languages.add('arabic');
                    }
                  } else {
                    if(languages.contains('arabic')) {
                      languages.remove('arabic');
                    }
                  }
                  setState(() {
                      arabic = value;
                  });
                },
              ),
              new Text("Arabic"),

              new Checkbox(
                value: english,
                onChanged: (bool value) {
                  if(value) {
                    if(!languages.contains('english')) {
                      languages.add('english');
                    }
                  } else {
                    if(languages.contains('english')) {
                      languages.remove('english');
                    }
                  }
                  setState(() {
                      english = value;
                  });
                },
              ),
              new Text("English"),
            ],
          ),
        ],
      ),
    );
  } */

 /* GenderEnum _character = GenderEnum.Male;

  Widget setRadio() {
    return Container(
      child: Column(
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(value: GenderEnum.Male, groupValue: _character,
                  activeColor: Colors.tealAccent ,onChanged: (GenderEnum value) {
                setState(() {
                  _character = value;
                  print(value);
                  _gender = _character.toString().substring(11);
                });
              }),
              new Text("Male"),

              new Radio(value: GenderEnum.Female , groupValue: _character, activeColor: Colors.tealAccent , onChanged: (GenderEnum value) {
                setState(() {
                  _character = value;
                  print(value);
                  _gender = _character.toString().substring(11);
                });
              }),
              new Text("Female"),
            ],
          ),
        ],
      ),
    );
  } */

  Widget setDropDown() {
    return Material(elevation: 10.0,shadowColor: Colors.grey,
      child: Container(
       padding: const EdgeInsets.fromLTRB(10,5,10,5),
        child: Row(
          children:[
            Text("Gender" , style: TextStyle(fontSize: 17 , color: Colors.black45)),
            SizedBox(width: 50,),
            Expanded(child: DropdownButton(
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
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(Map<String, dynamic> reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key, val) {
      items.add(DropdownMenuItem(value: key, child: Text(val)));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      dropdownvalue = selectedItem;
      print(dropdownvalue);
      if(selectedItem == "") {
        isMale = true;
      } else {
        isMale = false;
      }
    });
  }
}