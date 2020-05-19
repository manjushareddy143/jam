import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
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
  bool _autoValidate = false;
  bool _showOTPField = false;
  String pinCode = "";


  bool arabic = false;
  bool english = false;
  final txtLname=TextEditingController();
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPass = TextEditingController();
  final txtConfPass = TextEditingController();
  final txtContact = TextEditingController();
  bool _value1 = false;
  void _value1Changed(bool value) => setState(() => _value1 = value);
  FocusNode focus_firstname, focus_lastname, focus_phone, focus_pwd;
  @override
  void initState() {
    super.initState();

    focus_firstname = FocusNode();
    focus_lastname = FocusNode();
    focus_phone = FocusNode();
    focus_pwd = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focus_lastname.dispose();
    focus_firstname.dispose();
    focus_phone.dispose();
    focus_pwd.dispose();

    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: signupScreenUI(),
          ),
        ),
      ),
    );
  }


  bool _fridgeEdit = true;

  Widget signupScreenUI() {
    return Container(margin: EdgeInsets.all(20),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),

          Image.asset("assets/images/Logo-1x.png",
            height: 60.0, width: 120.0 , fit: BoxFit.fill, ),

          SizedBox(height: 5,),

          Text(AppLocalizations.of(context).translate('signin_txt_signup'),
            //'SIGN UP',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 32.0,),
          ),
          // NORMAL
          SizedBox(height: 30,),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  <Widget>[
              Material(elevation: 10.0,shadowColor: Colors.grey,
                child: TextFormField(
                  focusNode: focus_firstname,
                  enabled: _fridgeEdit,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                      labelText: AppLocalizations.of(context).translate('signin_firstname_placeholder'),),
                  controller: txtName,//..text = 'KAR-MT30',
                  validator: (value){
                    if (value.isEmpty) {
                      return AppLocalizations.of(context).translate('signup_txt_enteruser');
                    }
                    return null;
                  },
                ),
              ),

               SizedBox(height: 10,),
               Material(elevation: 10.0,shadowColor: Colors.grey,
                 child: TextFormField(
                   focusNode: focus_lastname,
                   enabled: _fridgeEdit,
                   decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                     contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                   labelText: AppLocalizations.of(context).translate('signin_lastname_placeholder'),),
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
                  focusNode: focus_phone,
                  enabled: _fridgeEdit,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: AppLocalizations.of(context).translate('signin_phone_placeholder'),),
                  controller: txtContact,//..text = 'KAR-MT30',
                  keyboardType: TextInputType.phone,
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
                  focusNode: focus_pwd,
                  enabled: _fridgeEdit,
                  obscureText: true,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.security),
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    labelText: AppLocalizations.of(context).translate('signin_pwd_placeholder'),),
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

             Row(
               children: <Widget>[
                Checkbox(value: _value1, onChanged: _value1Changed),
                 Text(AppLocalizations.of(context).translate('signin_txt_agree'), style: TextStyle(color: Colors.grey),),
                 InkWell(
                   child: Text(
                     AppLocalizations.of(context).translate('signin_txt_terms'),
                     style: TextStyle(decoration: TextDecoration.underline, color: Colors.lightBlueAccent),
                   ),
                   onTap: _launchURL,
                 ),
//                InkWell(
//                    child: Text("Agree With Terms And Condition", style: TextStyle(color: Colors.grey),),
//                    onTap: () async {
//                      _launchURL();
//                    }
//                ),
//                Text("Agree With Terms And Condition", style: TextStyle(color: Colors.grey),),
               ]
             )
            ],
          ),

          SizedBox(height: 10),

        ButtonTheme(
          minWidth: 300.0,
          child:  RaisedButton(
              color: Configurations.themColor,
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



          /// OTP ENTERY
          Visibility(
            visible: _showOTPField,
            child:
          Column(
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                'ENTER OTP',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Configurations.themColor),
              ),
              PinEntryTextField(
                  showFieldAsBox: false,
                  fields: 6,
                  onSubmit: submitPin
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
                    callLoginAPI();
                    },
                  ),

                ],
              ),
              ),
            ],
          ),

          )
        ],
      ),
    );
  }

  _launchURL() async {
    const url = "http://www.savitriya.com/privacy-policy/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  submitPin(String pin) {
    print(pin);
    pinCode = pin;
  }

  void otpVerification() async {
    await _signInWithPhoneNumber(pinCode);
  }

  static String status;
  void _validateInputs() {

    if (_formKey.currentState.validate()) {
      if(_value1) {
        _formKey.currentState.save();
        printLog(txtContact.text);
        if (Platform.isAndroid) {
          Widget_Helper.showLoading(context);
         // getOTP(txtContact.text);
          callLoginAPI();

          // Return here any Widget you want to display in Android Device.
          printLog('Android Device Detected');

        }
        else if(Platform.isIOS) {
          callLoginAPI();




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

  var firebaseAuth;
  Future getOTP(String phone) async{
    firebaseAuth = await FirebaseAuth.instance;
  //  printLog("hello");
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

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

  var _authCredential;
  verificationCompleted (AuthCredential auth) {
    printLog(txtContact.text);
    setState(() {
      status = 'Auto retrieving verification code';
    });
    _authCredential = auth;
//    Widget_Helper.dismissLoading(context);
//    firebaseAuth.signInWithCredential(_authCredential)
//        .then((AuthResult value) {
//      if (value.user != null) {
//        setState(() {
//          print(value.user);
//          status = 'Authentication successful';
//        });
//
//      } else {
//        setState(() {
//          status = 'Invalid code/invalid authentication';
//        });
//      }
//    }).catchError((error) {
//      setState(() {
//        status = 'Something has gone wrong, please try later';
//      });
//    });
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
          callLoginAPI();
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

  Future callLoginAPI() async {
    Map<String, String> data = new Map();
    data["first_name"] = txtName.text;
    data["last_name"] = txtLname.text;
    data["password"] = txtPass.text;
    data["contact"] = txtContact.text;
    data["type_id"] = "4";
    data["term_id"] = "1";
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
        Preferences.saveObject("profile", "1");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitialProfileScreen()
            ),ModalRoute.withName('/'));
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }





}