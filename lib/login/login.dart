import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:jam/login/signup_screen.dart';
import 'package:jam/models/service.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/services.dart';
import 'package:jam/api/network.dart';
import 'package:jam/home_widget.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';





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

  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color= Colors.teal;
    return  new Scaffold( key: _primeKey,

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
                //Container(
                //decoration: new BoxDecoration(
                //image: new DecorationImage(
                // image: new AssetImage("assets/images/6745.jpg"),
                //fit: BoxFit.fill,     )
                // )
                //),
                SizedBox(height: 30),
                new Image.asset("assets/images/Logo-1x.png",
                  height: 40.0, width: 80.0 , fit: BoxFit.fill, ),
                /*new Text(
                       'JAM    ',
                       textAlign: TextAlign.center,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(fontWeight: FontWeight.bold,background: paint ,  color: Colors.white, fontSize: 40.0, ),
                     ), */
                new Text(
                  'LOGIN USER',
                  textAlign: TextAlign.center,

                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 32.0,),
                ),
                SizedBox(height: 30),

                Container( padding: new  EdgeInsets.all(20),
                  child:
                  Column(children: <Widget>[

                    new TextFormField(
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
                        labelText: 'Email or Username',
                      ),

                    ),
                    SizedBox(height: 20),
                    new TextFormField(
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
                        labelText: 'Password',
                      ),
                    ),
                  ],
                  ),
                ),

                Container( padding: new  EdgeInsets.fromLTRB(25,0,25,25), child:  Row(
                  children: <Widget>[
                    Checkbox(value: _value1, onChanged: _value1Changed),
                    Text("Remember", ),
                    Spacer(),
                    Text("Forget Password?",  style: TextStyle( color: Colors.teal),),
                    // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                  ],
                ),),
                SizedBox(height: 10),
                new  RaisedButton(
                    color: Colors.teal,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(150,10,150,10),
                    //invokes _authUser function which validate data entered as well does the api call
                    child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20)
                    ),
                    onPressed: () {
                      _validateInputs();
                    }
                ),

                Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?"),

                    FlatButton( onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> SignupScreen()));},
                      child:
                      Text("Sign Up", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),)
                    // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                  ],
                ),),
                SizedBox(height: 30,),
                Text('Skip for Now',
                  textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),
              ]
          ),
        ),

      ),
    );


  }

  Future callLoginAPI() async {
    Map<String, String> data = new Map();

    data["email"] = txtUser.text;
    data["password"] = txtPass.text;
    data["access_type"] = 'api';

    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, 'http://jam.savitriya.com/api/v1/login', data);
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
        printLog("y0000");
        var data = json.decode(res.body);

        if(data['code'] == false) {

          print(data["message"]);
          showInfoAlert(context, data["message"]);
        } else {
          String r =data["email"];
          Preferences.saveObject("email", r);
//          getServices();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        }

      } else {
        printLog("login response code is not 200");

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
