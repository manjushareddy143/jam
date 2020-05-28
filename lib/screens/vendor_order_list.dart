import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
    printLog("VENDOR");
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length:2);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child:Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
          child: Column( crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,0),
              child: Container(height:70,decoration: BoxDecoration(border: Border.all(color: Colors.teal, width: 1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.teal,
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(color: Colors.teal, borderRadius:BorderRadius.only(topRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),

                  tabs:  <Widget>[
                    Tab(icon: Icon(Icons.home), text: "Orders- By Me"),
                    Tab(icon: Icon(Icons.work), text: "Orders- For Me"),

                  ],
                ),
              ),
            ),
          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10,10),
            child: Container(height: 600,
              child: TabBarView(controller:_tabController,


                children: <Widget>[
                  OrderUIPage(url: Configurations.BOOKING_URL,),
                  OrderUIPage(url: Configurations.PROVIDER_BOOKING_URL,),
                ],),
            ),),


          ],),)
        ),
      ),
    );
  }
}