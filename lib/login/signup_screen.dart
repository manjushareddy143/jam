

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jam/components/back_button_appbar.dart';
import 'package:jam/home_widget.dart';
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

  bool isISP = false;
  String _type;
  List<DropdownMenuItem<String>> _dropDownTypes;
  Map<String, dynamic> _lstType = {"CSP" : "Corporate Service Provider", "ISP" : "Individual Service Provider"};


  String _gender = "Male";

  bool arabic = false;
  bool english = false;

  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPass = TextEditingController();
  final txtConfPass = TextEditingController();
  final txtContact = TextEditingController();
  final txtExp = TextEditingController();


  @override
  void initState() {
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    _type = _dropDownTypes[0].value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BackButtonAppBar(title: widget.title,),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        margin: const EdgeInsets.all(10.0),
        child: Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.grey)),
              child: new Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: signupScreenUI(),
              ),
            )),
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
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        // NORMAL
        Visibility(
          visible: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: "Name"),
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
              TextFormField(
                decoration: InputDecoration(hintText: "E-mail"),
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
              TextFormField(
                decoration: InputDecoration(hintText: "Password",),
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
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(hintText: "Confirm Password"),
                controller: TextEditingController(),//..text = 'KAR-MT30',
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
              TextFormField(
                decoration: InputDecoration(hintText: "Contact"),
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
             // dropdown setup
              setDropDown(),

            ],
          ),
        ),

        // DETAILS
        Visibility(
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
        ),

        SizedBox(height: 10),

        RaisedButton(
          color: Colors.teal,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(100,10,100,10),
//          color: MyColors.turquoise,
          onPressed: () {
            _validateInputs();
          },
          child: const Text('Sign Up', style: TextStyle(fontSize: 20,color: Colors.white)),
        ),
      ],
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
    if(_type == "ISP") {
      data["type"] = "Individual service provider";
    } else {
      data["type"] = "Corporate Service Provider";
    }

    data["gender"] = _gender;
//    String lang = "";
//    if(arabic) {
//      lang += "arabic,";
//    }
//    if(english) {
//      lang += "english,";
//    }
//    data["language"] = lang;
    data["language"] = "arabic,english";
    data["start_time"] = startTime;
    data["end_time"] = endTime;
    data["experience"] = txtExp.text;
    data["email"] = txtEmail.text;
    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, 'http://jam.savitriya.com/api/register', data);
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

        var data = json.decode(res.body);

        if(data['status'] == "200") {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> Home()));
        } else {

          printLog("token : $data");
          print(data["message"]);
          showInfoAlert(context, data["error"].toString());
        }
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }

  String startTime = null;
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
                  setState(() {
                      arabic = value;
                  });
                },
              ),
              new Text("Arabic"),

              new Checkbox(
                value: english,
                onChanged: (bool value) {
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
  }

  GenderEnum _character = GenderEnum.Male;

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
  }

}