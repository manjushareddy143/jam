import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/login/customerSignup.dart';
import 'package:jam/login/vendorSignup.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/app_localizations.dart';
class masterSignup extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: masterSignupUIPage());
  }
}
class masterSignupUIPage extends StatefulWidget {

  @override
  _masterUIPageState createState() => _masterUIPageState();
}

class _masterUIPageState extends State<masterSignupUIPage> with TickerProviderStateMixin{
  TabController _tabController;
  String fcmToken;
  List<Tab> tabList = List();
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length:2);
    super.initState();
    getFCMToken();
  }

  void getFCMToken() async  {
    await Preferences.readObject("fcm_token").then((onValue) async {
      setState(() {
        fcmToken = onValue;
      });


      print("fcmToken $fcmToken");
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30,),
                  new Image.asset("assets/images/jamLogo.png",
                    height: 65.0, width: 120.0 , fit: BoxFit.fill,),

//                SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      child: new Image.asset("assets/images/signupMain.png",
                        height: 350.0, width: double.infinity, fit: BoxFit.fill, ),
                    ),
                  ),
//                SizedBox(height: 30,),
                  Padding(padding: EdgeInsets.only(left: 20, right: 20),
                    child: Center(
                      child: Text(AppLocalizations.of(context).translate('signin_txt_signup'), style: TextStyle(color: Configurations.themColor, fontWeight:
                      FontWeight.w600, fontSize: 18),),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ButtonTheme(
                      minWidth: 300,
                      child: new  RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            // side: BorderSide(color: Colors.red)
                          ),

                          color: Configurations.themColor,
                          textColor: Colors.white,
                          //padding: EdgeInsets.fromLTRB(120,10,120,10),
                          child:  Text(AppLocalizations.of(context).translate('signin_btn_customer'),
                            //AppLocalizations.of(context).translate('btn_login'),
                            style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: () {
                            globals.isCustomer = true;
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                                context, new MaterialPageRoute(
                                builder: (BuildContext context) => CustomerSignup(fcm_token: fcmToken,)
                            )
                            );

                          }
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ButtonTheme(
                      minWidth: 300,
                      child: new  RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            // side: BorderSide(color: Colors.red)
                          ),

                          color: Configurations.themColor,
                          textColor: Colors.white,
                          //padding: EdgeInsets.fromLTRB(120,10,120,10),
                          child:  Text(AppLocalizations.of(context).translate('signin_btn_serviceProvider'),
                            //AppLocalizations.of(context).translate('btn_login'),
                            style: TextStyle(fontSize: 14.0), overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: () {
                            globals.isCustomer = false;
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                                context, new MaterialPageRoute(
                                builder: (BuildContext context) => VendorSignup(fcm_token: fcmToken,)
                            )
                            );

                          }
                      ),
                    ),
                  ),



                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/images/bottomSignup.png",
                      width: double.infinity, fit: BoxFit.fitWidth, ),
                  ),



                ]
            ),
          ),
        ),
      ),
    );
  }

}
