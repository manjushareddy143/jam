import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/login/customerSignup.dart';
import 'package:jam/login/vendorSignup.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
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
      fcmToken = onValue;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }


  String headerTitle = "CUSTOMER SIGN-UP";


  double viewHeight= 730;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30,),
                  new Image.asset("assets/images/jamLogo.png",
                    height: 40.0, width: 95.0 , fit: BoxFit.fill,),
                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
                    child: new Text(
                      headerTitle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0,),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0),
                    child: Container(height:60, decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                      child: TabBar(
                        controller: _tabController,
                        onTap:  onTap,
                        indicatorColor: Configurations.themColor,
                        labelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(color: Configurations.themColor, borderRadius:BorderRadius.only(topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))
                        ),
                        tabs:  <Widget>[
                          Tab(icon: Icon(Icons.person), text: "Customer"),
                          Tab(icon: Icon(MaterialIcons.work), text: "Service Provider"),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10,10),
                    child: Container(height: viewHeight,decoration: BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                      child: TabBarView(controller:_tabController,
                        children: <Widget>[
                          CustomerSignup(fcm_token: fcmToken,),
                          vendor(),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

  void onTap(val) {
    print(val);
    setState(() {
      if(val == 0) {
        headerTitle= "CUSTOMER SIGN-UP";
        viewHeight = 730;
      } else {
        headerTitle= "SERVICE PROVIDER SIGN-UP";
        viewHeight = 630;
      }
    });
  }

}
