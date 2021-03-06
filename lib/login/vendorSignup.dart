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
//import 'package:url_launcher/url_launcher.dart';
import 'package:jam/app_localizations.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:jam/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class vendor extends StatelessWidget {

  final String fcm_token;

  const vendor({Key key, this.fcm_token}) : super(key: key);

  Widget build(BuildContext context) {
    // TODO: implement build
    return VendorSignup(fcm_token: this.fcm_token,);
  }
}
class VendorSignup extends StatefulWidget {
  //SignupPage({Key key, this.title}) : super(key: key);
  final String fcm_token;

  
   VendorSignup({Key key, this.fcm_token}) : super(key: key);
  @override
  _vendorSignup createState() => _vendorSignup(fcm_token: fcm_token, key: key);
}

class _vendorSignup extends State<VendorSignup>{
  final String fcm_token;

  _vendorSignup({Key key, @required this.fcm_token});
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
  bool obscureText = true;
  bool obscureText1 = true;
  List<DropdownMenuItem<String>> _dropDownTypes;
  String selectedCountry;
  FocusNode focus_email, focus_pwd,focus_cpwd,focus_fname, focus_lname,focus_no;
//  List _lstType = ["India", "Qatar"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focus_email = FocusNode();
    focus_pwd = FocusNode();
    focus_cpwd = FocusNode();
    focus_fname = FocusNode();
    focus_lname = FocusNode();
    focus_no = FocusNode();

    _dropDownTypes = buildAndGetDropDownMenuItems(listCountry);
    selectedCountry = _dropDownTypes[177].value;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    focus_email.dispose();
    focus_pwd.dispose();
    focus_cpwd.dispose();
    focus_fname.dispose();
    focus_lname.dispose();
    focus_no.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    globals.context = context;
    // TODO: implement build
    return GestureDetector(

      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Align(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: SingleChildScrollView(child: vendorScreenUI()),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget vendorScreenUI(){
    return Column(
      children: <Widget>[
        SizedBox(height: 50,),
        new Image.asset("assets/images/jamLogo.png",
          height: 40.0, width: 95.0 , fit: BoxFit.fill,),
        SizedBox(height: 20,),
        Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
          child: new Text(
            AppLocalizations.of(globals.context).translate('signin_txt_ven'),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0,color: Configurations.themColor),
          ),
        ),
        SizedBox(height: 10,),

        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            focusNode: focus_fname,
            enabled: _fridgeEdit,
            decoration: InputDecoration( suffixIcon: Icon(Icons.person, color: Colors.grey,),
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                  color: Configurations.themColor, width: 1,  ), ),
                labelText: AppLocalizations.of(globals.context).translate('signin_firstname_placeholder'),
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Configurations.themColor),
              ),
            ),cursorColor: Configurations.themColor,
            controller: txtName,//..text = 'KAR-MT30',
            validator: (value){
              if (value.isEmpty) {
                return AppLocalizations.of(globals.context).translate('signup_txt_enteruser');
              }
              return null;
            },
            //..text = 'KAR-MT30',

          ),
        ),
      SizedBox(height: 10,),

      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          focusNode: focus_lname,
          enabled: _fridgeEdit,
          decoration: InputDecoration( suffixIcon: Icon(Icons.person, color: Colors.grey),
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Configurations.themColor, width: 1,  ), ),
              labelText: AppLocalizations.of(globals.context).translate('signin_lastname_placeholder'),
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Configurations.themColor),
            ),), cursorColor: Configurations.themColor,
          controller: txtLname,//..text = 'KAR-MT30',
          validator: (value){
            if (value.isEmpty) {
              return AppLocalizations.of(globals.context).translate('signup_txt_enterlast');
            }
            return null;
          },

        ),
      ),
      SizedBox(height: 10,),

      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          focusNode: focus_email,
          enabled: _fridgeEdit,
          decoration: InputDecoration( suffixIcon: Icon(Icons.person, color: Colors.grey,),
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Configurations.themColor, width: 1,  ), ),
              labelText: AppLocalizations.of(globals.context).translate('profile_email_placeholder'),
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Configurations.themColor),
            ),
          ),
          cursorColor: Configurations.themColor,
          controller: txtEmail,//..text = 'KAR-MT30',
          validator: (value){
            if (value.isEmpty) {
              return AppLocalizations.of(globals.context).translate('profile_txt_enteremail');
            }
            return validateEmail(value);
          },
        ),
      ),
      SizedBox(height: 10,),

      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(flex: 2,
              child: Container(decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
                  border: Border.all(width: 0.9,color: Configurations.themColor)),
                width: 100,
                child: CountryCodePicker(
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

           // SizedBox( width: 10,),
            Flexible( flex: 4,
              child: TextFormField(
                focusNode: focus_no,
                enabled: _fridgeEdit,
                decoration: InputDecoration( suffixIcon: Icon(Icons.phone, color: Colors.grey),
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                      color: Configurations.themColor, width: 1,  ), ),
                    labelText: AppLocalizations.of(globals.context).translate('signin_phone_placeholder'),
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Configurations.themColor),
                  ),),
                cursorColor: Configurations.themColor,


                keyboardType: TextInputType.phone,
                controller: txtContact,//..text = 'KAR-MT30',

                validator: (value){
                  if (value.isEmpty) {
                    return AppLocalizations.of(globals.context).translate('signup_txt_enterno');
                  }
                  return validatePhoneNumber(value);
                },

              ),
            )

          ],
        ),
      ),
      SizedBox(height: 10,),

      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          focusNode: focus_pwd,
          enabled: _fridgeEdit,
          obscureText: obscureText1,
          decoration: InputDecoration( suffixIcon:
          IconButton(
            onPressed: (){
              obscureText1 = !obscureText1;
              setState(() {

              });
            },
            color: Colors.grey,
            icon: Icon(obscureText1 ? Icons.visibility_off :Icons.visibility),
          ),
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Configurations.themColor, width: 1,  ), ),
              labelText: AppLocalizations.of(globals.context).translate('signin_pwd_placeholder'),
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Configurations.themColor),
            ),),
          cursorColor: Configurations.themColor,

          controller: txtPass,//..text = 'KAR-MT30',
          validator: (value){
            if (value.isEmpty) {
              return AppLocalizations.of(globals.context).translate('signup_txt_enterpwd');
            }
            return null;
          },


        ),
      ),
      SizedBox(height: 10,),

      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          focusNode: focus_cpwd,
          enabled: _fridgeEdit,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: (){
                obscureText = !obscureText;
                setState(() {

                });
              },
              color: Colors.grey,
              icon: Icon(obscureText ? Icons.visibility_off :Icons.visibility),
            ),
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Configurations.themColor, width: 1,  ), ),
              labelText: AppLocalizations.of(globals.context).translate('signin_confirm_pwd'),
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Configurations.themColor),
            ),

          ), cursorColor: Configurations.themColor,
          validator: (value){
            if (value != txtPass.text) {
              return AppLocalizations.of(globals.context).translate('mismatchpwd');
            }
            return null;
          },


        ),
      ),
      SizedBox(height: 10,),

      //if(globals.isCustomer == false)
        setCountry(),

      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(value: _value1, onChanged: _value1Changed),
              if(globals.isCustomer ==true)
                Text(AppLocalizations.of(globals.context).translate('signin_txt_agree'), style: TextStyle(color: Colors.grey),),
              if(globals.isCustomer ==true)
                InkWell(
                  child: Text(
                    AppLocalizations.of(globals.context).translate('signin_txt_terms'),
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.orangeAccent),
                  ),
                  onTap: _launchURL,
                ),

              if(globals.isCustomer ==false)
                Text(
                  AppLocalizations.of(globals.context).translate('signin_txt_agree'),
                  style: TextStyle(color: Colors.grey),
                ),
              if(globals.isCustomer ==false)
                InkWell(
                  child: Text(
                      AppLocalizations.of(globals.context).translate('signin_txt_terms'),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.orangeAccent,
                      )),
                  onTap: _launchURL,
                ),

            ]
        ),
      ),
      // SizedBox(height: 10,),

      ButtonTheme(
        minWidth: 300.0,
        child:  RaisedButton(
            color: Configurations.themColor,


            textColor: Colors.white,
            child:  Text(

                AppLocalizations.of(globals.context).translate('signin_btn_signup'),
                style: TextStyle(fontSize: 16.5)
            ),
            onPressed: () {
              _validateInputs();
            }


        ),
      ),

      Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(AppLocalizations.of(globals.context).translate('signin_txt_text1')),

          FlatButton( onPressed:() {
            Navigator.push(
                context, new MaterialPageRoute(
              builder: (BuildContext context) => UserLogin(),
            )
            );
          },
            child: Text(
                AppLocalizations.of(globals.context).translate('btn_login'),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent)
            ),
          )
        ],
      ),),
        SizedBox(height: 10),

      Visibility(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20,
            child: Text("------------------------ " + AppLocalizations.of(context).translate('OR') +" ------------------------"),
          ),
          SizedBox(height: 10),
          SignInButton(
            Buttons.Facebook,
            text:  AppLocalizations.of(globals.context).translate('btn_facebook'),
            onPressed: () {
              signinWithFacebook();
            },
          ),
          SizedBox(height: 10),

          SignInButton(
            Buttons.Google,
            text:  AppLocalizations.of(globals.context).translate('btn_gmail'),
            onPressed: () {
              signinWithGmail();
            },
          ),

        ],
      ),
        visible: _hideSocialSignin,
      ),






      /// OTP ENTERY
      Visibility(
        visible: _showOTPField,
        //visible:true,
        child:
        Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              AppLocalizations.of(globals.context).translate('otp'),
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
//                  fieldWidth: 300.0,
//                  fontSize: 10,

              ),
            ),

            SizedBox(height: 10),

            ButtonTheme(
              minWidth: 300.0,
              child:  RaisedButton(
                  color: Configurations.themColor,
                  textColor: Colors.white,
                  child:  Text(
                      AppLocalizations.of(globals.context).translate('next'),
                      style: TextStyle(fontSize: 16.5)
                  ),
                  onPressed: () {
                    otpVerification();
                  }
              ),
            ),

//              Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text("Resend OTP"),
//                  IconButton(icon: Icon(Icons.refresh),
//                    onPressed: () {
//                    getOTP(txtContact.text);
////                      Map<String, String> data = new Map();
////                      data["first_name"] = txtName.text;
////                      data["last_name"] = txtLname.text;
////                      data["password"] = txtPass.text;
////
////                      data["email"] = txtEmail.text;
////                      data["contact"] = txtContact.text;
////                      callLoginAPI(data);
//                    },
//                  ),
//
//                ],
//              ),
//              ),

          ],
        ),
      ),

      Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset("assets/images/bottomSignup.png",
          width: double.infinity, fit: BoxFit.fitWidth, ),
      ),





    ],);
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
    const url = Configurations.BASE_URL + "/Terms_and_Condition_JAM.html";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw AppLocalizations.of(context).translate('launch_url')+' $url';
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
    Widget_Helper.showLoading(context);
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
          status = AppLocalizations.of(globals.context).translate('invalid');
          showInfoAlert(context, status);
        });
      }
    }).catchError((error) {
      setState(() {
        status = AppLocalizations.of(globals.context).translate('alert2');
        showInfoAlert(context, status);
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
          Widget_Helper.showLoading(context);

          String phone = selecteCode + txtContact.text;
          getOTP(phone);

//          Map<String, String> data = new Map();
//          data["contact"] = selecteCode + txtContact.text;
//          data["password"] = txtPass.text;
//          if(globals.isCustomer == true) {
//            data["type_id"] = "4";
//            data["term_id"] = "1";
//          } else {
//            data["first_name"] = txtName.text;
//            data["last_name"] = txtLname.text;
//            data["email"] = txtEmail.text;
//            data["type_id"] = "3";
//            data["term_id"] = "2";
//            data["resident_country"] = selectedCountry;
//          }
//          callLoginAPI(data);
        }
      } else {
        showInfoAlert(context, AppLocalizations.of(globals.context).translate('terms'));
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
          if(globals.currentUser.address.length > 0) {
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
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
          border: Border.all(width: 0.9,color: Configurations.themColor)),


        child: Row(
          children: [
            SizedBox(width: 5,),
            Text(
              AppLocalizations.of(globals.context).translate('signin_txt_country'),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: DropdownButton(
                  hint: Text(AppLocalizations.of(globals.context).translate('signin_txt_country')),
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
    //'signInWithGoogle succeeded: $user';
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
//    Widget_Helper.dismissLoading(context);
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
      printLog("verificationCompleted ${auth.toString()}");
      printLog("verificationCompleted ${auth}");
      status = AppLocalizations.of(globals.context).translate('alert4');
    });
    _authCredential = auth;
  }
  verificationFailed (AuthException authException) {
    printLog(txtContact.text);
    printLog(authException.message);
    setState(() {
      Widget_Helper.dismissLoading(context);
      status = '${authException.message}';
      if (authException.message.contains('not authorized'))
        status = AppLocalizations.of(globals.context).translate('alert2');
      else if (authException.message.contains('Network'))
        status = AppLocalizations.of(globals.context).translate('alert3');
//      else
//        status = 'Something has gone wrong, please try later';

      showInfoAlert(context, status);
    });
  }
  static String actualCode;

  codeSent (String verificationId, [int forceResendingToken]) async {
    actualCode = verificationId;
    printLog(txtContact.text);
    printLog("codeSent::: $actualCode");
    setState(() {
      _showOTPField = true;
      _hideSocialSignin = false;
      _fridgeEdit = false;
      Widget_Helper.dismissLoading(context);
    });
  }

  codeAutoRetrievalTimeout(String verificationId) {
    actualCode = verificationId;
    printLog("codeAutoRetrievalTimeout $actualCode");
    setState(() {
      status = "\nAuto retrieval time out:: $actualCode";
      Widget_Helper.dismissLoading(context);
      showInfoAlert(context, status);
    });
  }

}
