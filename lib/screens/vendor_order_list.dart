import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:jam/models/order.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/order_detail_screen.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/screens/customer_order_list.dart';
class Orders extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return VendorOrderUIPage(); //Center(child: );
  }
}
class VendorOrderUIPage extends StatefulWidget {
  VendorOrderUIPage({Key key, @required user,}) : super(key: key);
  @override
  _VendorOrderState createState() => _VendorOrderState();
}
class _VendorOrderState extends State<VendorOrderUIPage> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    globals.context = context;
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length:2);
  }

  double _width = 0.0;
  double _height = 0.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: SingleChildScrollView(
        child: setOrderUI(),

      /*  Center(
          child:Padding(padding: EdgeInsets.fromLTRB(5, 10, 5,10),
          child: Column( crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0),
              child: Container(height:70,decoration: BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: TabBar(
                  onTap:  onTap,
                  controller: _tabController,
                  indicatorColor: Configurations.themColor,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(color: Configurations.themColor, borderRadius:BorderRadius.only(topRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),

                  tabs:  <Widget>[
                    Tab(icon: Icon(Icons.home), text: "Your Bookings"),
                    Tab(icon: Icon(Icons.work), text: "Customer Bookings"),

                  ],
                ),
              ),
            ),
          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10,10),
            child: Container(
                height: 500,
              child: TabBarView(controller:_tabController,


                children: <Widget>[
                  OrderUIPage(url: Configurations.BOOKING_URL, isCustomer: true,),
                  OrderUIPage(url: Configurations.PROVIDER_BOOKING_URL, isCustomer: false,),
                ],),
            ),),


          ],),)
        ), */
      ),
    );
  }

  Widget setOrderUI() {
    return Stack(
      children: <Widget>[
        new Column(
          children: <Widget>[

            new Container(
              height: MediaQuery.of(context).size.height * .25,
              width: MediaQuery.of(context).size.height * .50,
              color: Colors.grey[800],
              child: Container(
                padding: EdgeInsets.only(left: 50, right: 50, bottom: 90, top: 20),
                child: Image.asset("assets/images/jamLogoWhite.png", fit: BoxFit.contain, height: 20,
                  width: 20.0,
                ),
              ),
            ),

            new Container(
//              height: MediaQuery.of(context).size.height * .75,
              color: Colors.white,
            )
          ],
        ),

        new Container(
          alignment: Alignment.topCenter,
          padding: new EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .18,
              right: 20.0,
              left: 20.0),
          child: new Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            child: new Card(
              color: Colors.white,
              elevation: 4.0,
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Padding(padding: EdgeInsets.only(left: 0.0),
                      child: Image.asset("assets/images/icon_orders@2x.png", fit: BoxFit.contain, height: 30,
                        width: 30.0,
                        color: Hexcolor('#FB6907'),
                      ),
                    ),
                      flex: 1,),
                    Expanded(child: Text("Yours Booking"),
                      flex: 4,),
                    Expanded(child: Image.asset("assets/images/icon_orders@2x.png", fit: BoxFit.contain, height: 30,
                      width: 30.0,
                      color: Hexcolor('#FB6907'),
                    ),
                      flex: 1,),
                  ],
                ),
                onTap: () => {
                  globals.isVendor = false,
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderUIPage(url: Configurations.BOOKING_URL, isCustomer: true,),
                      )
                  )
                },
              )
            ),
          ),
        ),

        new Container(
          alignment: Alignment.topCenter,
          padding: new EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .34,
              right: 20.0,
              left: 20.0),
          child: new Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            child: new Card(
              color: Colors.white,
              elevation: 4.0,
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Padding(padding: EdgeInsets.only(left: 0.0),
                      child: Image.asset("assets/images/icon_orders@2x.png", fit: BoxFit.contain, height: 30,
                        width: 30.0,
                        color: Hexcolor('#FB6907'),
                      ),
                    ),
                      flex: 1,),
                    Expanded(child: Text("Customer Booking"),
                      flex: 4,),
                    Expanded(child: Image.asset("assets/images/icon_orders@2x.png", fit: BoxFit.contain, height: 30,
                      width: 30.0,
                      color: Hexcolor('#FB6907'),
                    ),
                      flex: 1,),
                  ],
                ),
                onTap: () => {
                  globals.isVendor = true,
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderUIPage(url: Configurations.PROVIDER_BOOKING_URL, isCustomer: false,),
                      )
                  )

                },
              )
            ),
          ),
        )


      ],

    );
  }

    void onTap(val) {
    print(val);
    setState(() {
      if(val == 0) {

      } else {
        globals.isVendor = true;
      }
    });
  }
}