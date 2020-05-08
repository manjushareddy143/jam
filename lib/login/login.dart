import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jam/classes/language.dart';
import 'package:jam/login/signup_screen.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/screens/initial_profile.dart';
import 'package:jam/services.dart';
import 'package:jam/api/network.dart';
import 'package:jam/home_widget.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/widget/otp_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/main.dart';


class UserLogin extends StatefulWidget {
  _user createState() => new _user();
}

class _user extends State<UserLogin>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _primeKey = GlobalKey<State>();
  //const String loginURL ="";
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool _value1 = false;
  final txtUser = TextEditingController();
  final txtPass = TextEditingController();

  void _value1Changed(bool value) => setState(() => _value1 = value);
  FocusNode myFocusNode, myFocusNode2;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    myFocusNode2.dispose();

    super.dispose();
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
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color= Colors.teal;
    return  GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: new Scaffold( key: _primeKey,

        body: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child:  SingleChildScrollView(
            //child:Padding(
            // padding: const EdgeInsets.fromLTRB(5,20,5,20),
            child: new Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[



                  new Image.asset("assets/images/BG-1x.jpg",
                    height: 250.0, width: double.infinity, fit: BoxFit.fill, ),

                 
                 // SizedBox(height: 30),
                  Row(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
                     DropdownButton(
                      underline: SizedBox(),
                      onChanged: ( Language language){
                        _changeLanguage(language);
                      },
                      icon: Icon(Icons.language, color: Colors.teal,),
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                        value:  lang,
                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[Text(lang.flag),
                            Text(lang.name)],
                        ) ,
                      )).toList(),

                    ),
                   // SizedBox(width: 30)
                  ],),
                  new Image.asset("assets/images/Logo-1x.png",
                    height: 40.0, width: 80.0 , fit: BoxFit.fill, ),
                  /*new Text(
                         'JAM    ',
                         textAlign: TextAlign.center,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(fontWeight: FontWeight.bold,background: paint ,  color: Colors.white, fontSize: 40.0, ),
                       ), */
                  new Text(
                    AppLocalizations.of(context).translate('Text1'),
                    textAlign: TextAlign.center,

                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 32.0,),
                  ),

                  SizedBox(height: 30,

                      ),

                  Container( padding: new  EdgeInsets.all(20),
                    child:
                    Column(children: <Widget>[

                      new TextFormField(
                        focusNode: myFocusNode2,
                        controller: txtUser
                        ,
                        validator: (value){
                          if (value.isEmpty) {
                            return 'Please enter username!!';
                          }
                          return validateEmail(value);
                        },

                        obscureText: false,
                        decoration: InputDecoration( suffixIcon: Icon(Icons.face),
                          border: OutlineInputBorder(),
                          labelText: //"Email or Username"
                           AppLocalizations.of(context).translate('textbox1'),
                        ),

                      ),
                      SizedBox(height: 20),
                      new TextFormField(
                        focusNode: myFocusNode,
                        controller: txtPass,
                        validator: (value){
                          if (value.isEmpty) {
                            return 'Please enter password!!';
                          }
                          return null;
                        },

                        obscureText: true,
                        decoration: InputDecoration( suffixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          labelText:  AppLocalizations.of(context).translate('textbox2'),
                        ),
                      ),
                    ],
                    ),
                  ),

                  Container( padding: new  EdgeInsets.fromLTRB(25,0,25,25), child:  Row(
                    children: <Widget>[
                      Checkbox(value: _value1, onChanged: _value1Changed),
                      Text(AppLocalizations.of(context).translate('checkbox'), ),
                      Spacer(),
                      Text(AppLocalizations.of(context).translate('Text2'),  style: TextStyle( color: Colors.teal),),
                      // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                    ],
                  ),),
                  SizedBox(height: 10),
                  ButtonTheme(
                    minWidth: 350,
                    child: new  RaisedButton(

                        color: Colors.teal,
                        textColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(150,10,150,10),
                        //invokes _authUser function which validate data entered as well does the api call
                        child:  Text(
                            AppLocalizations.of(context).translate('Button1'),
                            style: TextStyle(fontSize: 16.5), overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _validateInputs();
                        }
                    ),
                  ),

                  Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('Text3')),

                      FlatButton( onPressed:(){

                        Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => SignupScreen(),
//                        fullscreenDialog: false,
                        ));
//                      Navigator.push(context,MaterialPageRoute(
//                          builder: (context)=> SignupScreen()));
                        },
                        child:
                        Text(AppLocalizations.of(context).translate('Button2'), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),)
                      // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                    ],
                  ),),
                  SizedBox(height: 30,),


                  Text(AppLocalizations.of(context).translate('Text4'),
                      textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),



                ]
            ),
          ),

        ),
      ),
    );


  }

  Future callLoginAPI() async {
    Map<String, String> data = new Map();

    data["email"] = txtUser.text;
    data["password"] = txtPass.text;
//    data["access_type"] = 'api';

    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, Configurations.LOGIN_URL, data);
      processLoginResponse(syncUserResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processLoginResponse(Response res) {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        User user = User.fromJson(data);
        if(user.address == null) {
          print('NO ADDRESS');
          Preferences.saveObject("user", jsonEncode(user.toJson()));
          Preferences.saveObject("profile", "1");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InitialProfileScreen(),
              ));
        } else {
          print('HMMM ADDRESS');
          Preferences.saveObject("user", jsonEncode(user.toJson()));
          Preferences.saveObject("profile", "0");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        }
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, data['message']);
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
//
//      } else {
//        printLog("login response code is not 200");
//      }
//    } else {
//      print('no data');
//    }
//  }

  void _validateInputs() {
//    _showDialog(context),
//    showDialog(
//      context: context,
//      builder: (BuildContext context) => OTPScreen.buildAboutDialog(context),
//    );
    if (_formKey.currentState.validate()) {
//    If all data are correct then do API call
      _formKey.currentState.save();
      callLoginAPI();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
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
}
