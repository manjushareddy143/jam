import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:intent/extra.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
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

import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
import 'dart:async' show StreamController;
import 'dart:io';
import 'package:share/share.dart';
import 'dart:ui' as ui;



class UserLogin extends StatefulWidget {
  _user createState() => new _user();
}

class _user extends State<UserLogin>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _forgetFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool obscureText = true;
  bool obscureText2 = true;
  bool obscureText3 = true;
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

        body: Align(
          alignment: Alignment.bottomCenter,
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child:  SingleChildScrollView(
              child: new Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 50),
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
                                Text(AppLocalizations.of(context).translate(lang.flag)),
                                  Text(lang.name)
                                ],
                              ) ,
                            )).toList(),
                          ),
                        ),
                      ],
                    ),



                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/images/jamLogo.png",
                            height: 50.0, width: 110.0 , fit: BoxFit.fill, ),
                        ],
                      ),
                    ),
//                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).translate('txt_loginuser'),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.deepOrangeAccent),
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

                          obscureText: obscureText,
                          decoration: InputDecoration( suffixIcon:
                          IconButton(
                          onPressed: (){
                            obscureText = !obscureText;
                            setState(() {

                            });
                          },
                            color: Colors.grey,
                            icon: Icon(obscureText ? Icons.visibility_off :Icons.visibility),

                          ),focusColor: Configurations.themColor,
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
                          showChangePass = true;
                          showDialog(context:  context,
                            builder: (BuildContext context) => setPasswordAgain(context),);
                        },child: Text(AppLocalizations.of(context).translate('txt_forget'),  style: TextStyle( color: Configurations.themColor),)),
                      ],
                    ),),
//                    SizedBox(height: 5),
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
//                    SizedBox(height: 16,),

                    SizedBox(height: 20,
                      child: Text("------------------------ " + AppLocalizations.of(context).translate('OR') +" ------------------------"),
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


//                    SizedBox(height: 10,),
                    FlatButton( onPressed: (){
                      globals.guest = true;
                      globals.isVendor = false;
                      globals.isCustomer=false;
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                    },
                      child: Text(AppLocalizations.of(context).translate('txt_skip'),
                        textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),
                    ),
                    Visibility(
                      visible: _showOTPField,

                      //visible:true,
                      child:
                      Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Text(
                            AppLocalizations.of(context).translate('otp'),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Configurations.themColor),
                          ),
                          Container(padding: EdgeInsets.all(0),
                            width: 320,
                            height: 50,
                            child: PinEntryTextField(//fieldWidth: 500, fontSize: 100,
                              showFieldAsBox: false,
                              fields: 6,
                              onSubmit: submitPin,
                            ),
                          ),

                          SizedBox(height: 10),

                          ButtonTheme(
                            minWidth: 300.0,
                            child:  RaisedButton(
                                color: Configurations.themColor,
                                textColor: Colors.white,
                                child:  Text(
                                    AppLocalizations.of(context).translate('next'),
                                    style: TextStyle(fontSize: 16.5)
                                ),
                                onPressed: () {
                                  if(isNo == true)
                                  {otpVerification();}
                                  else
                                    {_otpVerificationEmail();}

                                }
                            ),
                          ),
                        ],
                      ),
                    ),

                    FlatButton(onPressed: () {
                      instgramOpen();
                    }, child: Text("INSTAGRAM")
                    ),


                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset("assets/images/bottomSignup.png",
                         fit: BoxFit.fitWidth, ),
                    ),



                  ]
              ),
            ),

          ),
        )
      ),
    );
  }

  Future<void> instgramOpen() async {

//    String directory = (await getTemporaryDirectory()).path;
//    printLog(directory);

    try {
      var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);

      final documentDirectory = (await getExternalStorageDirectory()).path;

      File imgFile = new File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      final RenderBox box = context.findRenderObject();


      Share.shareFiles(['${documentDirectory}/flutter0.png'], text: 'Great picture',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size, subject: "Test");
    } on PlatformException catch (e) {
      print("Exception while taking screenshot:" + e.toString());
    }


//    try {
//      RenderRepaintBoundary boundary =
//      _primeKey.currentContext.findRenderObject();
//      if (boundary.debugNeedsPaint) {
//        Timer(Duration(seconds: 1), () => shareScreenshot());
//        return null;
//      }
//      ui.Image image = (await rootBundle.load('assets/images/ac.jpeg')) as ui.Image;
//
//      final directory = (await getExternalStorageDirectory()).path;
//      printLog(directory);
//      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//      Uint8List pngBytes = byteData.buffer.asUint8List();
//      File imgFile = new File('$directory/ac.jpeg');
//      imgFile.writeAsBytes(pngBytes);
//      final RenderBox box = context.findRenderObject();
//      Share.shareFiles(['$directory/ac.jpeg'],
//          subject: 'Share ScreenShot',
//          text: 'Hello, check your share files!',
//          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
//      );
//    } on PlatformException catch (e) {
//      print("Exception while taking screenshot:" + e.toString());
//    }


//    var path = 'images/ac.jpeg';
//    final byteData = await rootBundle.load('assets/$path');
//    File file = new File('${(await getTemporaryDirectory()).path}/$path');
//    printLog(file.path);
//
//    final filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
//    File tempFile = File(filePath);
//
//    Uri uri = Uri.file('${(await getTemporaryDirectory()).path}/$path');
//
//    android_intent.Intent share = android_intent.Intent()..setAction(android_action.Action.ACTION_SEND);
//    share.setType('image/*');
//    share.putExtra(Extra.EXTRA_STREAM, uri);
//
//    share.startActivity(createChooser: true);
//
//
//
//    android_intent.Intent()
//      ..setAction(android_action.Action.ACTION_SEND)
//      ..setType('image/*')
//      ..setPackage('shareFile')
//      ..setData(file.uri)
//      ..putExtra(Extra.EXTRA_STREAM, file.uri)
//      ..startActivityForResult().then(
//            (data) => print(data),
//        onError: (e) => print(e.toString()));

  }

  String pinCode = "";
  submitPin(String pin) {
    pinCode = pin;
  }
  void otpVerification() async {
    printLog("otpVerification ::: ");
    if(pinCode != "" && pinCode.length > 5) {
      Widget_Helper.showLoading(context);
      await _signInWithPhoneNumber(pinCode);
    } else {
      showInfoAlert(context, AppLocalizations.of(context).translate('enter_otp'));
    }

  }
  Future _otpVerificationEmail() async {
    otpVerify("otp" ,pinCode, setState);
  }
  Future  _signInWithPhoneNumber(String smsCode) async {
    _authCredential = PhoneAuthProvider.getCredential(
      verificationId: actualCode,
      smsCode: smsCode,
    );

    firebaseAuth.signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        setState(() {


          resetPassword("contact", txtno.text, setState);
//          Map<String, String> data = new Map();
//          data["password"] = txtPass.text;
//          data["contact"] =  txtno.text;
//          if(globals.isCustomer == true) {
//            data["type_id"] = "4";
//            data["term_id"] = "1";
//          } else {
//            data["email"] = txtEmail.text;
//            data["first_name"] = txtName.text;
//            data["last_name"] = txtLname.text;
//            data["type_id"] = "3";
//            data["term_id"] = "2";
//            data["resident_country"] = selectedCountry;
//          }
//          callLoginAPI(data);

        });



      } else {
        setState(() {
          status = AppLocalizations.of(context).translate('invalid');
          Widget_Helper.dismissLoading(context);
          showInfoAlert(context, status);
        });
      }
    }).catchError((error) {
      setState(() {
        Widget_Helper.dismissLoading(context);
        showInfoAlert(context, error.message);
        _showOTPField = false;
        _hideSocialSignin = true;
        _fridgeEdit = true;

      });
    });
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
  //  showChangePass = true;

    txtno.text = "+974";
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
               visible: showChangePass,
             ),

             Visibility(child: Column(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(top: 10, bottom: 10),
                   child: TextFormField(controller: newPass,
                       obscureText: obscureText2,
                       decoration: InputDecoration(
                           suffixIcon: IconButton(
                             onPressed: (){
                               obscureText2 = !obscureText2;
                               setState(() {

                               });
                             },
                             color: Colors.grey,
                             icon: Icon(obscureText ? Icons.visibility_off :Icons.visibility),

                           ),
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
                       obscureText: obscureText3,
                       decoration: InputDecoration(
                           suffixIcon:  IconButton(
                             onPressed: (){
                               obscureText3 = !obscureText3;
                               setState(() {

                               });
                             },
                             color: Colors.grey,
                             icon: Icon(obscureText ? Icons.visibility_off :Icons.visibility),
                           ),
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
               visible: showPass,
             )


           ],
         ),
       );
      }),
    );
  }
  bool showPass = false;

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
        } else if(txtemail.text.isNotEmpty){
          print("email validation");
          print(txtemail.text);
          Navigator.of(context).pop();
          resetPassword("email", txtemail.text, setState);
//          Widget_Helper.showLoading(context);
          String email =  txtemail.text;
          getEmail(email);
        }

      } else if((txtno.text.isNotEmpty)) {
        String isValid = validatePhoneNumber(txtno.text);
        if(isValid != null) {
          showInfoAlert(context, isValid);
        } else {
          print("Number validation");
          print(txtno.text);
          Navigator.of(context).pop();
          Widget_Helper.showLoading(context);
          String phone =  txtno.text;
          getOTP(phone);

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
        print("data::::::::$resetUid");
        if(resetUid != 0 && resetUid != null) {
          printLog("come inside::::");
          setState(() {
            showChangePass = false;
            showPass = true;
            showDialog(context:  context,
              builder: (BuildContext context) => setPasswordAgain(context),);
          });
        }
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, data['message']);
      }
    }
  }


  void otpVerify(String key, String Val, StateSetter setState) async {
    Map<String, String> data = new Map();
    data[key] = Val;
    printLog("otp ::: $key");
    printLog("otp ::: $Val");
    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, Configurations.RESET_PASSWORD_EMAIL, data, true);
      processOtpVerifyResponse(syncUserResponse, setState);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processOtpVerifyResponse(Response res, StateSetter setState) {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("data::::::::$resetUid");
        setState(() {
          _showOTPField = false;
          showChangePass = false;
          showPass = true;
          showDialog(context:  context,
            builder: (BuildContext context) => setPasswordAgain(context));
        });
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, data['message']);
      }
    }
  }



  bool _showOTPField = false;
  bool _hideSocialSignin = true;
  bool _fridgeEdit = true;
  var _authCredential;
  static String status;
  var firebaseAuth;
  bool isNo = false;

  Future getOTP(String phone) async{
    isNo = true;

    firebaseAuth = await FirebaseAuth.instance;
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    print("otp step all done");
  }

  Future getEmail(String email) async {
    isNo = false;
    Map<String, String> data = new Map();
    printLog("data : $email");
    _showOTPField = true;
    setState(() {
    });
  }

  verificationCompleted (AuthCredential auth) {
    printLog(txtno.text);
    setState(() {
      print("otp step 1");
      status = AppLocalizations.of(context).translate('alert4');
    });
    _authCredential = auth;

  }

  verificationFailed (AuthException authException) {
    setState(() {
      Widget_Helper.dismissLoading(context);
      status = '${authException.message}';
      if (authException.message.contains('not authorized'))
        status = AppLocalizations.of(context).translate('alert2');
      else if (authException.message.contains('Network'))
        status = AppLocalizations.of(context).translate('alert3');
      showInfoAlert(context, status);
      print("otp step 2");
    });
  }

  static String actualCode;

  codeSent (String verificationId, [int forceResendingToken]) async {
    actualCode = verificationId;
    setState(() {

      _showOTPField = true;
      _hideSocialSignin = false;
      _fridgeEdit = false;
      Widget_Helper.dismissLoading(context);
      print("otp step 3");

    });
  }

  codeAutoRetrievalTimeout(String verificationId) {}


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
        print("showotpfield;;;;;$_showOTPField");
        _showOTPField = false;
        print("showotpfield;;;;;$_showOTPField");
        if(data['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context, new MaterialPageRoute(
              builder: (BuildContext context) => UserLogin()
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
}
