import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_signin_button/button_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/screens/initial_profile.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/widget/widget_helper.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jam/app_localizations.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class customer extends StatelessWidget {

  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomerSignup();
  }
}
class CustomerSignup extends StatefulWidget {
  //SignupPage({Key key, this.title}) : super(key: key);

  @override
  _customerSignup createState() => _customerSignup();
}
class _customerSignup extends State<CustomerSignup>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _showOTPField = false;
  bool _fridgeEdit = true;
  String pinCode = "";
  final txtLname=TextEditingController();
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPass = TextEditingController();
  final txtConfPass = TextEditingController();
  final txtContact = TextEditingController();
  bool _value1 = false;
  void _value1Changed(bool value) => setState(() => _value1 = value);

  var _authCredential;
  static String status;
  var firebaseAuth;
  Future getOTP(String phone) async{
    firebaseAuth = await FirebaseAuth.instance;
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

  }

  submitPin(String pin) {
    print(pin);
    pinCode = pin;
  }

  void otpVerification() async {
    await _signInWithPhoneNumber(pinCode);
  }


  Future _signInWithPhoneNumber(String smsCode) async {
    _authCredential = PhoneAuthProvider.getCredential(
      verificationId: actualCode,
      smsCode: smsCode,
    );

    firebaseAuth.signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        setState(() {
          Map<String, String> data = new Map();
          data["first_name"] = txtName.text;
          data["last_name"] = txtLname.text;
          data["password"] = txtPass.text;
          data["contact"] = txtContact.text;
          data["type_id"] = "4";
          data["term_id"] = "1";
          callLoginAPI(data);
        });
      } else {
        setState(() {
          status = 'Invalid code/invalid authentication';
          showInfoAlert(context, status);
        });
      }
    }).catchError((error) {
      setState(() {
        status = 'Something has gone wrong, please try later';
        showInfoAlert(context, status);
      });
    });
  }


  void _validateInputs() {

    if (_formKey.currentState.validate()) {
      if(_value1) {
        _formKey.currentState.save();
        printLog(txtContact.text);
        if (Platform.isAndroid) {
          Widget_Helper.showLoading(context);
          getOTP(txtContact.text);

          // Return here any Widget you want to display in Android Device.
          printLog('Android Device Detected');

        }
        else if(Platform.isIOS) {
          Map<String, String> data = new Map();
          data["first_name"] = txtName.text;
          data["last_name"] = txtLname.text;
          data["password"] = txtPass.text;
          data["contact"] = txtContact.text;
          data["type_id"] = "4";
          data["term_id"] = "1";
          callLoginAPI(data);
          // Return here any Widget you want to display in iOS Device.
          printLog('iOS Device Detected');
        }
        //

      } else {
        showInfoAlert(context, AppLocalizations.of(context).translate('terms'));
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }



  Future callLoginAPI(Map<String, String> data) async {
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      print('api call start signup');
      var syncUserResponse =
      await httpClient.postRequest(context, Configurations.REGISTER_URL, data);
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
        User user = User.fromJson(data);
        printLog(user.first_name);
        print(user.contact);
        Preferences.saveObject("user", jsonEncode(user.toJson()));
        if(data['existing_user'] == 1) {
          Preferences.saveObject("profile", "0");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()
              ),ModalRoute.withName('/'));
//          Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(
//                builder: (context) => HomeScreen(),
//              )
//          );
        } else {
          Preferences.saveObject("profile", "1");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InitialProfileScreen()
              ),ModalRoute.withName('/'));
//          Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(
//                builder: (context) => InitialProfileScreen(),
//              ));
        }

      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: customerScreenUI(),
    );
  }
  Widget customerScreenUI(){
    return Container(margin: EdgeInsets.all(13),
      child: Column( children: <Widget>[

        Material(elevation: 10.0,shadowColor: Colors.grey,
          child: TextFormField(


            decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                labelText: AppLocalizations.of(context).translate('signin_firstname_placeholder')
            ),
            controller: txtName,//..text = 'KAR-MT30',
            validator: (value){
              if (value.isEmpty) {
                return AppLocalizations.of(context).translate('signup_txt_enteruser');
              }
              return null;
            },
            //..text = 'KAR-MT30',

          ),
        ),
        SizedBox(height: 10,),


        Material(elevation: 10.0,shadowColor: Colors.grey,
          child: TextFormField(

            decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                labelText: AppLocalizations.of(context).translate('signin_lastname_placeholder')),
            controller: txtLname,//..text = 'KAR-MT30',
            validator: (value){
              if (value.isEmpty) {
                return AppLocalizations.of(context).translate('signup_txt_enterlast');
              }
              return null;
            },

          ),
        ),
        SizedBox(height: 10,),


        Material(elevation: 10.0,shadowColor: Colors.grey,
          child: TextFormField(


            decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                labelText: AppLocalizations.of(context).translate('signin_phone_placeholder')),

            keyboardType: TextInputType.phone,
            controller: txtContact,//..text = 'KAR-MT30',

            validator: (value){
              if (value.isEmpty) {
                return AppLocalizations.of(context).translate('signup_txt_enterno');
              }
              return null;
            },

          ),
        ),
        SizedBox(height: 10,),

        Material(elevation: 10.0,shadowColor: Colors.grey,
          child: TextFormField(

            obscureText: true,
            decoration: InputDecoration( suffixIcon: Icon(Icons.security),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                labelText: AppLocalizations.of(context).translate('signin_pwd_placeholder')),
            controller: txtPass,//..text = 'KAR-MT30',
            validator: (value){
              if (value.isEmpty) {
                return AppLocalizations.of(context).translate('signup_txt_enterpwd');
              }
              return null;
            },


          ),
        ),
        SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(value: _value1, onChanged: _value1Changed),
              Text(AppLocalizations.of(context).translate('signin_txt_agree'), style: TextStyle(color: Colors.grey),),
              InkWell(
                child: Text(
                  AppLocalizations.of(context).translate('signin_txt_terms'),
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.orangeAccent),
                ),
                //onTap: _launchURL,
              ),
            ]
        ),
       // SizedBox(height: 10,),





        ButtonTheme(
          minWidth: 300.0,
          child:  RaisedButton(
              color: Colors.teal,


              textColor: Colors.white,
              child:  Text(

                  AppLocalizations.of(context).translate('signin_btn_signup'),
                  style: TextStyle(fontSize: 16.5)
              ),
              onPressed: () {
                _validateInputs();
              }


          ),
        ),
        Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Already have an account?"),

            FlatButton( onPressed:() {
              Navigator.push(
                  context, new MaterialPageRoute(
                builder: (BuildContext context) => UserLogin(),
              )
              );
            },
              child: Text(
                  AppLocalizations.of(context).translate('btn_login'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent)
              ),
            )
          ],
        ),),



        /// OTP ENTERY
        Visibility(
          visible: _showOTPField,
          //visible:true,
          child:
          Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                'ENTER OTP',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Configurations.themColor),
              ),
              Container(padding: const EdgeInsets.all(1.0),
                child: PinEntryTextField(//fieldWidth: 500, fontSize: 100,
                    showFieldAsBox: false,
                    fields: 6,
                    onSubmit: submitPin
                ),
              ),

              SizedBox(height: 10),

              ButtonTheme(
                minWidth: 300.0,
                child:  RaisedButton(
                    color: Configurations.themColor,
                    textColor: Colors.white,
                    child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16.5)
                    ),
                    onPressed: () {
                      otpVerification();
                    }
                ),
              ),
              Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Resend OTP"),
                  IconButton(icon: Icon(Icons.refresh),
                    onPressed: () {
                      Map<String, String> data = new Map();
                      data["first_name"] = txtName.text;
                      data["last_name"] = txtLname.text;
                      data["password"] = txtPass.text;
                      data["contact"] = txtContact.text;
                      data["type_id"] = "4";
                      data["term_id"] = "1";
                      callLoginAPI(data);
                    },
                  ),

                ],
              ),
              ),
            ],
          ),
        )





      ],)
      ,);
  }

  verificationCompleted (AuthCredential auth) {
    printLog(txtContact.text);
    setState(() {
      status = 'Auto retrieving verification code';
    });
    _authCredential = auth;
  }
  verificationFailed (AuthException authException) {
    print("authException.message :${authException.message}");
    printLog(txtContact.text);
    setState(() {
      Widget_Helper.dismissLoading(context);
      status = '${authException.message}';
//      print("Error message: " + status);
      if (authException.message.contains('not authorized'))
        status = 'Something has gone wrong, please try later';
      else if (authException.message.contains('Network'))
        status = 'Please check your internet connection and try again';
      else
        status = 'Something has gone wrong, please try later';

      showInfoAlert(context, status);
    });
  }
  static String actualCode;
  codeSent (String verificationId, [int forceResendingToken]) async {
    actualCode = verificationId;
    printLog(txtContact.text);
    setState(() {
      _showOTPField = true;
      _fridgeEdit = false;
      Widget_Helper.dismissLoading(context);
    });
  }

  codeAutoRetrievalTimeout(String verificationId) {
    actualCode = verificationId;
    setState(() {
      status = "\nAuto retrieval time out:: $actualCode";
      Widget_Helper.dismissLoading(context);
      showInfoAlert(context, status);
    });
  }

}
