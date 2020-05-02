import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:jam/models/order.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class Orders extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return OrderUIPage(); //Center(child: );
  }
}
class OrderUIPage extends StatefulWidget {
  @override
  _OrderUIPageState createState() => _OrderUIPageState();
}
class _OrderUIPageState extends State<OrderUIPage> {
  int oIndex = 0;
  List<Order> listofOrders;
  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
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
      HttpClient httpClient = new HttpClient();
      var syncProviderResponse = await httpClient.getRequest(context,
          Configurations.BOOKING_URL + "?id=" + user.id.toString(), null, null, true, false);
      processOrdersResponse(syncProviderResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processOrdersResponse(Response res) {
    print('get daily format');
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print('providers=== $data');
        List orders = data;
        setState(() {
          listofOrders = Order.processOrders(orders);
//          build(context);
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
    if (listofOrders == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else {
      return Scaffold(
          body:
          SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: listOfCards()
            ),
          )
      );
    }

  }

  List<Widget> listOfCards() {
    List<Widget> list = new List();
    for(int orderCount = 0; orderCount< listofOrders.length; orderCount++) {
      list.add(setupCard(listofOrders[orderCount]));
    }
    return list;
  }

  Widget setupCard(Order order) { //Order order
    String statusString = "";
    var status_color = null;
    var status_icon = null;

    switch(order.status) {
      case 1: statusString = 'Order Pending';
      status_color = Colors.blue;
      status_icon = Icons.pan_tool;
      break;
      case 2: statusString = 'Order Completed';
      status_color = Colors.green;
      status_icon = Icons.check_circle;
      break;
      case 3: statusString = 'Order Decline';
      status_color = Colors.red;
      status_icon = Icons.cancel;
      break;
      default : statusString = 'Order Completed';
      status_color = Colors.green;
      status_icon = Icons.check_circle;
    }

    return Container(
      child: new Card(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          elevation: 5,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(15),
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  image:
                  DecorationImage(
                    image: NetworkImage(
                        order.provider_image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(80.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Text(order.provider_first_name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textWidthBasis: TextWidthBasis.parent,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Container(
                      width: 150,
                      child: Text(order.service,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5),
                    ),
                    Text("Order#" + order.id.toString(),),
                    Row(
                      children: <Widget>[
                        Text(order.booking_date,),
                        SizedBox(width: 10,),
                        SmoothStarRating(
                          allowHalfRating: false,
                          starCount: 5,
                          rating: 3.0,
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
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed:  () {
                              print('Call Press');
                            },
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(statusString,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: status_color)
                            )
                        ),
                        SizedBox(width: MediaQuery. of(context). size. width / 4.5,),
                        Icon(status_icon, color: status_color, size: 15,)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }


  Widget myOrderUI(){
    return CustomScrollView(
      slivers: <Widget>[
        SliverFixedExtentList(
          itemExtent: 180.0,
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int oIndex) {
                return  Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // alignment: WrapAlignment.spaceEvenly,
                    children: <Widget>[
                      new Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              onTap: ()=> {
                                print('tap on card')
                              },
                              leading: Container(
                                width: 60,
                                height: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: NetworkImage(
                                          'http://192.168.43.40/images/category/1791451178.jpg'),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              title: Text('first_name'),
                              subtitle:   Text('Experience: 2 Years'),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  SmoothStarRating(
                                    allowHalfRating: false,
                                    starCount: 5,
                                    rating: 3.0,
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
                                  Text(" 3 Reviews",textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0,color: Colors.blueGrey),),
                                ],
                              ),
                            ),
                            Align(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: FlatButton.icon(
//                          color: Colors.red,
                                        icon: Icon(Icons.monetization_on, color: Colors.teal), //`Icon` to display
                                        label: Text('Get Quotes', style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.teal)), //`Text` to display
                                        onPressed: () {
//                                          Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      InquiryPage(service: this.service)));
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                      child: FlatButton.icon(
                                        icon: Icon(Icons.call, color: Colors.teal), //`Icon` to display
                                        label: Text('Call', style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.teal)), //`Text` to display
                                        onPressed: () {
                                          print('Call Press');
                                          //Code to execute when Floating Action Button is clicked
                                          //...
                                        },
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),


//                      Container(
//                        margin: EdgeInsets.all(18),
//                        alignment: Alignment.center,
//                        padding: EdgeInsets.only(top: 10),
//                        width: 100,
//                        height: 100,
//                        decoration: BoxDecoration(
//                            shape: BoxShape.circle,
//                            image: DecorationImage(
//                                fit: BoxFit.fill,
//                                image: AssetImage("assets/images/vicky.jpg")
//                            )
//                        ),
//                      ),
//
//                      Container(width: 240,margin: EdgeInsets.fromLTRB(10,10,20,10),
//                        height: 120,
//
//                        child:
//                        Column(crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            new Text(
//                              "Afrar Sheikh",
//                              textAlign: TextAlign.left,
//                              overflow: TextOverflow.ellipsis,
//                              style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w600),
//                            ),
//                            new Text(
//                              "Plumbing",
//                              textAlign: TextAlign.left,
//                              overflow: TextOverflow.ellipsis,
//                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0,),
//                            ),
//                            new Text(
//                              "Order#:990245",
//                              textAlign: TextAlign.left,
//                              overflow: TextOverflow.ellipsis,
//                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0,),
//                            ),
//                            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                children:<Widget>[
//                                  Flexible(
//                                    flex:2,
//                                    child: new Text(
//                                      "01-April-2020, 1:00 PM",
//                                      textAlign: TextAlign.left,
//                                      overflow: TextOverflow.ellipsis,
//                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.0, ),
//                                    ),
//                                  ),
//                                 // SizedBox(width: 10,),
//
//
//                                  Flexible(
//                                    flex: 1,
//                                    child: SmoothStarRating(
//                                        allowHalfRating: false,
//
//                                        starCount: 5,
//                                        rating: 3.0,
//                                        size: 15.0,
//                                        filledIconData: Icons.star,
//                                        halfFilledIconData: Icons.star,
//                                        color: Colors.amber,
//                                        borderColor: Colors.amber,
//                                        //unfilledStar: Icon(Icons., color: Colors.grey),
//                                        spacing:0.0
//                                    ),
//                                  )
//                                ]
//                            ),
//                            SizedBox(height: 20,),
//                            Container(
//                              child:
//                              Row(//crossAxisAlignment: WrapCrossAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: [
//                                    Flexible(
//                                      child: new Text(
//                                        "Order Completed",
//                                        textAlign: TextAlign.center,
//                                        overflow: TextOverflow.ellipsis,
//
//                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.0, color: Colors.teal, ),
//
//                                      ),
//                                    ),
//
//                                    Flexible( child: Icon(Icons.check_box, size: 12,color: Colors.teal,))]
//                              ),
//
//
//                            ),
//                          ],
//                        ),
//                      ),
                    ],),
                );
              }
          ),
        )
      ],
    );
  }
}