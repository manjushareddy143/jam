import 'dart:collection';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/widget/otp_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/main.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/login/masterSignupScreen.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

import 'package:jam/widget/widget_helper.dart';

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
  String fcmToken;
  final txtUser = TextEditingController();
  final txtPass = TextEditingController();

  void _value1Changed(bool value) => setState(() => _value1 = value);
  FocusNode focus_email, focus_pwd;

  @override
  void initState() {
    super.initState();
    focus_email = FocusNode();
    focus_pwd = FocusNode();
    globals.context = context;
    getFCMToken();
  }

  void getFCMToken() async  {
    await Preferences.readObject("fcm_token").then((onValue) async {
      fcmToken = onValue;
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focus_email.dispose();
    focus_pwd.dispose();

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
    printLog("testet"+_temp.languageCode);
    Preferences.saveObject('lang', _temp.countryCode);
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color= Configurations.themColor;
    return GestureDetector(
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
                      icon: Icon(Icons.language, color: Configurations.themColor,),
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
                  new Image.asset("assets/images/jamLogo.png",
                    height: 40.0, width: 80.0 , fit: BoxFit.fill, ),
                  /*new Text(
                         'JAM    ',
                         textAlign: TextAlign.center,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(fontWeight: FontWeight.bold,background: paint ,  color: Colors.white, fontSize: 40.0, ),
                       ), */
                  new Text(
                    AppLocalizations.of(context).translate('txt_loginuser'),
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
                        focusNode: focus_email,
                        controller: txtUser
                        ,
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('login_txt_user');
                          }
                          return validateEmail(value);
                        },

                        obscureText: false,
                        decoration: InputDecoration( suffixIcon: Icon(Icons.face),
                          border: OutlineInputBorder(),
                          labelText: //"Email or Username"
                           AppLocalizations.of(context).translate('email_placeholder'),
                        ),

                      ),
                      SizedBox(height: 20),
                      new TextFormField(
                        focusNode: focus_pwd,
                        controller: txtPass,
                        validator: (value){
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('login_txt_pwd');
                          }
                          return null;
                        },

                        obscureText: true,
                        decoration: InputDecoration( suffixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          labelText:  AppLocalizations.of(context).translate('pwd_placeholder'),
                        ),
                      ),
                    ],
                    ),
                  ),

                  Container( padding: new  EdgeInsets.fromLTRB(25,0,25,25), child:  Row(
                    children: <Widget>[
                      Checkbox(value: _value1, onChanged: _value1Changed),
                      Text(AppLocalizations.of(context).translate('txt_remember'), ),
                      Spacer(),
                      FlatButton(onPressed:(){
                        showDialog(context:  context,
                          builder: (BuildContext context) => setPasswordAgain(context),);
                      },child: Text(AppLocalizations.of(context).translate('txt_forget'),  style: TextStyle( color: Configurations.themColor),)),
                      // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                    ],
                  ),),
                  SizedBox(height: 10),
                  ButtonTheme(
                    minWidth: 300,
                    child: new  RaisedButton(

                        color: Configurations.themColor,
                        textColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(120,10,120,10),
                        //invokes _authUser function which validate data entered as well does the api call
                        child:  Text(
                            AppLocalizations.of(context).translate('btn_login'),
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
                      Text(AppLocalizations.of(context).translate('txt_dont')),

                      FlatButton( onPressed:() {
                        Navigator.push(
                            context, new MaterialPageRoute(
                            builder: (BuildContext context) => masterSignup()
                                //SignupScreen()
                          //masterSignup(),
                        )
                        );
                        },
                        child: Text(
                            AppLocalizations.of(context).translate('btn_signup'),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Configurations.themColor)
                        ),
                      )
                    ],
                  ),),
                  SizedBox(height: 10,),

                  SizedBox(height: 20,
                    child: Text("------------------------ OR ------------------------"),
                  ),

//                  SignInButton(
//                    Buttons.Google,
//                    text: "Sign in with Google",
//                    onPressed: () {
//      //                signinWithGmail();
//                    },
//                  ),

                  SizedBox(height: 10,),

                  SignInButton(
                    Buttons.Facebook,
                    text: "Sign in with Facebook",
                    onPressed: () {
                      signinWithFacebook();
                    },
                  ),

                  SizedBox(height: 30,),
                  FlatButton( onPressed: (){
                    globals.guest = true;
                    globals.isVendor = false;
                    globals.isCustomer=false;
                    print("I am a guest :)");
                    printLog(globals.guest);

                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                  },
                    child: Text(AppLocalizations.of(context).translate('txt_skip'),
                        textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),
                  ),



                ]
            ),
          ),

        ),
      ),
    );
  }

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  void signinWithFacebook() async {
    Widget_Helper.showLoading(context);
    final FacebookLoginResult result =
    await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        await FirebaseAuth.instance
            .signInWithCredential( FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token))
            .then((AuthResult authResult) async {
          print(authResult.user);
          _createUserFromFacebookLogin(
              result, authResult.user.uid);
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _createUserFromFacebookLogin(
      FacebookLoginResult result, String userID) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get('https://graph.facebook.com/v2'
        '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
    final profile = json.decode(graphResponse.body);
    print("profile :: $profile");
    Map<String, String> data = new Map();
    data["first_name"] = profile['first_name'];
    data["last_name"] = profile['last_name'];
    data["email"] = profile['email'];
    data["image"] = profile['picture']['data']['url'];
    data["password"] = profile['id'];
    data["social_signin"] = "facebook";
    Widget_Helper.dismissLoading(context);
    callSocialSignIn(data);
  }


  Future callSocialSignIn(Map<String, String> data) async {
    data["token"] = globals.fcmToken;
    if(globals.isCustomer == true) {
      data["type_id"] = "4";
      data["term_id"] = "1";
    } else {
      data["type_id"] = "3";
      data["term_id"] = "2";
    }
    if(Platform.isAndroid) {
      data["device"] = "Android";
    } else if (Platform.isIOS) {
      data["device"] = "IOS";
    }
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      print('api call start signup');
        var syncUserResponse =
        await httpClient.postRequest(context, Configurations.REGISTER_URL, data, false);
      processSocialResponse(syncUserResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processSocialResponse(Response res) {
    print("come for response ${res.statusCode}");
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("come for data ${data}");
        globals.currentUser = User.fromJson(data);
        printLog(globals.currentUser.first_name);
        print(globals.currentUser.contact);
        Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
        if(data['existing_user'] == 1) {
          print("COME INSIDE");
          Preferences.saveObject("profile", "0");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()
              ),ModalRoute.withName('/'));
        } else {
          Preferences.saveObject("profile", "1");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InitialProfileScreen()
              ),ModalRoute.withName('/'));
        }

      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }


  Future callLoginAPI() async {
    Map<String, String> data = new Map();

    if(isNumeric(txtUser.text)) {
      data["contact"] = txtUser.text;
    } else {
      data["email"] = txtUser.text;
    }
    data["password"] = txtPass.text;
    data["token"] = fcmToken;
    if(Platform.isAndroid) {
      data["device"] = "Android";
    } else if(Platform.isIOS) {
      data["device"] = "IOS";
    }

    printLog(data);

    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, Configurations.LOGIN_URL, data, true);
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
        print("data::::::::$data");
        globals.currentUser = User.fromJson(data);
        if(globals.currentUser.address.length == 0) {
          print('NO ADDRESS');
          Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
          Preferences.saveObject("profile", "1");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InitialProfileScreen(),
              ));
        } else {
          print('HMMM ADDRESS');
          Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
          Preferences.saveObject("profile", "0");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              )
          );
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

    if(isNumeric(value)) {
      Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return "Invalid Phone Number";
      //return AppLocalizations.of(context).translate('login_txt_validuser');
      else
        return null;
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return "Invalid Email Address";
      //return AppLocalizations.of(context).translate('login_txt_validuser');
      else
        return null;
    }


  }
  String email;
  String no;
  final txtemail= TextEditingController();
  final txtno = TextEditingController();
  Widget setPasswordAgain(BuildContext context){
    return AlertDialog(
      title: Center(
        child: Text(
          "Find Your Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
      ),
      content: Container( height: 250,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(controller: txtemail,
               /*  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('profile_txt_city');
                    }
                    return null;
                  }, */

                  obscureText: false, decoration: InputDecoration(suffixIcon: Icon(Icons.email),
              border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                      labelText: "Enter your email") ),

            ),
            Text("OR",style: TextStyle(
              fontWeight: FontWeight.bold,

            ),),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(controller: txtno,


                  obscureText: false,
                  decoration: InputDecoration(suffixIcon: Icon(Icons.phone),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                      labelText: "Enter your number"), keyboardType: TextInputType.phone, ),
            ),
            SizedBox(height: 10,),
            ButtonTheme(minWidth: 300,
            child: RaisedButton(
              color: Configurations.themColor,
              textColor: Colors.white,
              child: Text("Submit"),
              onPressed: (){
                validateer();
              },

            ),)
          ],
        ),
        key: _formKey,
      ),
    );
  }
  void validateer(){
   // _formKey.currentState.validate()

    if((txtemail.text.isNotEmpty)&&(txtno.text.isNotEmpty) ) {
      showInfoAlert(context, "please enter any one of the given!!");
      print(email);
      print(no);

    }
    else{
      if((txtemail.text.isNotEmpty) && (txtno.text.isEmpty)){
        email = txtemail.text;
        print("email validation");
        print(email);
        validateEmail(email);

      }
      else{
        print("number validation");
      }

    }
  }
}
