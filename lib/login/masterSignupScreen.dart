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
    // TODO: implement initState
    // tabList.add(new Tab(icon: Icon(Icons.person), text: "FOR INDIVIDUAL",),);
    //tabList.add(new Tab(icon: Icon(Icons.people), text: "FOR ORGANISATION",),);
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


  String headerTitle = "CUSTOMER SIGN-UP";


  double viewHeight= 750;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30,),
                new Image.asset("assets/images/jamLogo.png",
                  height: 65.0, width: 120.0 , fit: BoxFit.fill,),

                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    child: new Image.asset("assets/images/signupMain.png",
                      height: 350.0, width: double.infinity, fit: BoxFit.fill, ),
                  ),
                ),
                SizedBox(height: 30,),
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
                new Image.asset("assets/images/bottomSignup.png",
                  height: 90.0, width: double.infinity, fit: BoxFit.fill, ),

//                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0),
//                    child: Container(
//                      height:60, decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
//                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
//                      child: TabBar(
//                        dragStartBehavior: DragStartBehavior.start,
////                        isScrollable: true,
//                        controller: _tabController,
//                        onTap:  onTap,
//                        isScrollable: false,
//                        indicatorColor: Configurations.themColor,
//                        labelColor: Colors.black,
//                        indicatorSize: TabBarIndicatorSize.tab,
//                        indicator: BoxDecoration(
//                            color: Configurations.themColor,
//                            borderRadius:BorderRadius.only(
//                                topRight: Radius.circular(10),
//                                topLeft: Radius.circular(10)
//                            )
//                        ),
//                        tabs:  <Widget>[
//                          Tab(icon: Icon(Icons.person), text: "Customer"),
//                          Tab(icon: Icon(MaterialIcons.work), text: "Service Provider"),
//                        ],
//                      ),
//                    ),
//                  ),
//                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10,10),
//                    child: Container(
//                      height: viewHeight,
////                        height: MediaQuery.of(context).size.height,
//                      decoration: BoxDecoration(
//                          border: Border.all(
//                              color: Configurations.themColor, width: 1
//                          ),
//                          borderRadius: BorderRadius.only(
//                              bottomLeft: Radius.circular(10),
//                              bottomRight: Radius.circular(10)
//                          )
//                      ),
//                      child:
//                      TabBarView(
//                        physics: NeverScrollableScrollPhysics(),
//                        controller:_tabController,
//                        children: <Widget>[
//                          CustomerSignup(fcm_token: fcmToken,),
////                          CustomerSignup(fcm_token: fcmToken,),
//                        VendorSignup(fcm_token: fcmToken,),
////                          vendor(),
//                        ],
//                      ),
//                    ),
//                  ),
              ]
          ),
        ),
      ),
    );
  }

//  void onTap(val) {
//    setState(() {
//      if(val == 0) {
//        globals.isCustomer = true;
//        headerTitle= "CUSTOMER SIGN-UP";
//        viewHeight = 730;
//
//      } else {
//        globals.isCustomer = false;
//        headerTitle= "SERVICE PROVIDER SIGN-UP";
//        viewHeight = 800;
//      }
//    });
//  }

}
