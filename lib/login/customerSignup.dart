import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:google_sign_in/google_sign_in.dart';
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
import 'package:jam/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class customer extends StatelessWidget {

  final String fcm_token;

  const customer({Key key, this.fcm_token}) : super(key: key);

  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomerSignup(fcm_token: this.fcm_token,);
  }
}
class CustomerSignup extends StatefulWidget {
  final String fcm_token;

  CustomerSignup({Key key, this.fcm_token}) : super(key: key);
  @override
  _customerSignup createState() => _customerSignup(fcm_token: fcm_token, key: key);
}

class _customerSignup extends State<CustomerSignup>{
  final String fcm_token;

  _customerSignup({Key key, @required this.fcm_token});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _showOTPField = false;
  bool _hideSocialSignin = true;
  bool _fridgeEdit = true;
  String pinCode = "";
  final txtLname=TextEditingController();
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPass = TextEditingController();
  final txtConfPass = TextEditingController();
  final txtContact = TextEditingController();
  bool _value1 = false;
  List<DropdownMenuItem<String>> _dropDownTypes;
  String selectedCountry;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(listCountry);
    selectedCountry = _dropDownTypes[177].value;
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
    return Container(
      margin: EdgeInsets.fromLTRB(5, 20, 5, 10),
      child: Column( children: <Widget>[

        Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Material(elevation: 10.0,shadowColor: Colors.grey,
                child:
                CountryCodePicker(
                  onChanged: _onCountryChange,
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'QA',
                  favorite: ['+974','+91'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                  showFlag: true,
                  onInit: _initCountryCode,
                ),
              ),
            ),

            SizedBox( width: 10,),
            SizedBox(
              width: 198,
              child: Material(elevation: 10.0,shadowColor: Colors.grey,
                child: TextFormField(
                  enabled: _fridgeEdit,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                      labelText: AppLocalizations.of(context).translate('signin_phone_placeholder')),

                  keyboardType: TextInputType.phone,
                  controller: txtContact,

                  validator: (value){
                    if (value.isEmpty) {
                      return AppLocalizations.of(context).translate('signup_txt_enterno');
                    }
                    return validatePhoneNumber(value);
                  },

                ),
              ),
            )

          ],
        ),
        SizedBox(height: 10,),

        Material(elevation: 10.0,shadowColor: Colors.grey,
          child: TextFormField(
            enabled: _fridgeEdit,
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

        Material(elevation: 10.0,shadowColor: Colors.grey,
          child: TextFormField(
            enabled: _fridgeEdit,
            obscureText: true,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.security, ),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                labelText: "Confirm Password",
            ),
            validator: (value){
              if (value != txtPass.text) {
                return "Confirm password mismatch";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(value: _value1, onChanged: _value1Changed),
              if(globals.isCustomer ==true)
                Text(AppLocalizations.of(context).translate('signin_txt_agree'), style: TextStyle(color: Colors.grey),),
              if(globals.isCustomer ==true)
                InkWell(
                  child: Text(
                    AppLocalizations.of(context).translate('signin_txt_terms'),
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.orangeAccent),
                  ),
                  onTap: _launchURL,
                ),

              if(globals.isCustomer ==false)
                Text(
                  "Agree With ",
                  style: TextStyle(color: Colors.grey),
                ),
              if(globals.isCustomer ==false)
                InkWell(
                  child: Text(
                      AppLocalizations.of(context).translate('signin_txt_terms'),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.orangeAccent,
                      )),
                  onTap: _launchURL,
                ),
            ]
        ),
        // SizedBox(height: 10,),

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

        Visibility(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,
              child: Text("------------------------ OR ------------------------"),
            ),
            SignInButton(
              Buttons.Google,
              text: "Sign in with Google",
              onPressed: () {
                signinWithGmail();
              },
            ),
            SizedBox(height: 10),

            SignInButton(
              Buttons.Facebook,
              text: "Sign in with Facebook",
              onPressed: () {
                signinWithFacebook();
              },
            ),
          ],
        ),
          visible: _hideSocialSignin,),

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
                    child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16.5)
                    ),
                    onPressed: () {
                      otpVerification();
                    }
                ),
              ),
            ],
          ),
        )
      ],)
      ,);
  }

  String selecteCode = "";
  void _initCountryCode(code) {
    selecteCode = code.toString();
  }
  void _onCountryChange(countryCode) {
    //TODO : manipulate the selected country code here
    selecteCode = countryCode.toString();
  }

  _launchURL() async {
    const url = "http://www.savitriya.com/privacy-policy/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _value1Changed(bool value) => setState(() => _value1 = value);

  var _authCredential;
  static String status;
  var firebaseAuth;

  submitPin(String pin) {
    pinCode = pin;
  }

  void otpVerification() async {
    if(pinCode != "" && pinCode.length > 5) {
      Widget_Helper.showLoading(context);
      await _signInWithPhoneNumber(pinCode);
    } else {
      showInfoAlert(context, "Please enter OTP");
    }

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
          data["password"] = txtPass.text;
          data["contact"] = selecteCode + txtContact.text;
          if(globals.isCustomer == true) {
            data["type_id"] = "4";
            data["term_id"] = "1";
          } else {
            data["email"] = txtEmail.text;
            data["first_name"] = txtName.text;
            data["last_name"] = txtLname.text;
            data["type_id"] = "3";
            data["term_id"] = "2";
            data["resident_country"] = selectedCountry;
          }
          callLoginAPI(data);
        });
      } else {
        setState(() {
          status = 'Invalid code/invalid authentication';
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


  void _validateInputs() {
    printLog("FCM ++ ${this.fcm_token}");
    if (_formKey.currentState.validate()) {
      if(_value1) {
        _formKey.currentState.save();
        if (Platform.isAndroid) {
          Widget_Helper.showLoading(context);
          String phone = selecteCode + txtContact.text;
          getOTP(phone);
        }
        else if(Platform.isIOS) {
          Map<String, String> data = new Map();
          data["contact"] = selecteCode + txtContact.text;
          data["password"] = txtPass.text;
          if(globals.isCustomer == true) {
            data["type_id"] = "4";
            data["term_id"] = "1";
          } else {
            data["first_name"] = txtName.text;
            data["last_name"] = txtLname.text;
            data["email"] = txtEmail.text;
            data["type_id"] = "3";
            data["term_id"] = "2";
            data["resident_country"] = selectedCountry;
          }
          callLoginAPI(data);
        }
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
    data["token"] = globals.fcmToken;
    if(globals.isCustomer == true) {
      data["type_id"] = "4";
      data["term_id"] = "1";
    } else {
      data["type_id"] = "3";
      data["term_id"] = "2";
      if(data.containsKey("social_signin")) {
      } else {
        data["resident_country"] = selectedCountry;
      }
    }
    if(Platform.isAndroid) {
      data["device"] = "Android";
    } else if (Platform.isIOS) {
      data["device"] = "IOS";
    }
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      if(globals.isCustomer ==true) {
        var syncUserResponse =
        await httpClient.postRequest(context, Configurations.REGISTER_URL, data, false);
        processLoginResponse(syncUserResponse);
      } else {
        var syncUserResponse =
        await httpClient.postRequest(context, Configurations.REGISTER_URL, data, false);
        processLoginResponse(syncUserResponse);
      }
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
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }


  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key) {
      items.add(DropdownMenuItem(value: key["name"], child: Text(key["name"])));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      selectedCountry = selectedItem;
      printLog(selectedCountry);
    });
  }

  Widget setCountry() {
    return Material(
      elevation: 5.0,
      shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: [
            Text(
              "Select Country",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: DropdownButton(
                  hint: Text('Select Country'),
                  underline: SizedBox(),
                  isExpanded: true,
                  value: selectedCountry,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Configurations.themColor,
                  ),
                  items: _dropDownTypes,
                  onChanged: changedDropDownItem),
            ),
          ],
        ),
      ),
    );
  }

  void signinWithGmail() {
    Widget_Helper.showLoading(context);
    signInWithGoogle()
        .whenComplete(() {
    }).then((onValue) {
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
        callLoginAPI(data);
      }

    }).catchError((onError) {
      Widget_Helper.dismissLoading(context);
      print("onError === $onError");
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount googleSignInAccount;


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
        Widget_Helper.dismissLoading(context);
        break;
      case FacebookLoginStatus.error:
        Widget_Helper.dismissLoading(context);
        break;
    }
  }

  void _createUserFromFacebookLogin(
      FacebookLoginResult result, String userID) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get('https://graph.facebook.com/v2'
        '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
    final profile = json.decode(graphResponse.body);
    Map<String, String> data = new Map();
    data["first_name"] = profile['first_name'];
    data["last_name"] = profile['last_name'];
    data["email"] = profile['email'];
    data["image"] = profile['picture']['data']['url'];
    data["password"] = profile['id'];
    data["type_id"] = "4";
    data["term_id"] = "1";
    data["social_signin"] = "facebook";
    callLoginAPI(data);
  }

  Future getOTP(String phone) async{
    firebaseAuth = await FirebaseAuth.instance;
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  verificationCompleted (AuthCredential auth) {
    printLog(txtContact.text);
    setState(() {
      status = 'Auto retrieving verification code';
    });
    _authCredential = auth;
  }

  verificationFailed (AuthException authException) {
    setState(() {
      Widget_Helper.dismissLoading(context);
      status = '${authException.message}';
      if (authException.message.contains('not authorized'))
        status = 'Something has gone wrong, please try later';
      else if (authException.message.contains('Network'))
        status = 'Please check your internet connection and try again';
      showInfoAlert(context, status);
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
    });
  }

  codeAutoRetrievalTimeout(String verificationId) {}

}
