import 'dart:collection';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final GlobalKey<FormState> _forgetFormKey = GlobalKey<FormState>();
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
    globals.context = context;
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
            child: new Column(
//                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
//                  new Image.asset("assets/images/BG-1x.jpg",
//                    height: 250.0, width: double.infinity, fit: BoxFit.fill, ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10, top: 10),
                      child: DropdownButton(
                        underline: SizedBox(),
                        onChanged: ( Language language){
                          _changeLanguage(language);
                        },
                        icon: Icon(Icons.language, color: Configurations.themColor,),
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                          value:  lang,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget> [
                              Text(lang.flag),
                              Text(lang.name)
                            ],
                          ) ,
                        )).toList(),
                      ),)
                    ],
                  ),
//                SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,0,10),
                    child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/images/jamLogo.png",
                          height: 58.0, width: 110.0 , fit: BoxFit.fill, ),
                      ],
                    ),
                  ),
                   SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text(AppLocalizations.of(context).translate('txt_loginuser'),
                         textAlign: TextAlign.center,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Colors.deepOrangeAccent),
                       )
                     ],
                   ),

                //  SizedBox(height: 30),

                  Container( padding: new  EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child:
                    Column(children: <Widget>[
                      TextFormField(
                        focusNode: focus_email,
                        controller: txtUser,
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('login_txt_user');
                          }
                          return validateEmail(value);
                        },
                        cursorColor: Configurations.themColor,

                        obscureText: false,
                        decoration: InputDecoration(
                          //focusColor: Configurations.themColor,
                          //suffixIcon: Icon(Icons.face),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                            color: Configurations.themColor,
                            width: 0.9,
                          ), borderRadius: BorderRadius.circular(9.0),),
                          labelText: //"Email or Username"
                           AppLocalizations.of(context).translate('email_placeholder'),
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Configurations.themColor),
                          ),

                        ),

                      ),
                      SizedBox(height: 15),
                      new TextFormField(
                        focusNode: focus_pwd,
                        controller: txtPass,
                        cursorColor: Configurations.themColor,

                        validator: (value){
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('login_txt_pwd');
                          }
                          return null;
                        },

                        obscureText: true,
                        decoration: InputDecoration( suffixIcon: Icon(Icons.lock,color: Colors.grey,),focusColor: Configurations.themColor,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                            color: Configurations.themColor,
                            width: 0.9,
                          ), borderRadius: BorderRadius.circular(9.0),),
                          labelText:  AppLocalizations.of(context).translate('pwd_placeholder'),
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Configurations.themColor),
                          ),
                        ),
                      ),
                    ],
                    ),
                  ),

                  Container( padding: new  EdgeInsets.fromLTRB(25,0,25,10), child:  Row(
                    children: <Widget>[
                         Theme(data:ThemeData(unselectedWidgetColor: Configurations.themColor),
                           child: Checkbox(value: _value1, onChanged: _value1Changed), ),
                      Text(AppLocalizations.of(context).translate('txt_remember'),style: TextStyle(color: Colors.black), ),
                      Spacer(),
                      FlatButton(onPressed:(){
                        showDialog(context:  context,
                          builder: (BuildContext context) => setPasswordAgain(context),);
                      },child: Text(AppLocalizations.of(context).translate('txt_forget'),  style: TextStyle( color: Configurations.themColor),)),
                    ],
                  ),),
                  SizedBox(height: 5),
                  ButtonTheme(
                    minWidth: 300,
                    child: new  RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                           // side: BorderSide(color: Colors.red)
                        ),

                        color: Configurations.themColor,
                        textColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(120,10,120,10),
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
                  SizedBox(height: 16,),

                  SizedBox(height: 20,
                    child: Text("------------------------ OR ------------------------"),
                  ),
                  SizedBox(height: 10),

                  SignInButton(
                    Buttons.Facebook,
                    text: AppLocalizations.of(context).translate('btn_facebook'),

                   // padding: EdgeInsets.fromLTRB(120,10,120,10),
                    onPressed: () {
                      signinWithFacebook();
                    },
                  ),
                  SizedBox(height: 10,),

                  SignInButton(
                    Buttons.Google,
                    text: AppLocalizations.of(context).translate('btn_gmail'),
                    //padding: EdgeInsets.fromLTRB(120,10,120,10),
                    onPressed: () {
                      signinWithGmail();
                    },
                  ),


                  SizedBox(height: 10,),
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
            new Image.asset("assets/images/bottomLogin.png",
                    height: 90.0, width: double.infinity, fit: BoxFit.fill, ),



                ]
            ),
          ),

        ),
      ),
    );
  }

  void signinWithGmail() {
    Widget_Helper.showLoading(context);
    signInWithGoogle()
        .whenComplete(() {

      printLog("FINSH ");
    }).then((onValue) {
      print("RES === $onValue");
      if(onValue != null) {
        GoogleSignInAccount g_user = onValue[0];
        FirebaseUser  f_user = onValue[1];
        Map<String, String> data = new Map();
        data["first_name"] = g_user.displayName.split(" ")[0];
        if(g_user.displayName.split(" ")[1] != null){
          data["last_name"] = g_user.displayName.split(" ")[1];
        }

        data["password"] = g_user.id;
        data["email"] = g_user.email;
        data["image"] = g_user.photoUrl;

        data["social_signin"] = "gmail";
        print(data);
        callSocialAPI(data);
      }

    }).catchError((onError) {
      Widget_Helper.dismissLoading(context);
      print("onError === $onError");
    });
  }

  Future callSocialAPI(Map<String, String> data) async {
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
      if(globals.isCustomer ==true) {
        var syncUserResponse =
        await httpClient.postRequest(context, Configurations.REGISTER_URL, data, false);
        socialResponse(syncUserResponse);
      } else {
        var syncUserResponse =
        await httpClient.postRequest(context, Configurations.REGISTER_URL, data, false);
        socialResponse(syncUserResponse);
      }

    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void socialResponse(Response res) {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("come for response ==  ${data}");
        globals.currentUser = User.fromJson(data);
        globals.guest = false;
        Preferences.saveObject("user", jsonEncode(globals.currentUser.toJson()));
        if(data['existing_user'] == 1) {
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
        showInfoAlert(context, "ERROR");
      }
    }
  }



  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount googleSignInAccount;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List> signInWithGoogle() async {
    googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount.id != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      List  obj = new List();
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      obj.add(googleSignInAccount);
      obj.add(user);
      return obj;
    } else {
      return null;
    }
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
        Widget_Helper.dismissLoading(context);
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
        globals.guest = false;
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
        globals.currentUser = User.fromJson(data);
        print("currentUser ==  ${User.fromJson(data).toJson()}");
        globals.guest = false;
        if(globals.currentUser.address.length == 0) {
          print('NO ADDRESS');
          Preferences.saveObject("user", jsonEncode(User.fromJson(data)));
          Preferences.saveObject("profile", "1");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InitialProfileScreen(),
              ));
        } else {
          // location
          print('HMMM ADDRESS ${jsonEncode(globals.currentUser.toJson())}');
          Preferences.saveObject("user", jsonEncode(User.fromJson(data)));
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

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      callLoginAPI();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {

    if(isNumeric(value)) {
      Pattern pattern = r'^\+[1-9]{1}[0-9]{3,14}$'; //'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regex = new RegExp(pattern);
      if(!value.contains(new RegExp(r'\+[1-9]'), 0)) {
        return AppLocalizations.of(context).translate('invalid_phnno')+" +XXX missing";
      }
      if (!regex.hasMatch(value))
        return AppLocalizations.of(context).translate('invalid_phnno');
      //return AppLocalizations.of(context).translate('login_txt_validuser');
      else
        return null;
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return AppLocalizations.of(context).translate('invalid_email')+' ex: example@example.com';
      else
        return null;
    }


  }

  String email;
  String no;
  bool showChangePass = false;
  final txtemail= TextEditingController();
  final txtno = TextEditingController();

  final newPass = TextEditingController();
  final confPass = TextEditingController();
  Widget setPasswordAgain(BuildContext context){
    showChangePass = false;
    return AlertDialog(
      title: Center(
        child: Text(
          AppLocalizations.of(context).translate('forgot_title'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Configurations.themColor,
          ),
        ),
      ),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
       return Container( height: 250,
        child: Column(
          children: <Widget>[

            Visibility(child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(controller: txtemail,
                      obscureText: false,
                      cursorColor: Configurations.themColor,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email, color: Configurations.themColor),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                            color: Configurations.themColor,
                            width: 0.9,
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: AppLocalizations.of(context).translate('forgot_email_placeholder'),labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Configurations.themColor),
                        ),)
                  ),
                ),
                Text(AppLocalizations.of(context).translate('txt_or'),style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey
                ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child:
                  TextFormField(
                    controller: txtno,
                    obscureText: false,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.phone, color: Configurations.themColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Configurations.themColor,
                            width: 0.9,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: AppLocalizations.of(context).translate('forgot_number_placeholder'),labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Configurations.themColor),
                      ),),
                    keyboardType: TextInputType.phone,
                    cursorColor: Configurations.themColor,
                  ),
                ),
                SizedBox(height: 10,),
                ButtonTheme(minWidth: 300,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      // side: BorderSide(color: Colors.red)
                    ),
                    color: Configurations.themColor,
                    textColor: Colors.white,
                    child: Text(AppLocalizations.of(context).translate('btn_submit')),
                    onPressed: (){
                      validateer(setState);
                    },

                  ),)
              ],
            ),
              visible: !showChangePass,
            ),

            Visibility(child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(controller: newPass,
                      obscureText: true,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.lock, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: AppLocalizations.of(context).translate('newpwd'),
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Configurations.themColor),
                        ),), cursorColor: Configurations.themColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(controller: confPass,
                      obscureText: true,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.lock, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: AppLocalizations.of(context).translate('signin_confirm_pwd'),
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Configurations.themColor),
                        ),), cursorColor: Configurations.themColor,
                  ),
                ),
                SizedBox(height: 30,),
                ButtonTheme(minWidth: 300,
                  child: RaisedButton(
                    color: Configurations.themColor,
                    textColor: Colors.white,
                    child: Text(AppLocalizations.of(context).translate('btn_submit')),
                    onPressed: (){
                      validatePassword(setState);
                    },

                  ),)
            ],),
              visible: showChangePass,
            )


          ],
        ),
        key: _forgetFormKey,
      );
      }),
    );
  }

  void validateer(StateSetter setState){
//    _forgetFormKey.currentState.validate();

    if((txtemail.text.isEmpty)&&(txtno.text.isEmpty) ) {
      showInfoAlert(context, AppLocalizations.of(context).translate('alert1'));
      print(email);
    } else if((txtemail.text.isNotEmpty)&&(txtno.text.isNotEmpty)) {
      showInfoAlert(context, AppLocalizations.of(context).translate('alert1'));
    }
    else{
      if((txtemail.text.isNotEmpty)){
        String isValid = validateEmail(txtemail.text);
        if(isValid != null) {
          showInfoAlert(context, isValid);
        } else {
          print("email validation");
          print(txtemail.text);
          resetPassword("email", txtemail.text, setState);
        }

      } else if((txtno.text.isNotEmpty)) {
        String isValid = validatePhoneNumber(txtno.text);
        if(isValid != null) {
          showInfoAlert(context, isValid);
        } else {
          print("email validation");
          print(txtno.text);
          resetPassword("contact", txtno.text, setState);
        }
      }
    }
  }

  void resetPassword(String key, String Val, StateSetter setState) async {
    Map<String, String> data = new Map();
    data[key] = Val;
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
          await httpClient.postRequest(context, Configurations.RESET_PASSWORD_STATUS_URL, data, true);
      processResetResponse(syncUserResponse, setState);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  int resetUid = 0;
  void processResetResponse(Response res, StateSetter setState) {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        resetUid = data['id'];
        print("data::::::::${resetUid}");
        if(resetUid != 0 && resetUid != null) {
          setState(() {
            showChangePass = true;
          });
        }
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, data['message']);
      }
    }
  }

  void validatePassword(StateSetter setState) {
    if((newPass.text.isEmpty) && (newPass.text.isEmpty)) {
      showInfoAlert(context, AppLocalizations.of(context).translate('signup_txt_enterpwd'));
    } else if((newPass.text.isEmpty) || (newPass.text.isEmpty)) {
      showInfoAlert(context, AppLocalizations.of(context).translate('signup_txt_enterpwd'));
    } else if(newPass.text != confPass.text ) {
      showInfoAlert(context, AppLocalizations.of(context).translate('mismatchpwd'));
    } else {
      changePassword(setState);
    }
  }

  void changePassword(StateSetter setState) async {
    Map<String, String> data = new Map();
    data["id"] = resetUid.toString();
    data["password"] = newPass.text;
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
          await httpClient.postRequest(context, Configurations.CHANGE_PASSWORD_STATUS_URL, data, true);
      processChangeResponse(syncUserResponse, setState);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processChangeResponse(Response res, StateSetter setState) {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("data::::::::${data}");
        if(data['status'] == true) {
          Navigator.of(context).pop();
        }
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, data['message']);
      }
    }
  }
}
