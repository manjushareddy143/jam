import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
class Orders extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return OrderUIPage(); //Center(child: );
  }
}
class OrderUIPage extends StatefulWidget {
  final String url;
  final bool isCustomer;
  OrderUIPage({Key key, @required user, this.url, this.isCustomer}) : super(key: key);
  @override
  _OrderUIPageState createState() => _OrderUIPageState(key: key, url: this.url, isCustomer: this.isCustomer);
}
class _OrderUIPageState extends State<OrderUIPage>  {
  final String url;
  final bool isCustomer;
  int oIndex = 0;

  User user;

  _OrderUIPageState({Key key, this.url, this.isCustomer});

  set result(result) {
    setState(() {
      globals.listofOrders;
    });
    print("result === ${globals.listofOrders}");
    globals.listofOrders.forEach((element) {
      print(element.id);
      print(element.status);
    });

//    build(context);
  }

  @override
  void initState() {
    print("List order");
    // TODO: implement initState
    super.initState();
    getProfile();
    globals.context = context;
  }
  void getProfile() async  {
    await Preferences.readObject("user").then((onValue) async {
      var userdata = json.decode(onValue);
      printLog('userdata');
      printLog(userdata);
      user = User.fromJson(userdata);

      setState(() {
        getOrders();
      });
    });
  }

  getOrders() async {
    try {
      print("CUST");
      HttpClient httpClient = new HttpClient();
      var syncProviderResponse = await httpClient.getRequest(context,
          this.url + "?id=" + user.id.toString(), null, null, true, false);
      processOrdersResponse(syncProviderResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processOrdersResponse(Response res) async {
    print('get daily format');
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        List orders = data;
        setState(() {
          globals.listofOrders = Order.processOrders(orders);
          print("ORDERS === ${globals.listofOrders.length}");
        });
      } else {
        printLog("login response code is not 200");
      }
    } else {
      print('no data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (globals.listofOrders == null) {
      return new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    } else {
      return Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: new Text(AppLocalizations.of(context).translate('tab_orders')),
          backgroundColor: Configurations.themColor,
        ),
          body:
          SingleChildScrollView(
            child: OrderListUI()
//            Column(
//              mainAxisSize: MainAxisSize.min,
////                mainAxisSize: MainAxisSize.min,
//                children: listOfCards()
//            ),
          )
      );
    }

  }

  Widget OrderListUI() {
    return Stack(
        children: [
          new Container(
            height: MediaQuery.of(context).size.height * .30,
//            width: MediaQuery.of(context).size.height * .50,
            color: Colors.grey[800],
            child: Container(
                padding: EdgeInsets.only(left: 50, right: 50, bottom: 50, top: 50),
                child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/jamLogoWhite.png", fit: BoxFit.contain, height: 100,
                      width: 100.0,
                    ),
                  ],
                )
            ),
          ),

          new Container(
              alignment: Alignment.topCenter,
              padding: new EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .20,
                  right: 2.0,
                  left: 2.0),
              child: Column(
                children: listOfCards()
              )
//          new Container(
////            height: 80.0,
//            width: MediaQuery.of(context).size.width,
//            child: ,
//          ),
          ),


        ]
    );
  }

  List<Widget> listOfCards() {
    List<Widget> list = new List();
    for(int orderCount = 0; orderCount< globals.listofOrders.length; orderCount++) {
      list.add(setupCard(globals.listofOrders[orderCount]));
    }
    return list;
  }

  AssetImage setImgPlaceholder() {
    return AssetImage("assets/images/BG-1x.jpg");
  }

  Widget setupCard(Order order) { //Order order

    double rating = (order.rating == null)? 0.0 : order.rating.rating.floorToDouble();
    String statusString = "";
    var status_color = null;
    var status_icon = null;


    print("image === ${order.provider.image}");
    String img = "";
//    (order.provider.image != null && order.provider.image.contains("http"))
//        ? order.provider.image : Configurations.BASE_URL +order.provider.image;


    if( (order.provider.image != null && order.provider.image.contains("http"))) {
      img = order.provider.image;
    } else if(order.provider.image == null) {
      img = null;
    } else {
      img =  Configurations.BASE_URL + order.provider.image;
    }



    if(order.provider.organisation != null) {
      img = (order.provider.organisation.logo != null && order.provider.organisation.logo.contains("http"))
          ? order.provider.organisation.logo : Configurations.BASE_URL +order.provider.organisation.logo;
    }

    print("IM == ${img}");

    switch(order.status)
    {
      case 1: statusString = 'Pending';
      status_color = Hexcolor('#EFB006');
      status_icon = Icons.pan_tool;
      break;
      case 2: statusString = 'Accept';
      status_color = Colors.green;
      status_icon = Icons.check_circle;
      break;
      case 3: statusString = 'Cancelled'; //By + order.provider_first_name;
      status_color = Hexcolor('#C72801');
      status_icon = Icons.cancel;
      break;
      case 4: statusString = 'Cancelled'; // By You
      status_color = Hexcolor('#C72801');
      status_icon = Icons.cancel;
      break;
      case 5: statusString = 'Completed';
      status_color = Hexcolor('#67A702');
      status_icon = Icons.thumb_up;
      break;
      case 6: statusString = 'Invoice Submitted';
      status_color = Configurations.themColor;
      status_icon = Icons.attach_money;
      break;
      default : statusString = 'Completed';
      status_color = Configurations.themColor;
      status_icon = Icons.thumb_up;
    }

    String name = "";
    if(order.provider.organisation != null) {
      name = order.provider.organisation.name;
    } else {
      name = order.provider.first_name + " " + order.provider.last_name;
    }

    return Container(
      child: GestureDetector(
        onTap: () async => {
          print("ONTAP CARD ${order.id}"),
          globals.order = order,
        printLog("this.isCustomer ${this.isCustomer}"),
//        final result = await Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => SelectionScreen()),
           result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailUIPage(order: order, isCustomer: this.isCustomer,)
              )
          ),
        },
        child: Card(
            margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),

            elevation: 5,
            child: Row(
              children: <Widget>[

                Expanded(child: Container(
                  margin: EdgeInsets.all(15),
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    image:
                    DecorationImage(
                      image: (img != null)?
                      NetworkImage(img):setImgPlaceholder(),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(80.0),
                    border: Border.all(
                      color: Configurations.themColor,
                      width: 1.5,
                    ),
//                    color:


                  ),
                ),
                flex: 0,),

                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[

                    Text(capitalize(name),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textWidthBasis: TextWidthBasis.parent,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Container(
                      width: 150,
                      child: Text(order.service.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5),
                    ),

                    Text(AppLocalizations.of(context).translate('order') + order.id.toString(),),

                    Text(order.booking_date,),
                    SizedBox(height: 5.0,),
                    SmoothStarRating(
                      allowHalfRating: false,
                      starCount: 5,
                      rating: rating,
                      size: 20.0,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      //unfilledStar: Icon(Icons., color: Colors.grey),
                      spacing:0.0,
                      onRatingChanged: (v) {
//                    rating = v;
                        setState(() {});
                      },
                    ),
//                      Row(
//                        children: <Widget>[
//
//                        ],
//                      ),

                  ],
                ),
                flex: 2,),



                Container(
//                  color: status_color,
//                  alignment: Alignment.bottomRight,
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    color: status_color,
                  ),
      margin: EdgeInsets.only(bottom: 0, top: 70, left: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(status_icon, color: Colors.white, size: 14,),
                      FlatButton(
//                              onPressed:  () {
//                                print('Call Press');
//                              },
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(statusString,
                            style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          )
                      ),
                    ],
                  ),
                )

//                Expanded(child: Container(
//                  color: Configurations.themColor,
//                  alignment: Alignment.centerRight,
////                      padding: EdgeInsets.only(bottom: 0, top: 50),
//                  child: Row(
//                    children: <Widget>[
//                      Text("data1"),
//                      Text("data2"),
//                    ],
//                  ),
//                ),

//                Stack(
//                  alignment: Alignment.centerRight,
//
//                  children: <Widget>[
//
//                  ],
//                ),


          /*      Row(
                  children: <Widget>[
                    SizedBox(child: Row(
                      children: <Widget>[
                        FlatButton(
//                              onPressed:  () {
//                                print('Call Press');
//                              },
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(statusString,
                              style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: status_color),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            )
                        ),
                        SizedBox(width: MediaQuery. of(context). size. width / 7.8,),
                        Icon(status_icon, color: status_color, size: 14,),
                      ],
                    ),
                    ),


                  ],
                ),
                */

//                flex: 1,)



              ],
            )
        ),
      )

    );
  }
}