import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/models/order.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/widget/otp_screen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;

class OrderDetail extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: DetailUIPage());
  }
}
class DetailUIPage extends StatefulWidget {
  final Order order;
  DetailUIPage({Key key, @required this.order}) : super(key: key);
  @override
  _DetailUIPageState createState() => _DetailUIPageState(order: this.order);
}
class _DetailUIPageState extends State<DetailUIPage> {
  final Order order;
  _DetailUIPageState({Key key, @required this.order});
  bool isRatingDisplay = true;
  List<DropdownMenuItem<String>> _dropDownTypes;
  List _lstType = ["","Too Slow","Vendor not responding",
  "Last minute plans"];
  String ddownvalue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
   ddownvalue = _dropDownTypes[0].value;
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key) {

      items.add(DropdownMenuItem(value:key , child: Text(key)
      ));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    printLog(selectedItem);
    setState(() {
      printLog(selectedItem);
      ddownvalue = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.black),
    backgroundColor: Colors.white,
    title: Text("Order Detail", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),),
      body: detailUI(),

    );
  }
  Widget detailUI(){
     return SingleChildScrollView(
         child: Column(mainAxisSize: MainAxisSize.min,
         //crossAxisAlignment: CrossAxisAlignment.end,
         children: <Widget>[
           setOrderInfo(),
           setServiceInfo(),
           detailInfo(),

           ButtonTheme(
             minWidth: 270.0,
             child:  RaisedButton(
                 color: Colors.teal,
                 textColor: Colors.white,
                 child: const Text(
                     'Download Invoice',
                     style: TextStyle(fontSize: 16.5)
                 ),
                 onPressed: () {
//                   validateForm();
                 }
             ),
           ),
           ButtonTheme(
             minWidth: 270.0,
             child:  RaisedButton(
                 color: Colors.teal,
                 textColor: Colors.white,
                 child: const Text(
                     'Cancel',
                     style: TextStyle(fontSize: 16.5)
                 ),
                 onPressed: () => {
                   showDialog(
                     context: context,
                     builder: (BuildContext context) {
                       return buildCancelDialog(context);

                     },
                   )
                 }
             ),
           ),


         ]),
     );

  }


 Widget setOrderInfo(){
    return new Card(
        margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Order: ",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
                  Text("#" + globals.order.id.toString(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 20)),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(child: Icon(Octicons.calendar, color: Configurations.themColor,),
                  flex: 4,),
                SizedBox(width: 10,),

                Flexible(child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Date", style: TextStyle(fontSize: 12, color: Colors.grey),),
                    Text(globals.order.booking_date)

                  ],
                ),
                  flex: 8,),
                SizedBox(width: 10,),

                Flexible(child: Icon(MaterialIcons.access_time, color: Configurations.themColor,),
                  flex: 4,),
                SizedBox(width: 10,),

                Flexible(child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Time", style: TextStyle(fontSize: 12, color: Colors.grey),),
                    Text(globals.order.end_time)

                  ],
                ),
                  flex: 8,),
              ],
            ),),
          ],
        )
    );
 }

 Widget setServiceInfo() {
    (globals.order.rating == null)? isRatingDisplay = false : isRatingDisplay = true;

    return new Card(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Octicons.person, color: Configurations.themColor,),
                Text("Vendor: ",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
                Text(globals.order.provider_first_name,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 20)),
              ],
            ),
          ),

          Visibility(visible: isRatingDisplay,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(70, 5, 10,10),
                      child:
                      SmoothStarRating(
                        allowHalfRating: false,
                        starCount: 5,
                        rating: (globals.order.rating == null)? 0.0 : globals.order.rating.floorToDouble(),
                        size: 20.0,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star,
                        color: Colors.amber,
                        borderColor: Colors.amber,
                        spacing:0.0,
                        onRatingChanged: (v) {
                          setState(() {
                            printLog("RATE :: $v");
                          });
                        },
                      ),
                    ),
                    Text((globals.order.rating == null) ? "" : globals.order.rating.toString(),textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0,color: Colors.blueGrey),),
                  ],
                ),
                Text((globals.order.comment == null) ? "" : globals.order.comment,textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0,color: Colors.blueGrey),),
              ],
            ),

          ),

          Visibility(visible: !isRatingDisplay,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(70, 5, 10,10),
                  child: FlatButton(onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                          return buildRatingDialog(context);

                      },
                  )
                  }, child: Text("Submit Rating"))
                ),
              ],
            ),
          ),


          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 10,20),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Service", style: TextStyle(fontSize: 12, color: Colors.grey),),
              SizedBox(height: 5,),
              Text(globals.order.service)
            ],
          ),
          ),

//          Padding(padding: EdgeInsets.fromLTRB(30, 0, 30,0),
//          child: Divider(
//            color: Colors.black,
//          ),
//          ),

//          Padding(padding: EdgeInsets.fromLTRB(40, 10, 0, 15),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Text("Category", style: TextStyle(fontSize: 12, color: Colors.grey),),
//                SizedBox(height: 5,),
//                Text(order.category)
//              ],
//            ),
//          ),

        ],
      )
    );
 }




 Widget detailInfo() {

   String addressString = globals.order.address.address_line1;
   if(globals.order.address.address_line2 != "") {
     addressString += ", " + globals.order.address.address_line2;
   }

   if(globals.order.address.landmark != "") {
     addressString += ", " + globals.order.address.landmark;
   }
   addressString += ", " + globals.order.address.district
       + ", " + globals.order.address.city + ", " + globals.order.address.postal_code + ".";

    return Card(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
      elevation: 5,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Octicons.location
                Icon(MaterialIcons.location_on, color: Configurations.themColor,),
                SizedBox(width: 20,),
                Text("Address",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 10,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(addressString, )
              ],
            ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(30, 0, 30,0),
            child: Divider(
              color: Colors.black,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Octicons.location
                Icon(MaterialIcons.email, color: Configurations.themColor,),
                SizedBox(width: 20,),
                Text("Email",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 10,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(globals.order.email)
              ],
            ),
          ),


          Padding(padding: EdgeInsets.fromLTRB(30, 0, 30,0),
            child: Divider(
              color: Colors.black,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Octicons.location
                Icon(MaterialIcons.phone, color: Configurations.themColor,),
                SizedBox(width: 20,),
                Text("Number",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 10,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(globals.order.contact)
              ],
            ),
          ),



        ],
      ),
    );
 }

 final txtComment = TextEditingController();

  Widget buildRatingDialog(BuildContext context) {
    return AlertDialog(
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildHeader(),

            SizedBox(
              height: 10.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.9,
                  color: Colors.black,
                ),
              ),
            ),

            buildRatingSection(setState),

            TextField(
              maxLines: null,
              controller: txtComment,
              keyboardType: TextInputType.multiline,
            ),

            okButton(context),
          ],
        );
      }),
    );
  }

  Widget buildHeader() {
    return new Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Rating',
            style: const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget okButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: double.infinity, // match_parent
            child: RaisedButton(
              color: Colors.black,
              onPressed: () {
                if(setRate > 0) {
                  sendRating();
                } else {
                  print(txtComment.text);
                  print(setRate);
                }
//                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontSize: 20,color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void sendRating() async {
    Map<String, String> data = new Map();
    data["rating"] = setRate.floor().toString();
    data["rate_by"] = globals.order.user_id.toString();
    data["booking_id"] = globals.order.id.toString();
    data["rate_to"] = globals.order.provider_id.toString();
    data["comment"] = txtComment.text;
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      print('api call start signup');
      var syncUserResponse =
          await httpClient.postRequest(context, Configurations.BOOKING_RATING_URL, data);
      processLoginResponse(syncUserResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  processLoginResponse(Response res)  {
    if (res != null) {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    } else {
      showInfoAlert(context, "Unknown error from server");
    }
  }


  var setRate = 0.0;

  Widget buildRatingSection(StateSetter setState) {
    printLog("SETRATE::: $setRate");
    return Container(padding: const EdgeInsets.fromLTRB(10,5,10,5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new SmoothStarRating(
            allowHalfRating: false,
            starCount: 5,
            rating: setRate,
            size: 30.0,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            color: Colors.amber,
            borderColor: Colors.amber,
            spacing:0.0,
            onRatingChanged: (value) {
              setState(() {
                printLog("RATE :: $value");
                setRate = value;

              });
            },
          ),
        ],
      ),
    );
  }


  final format = DateFormat("dd-MM-yyyy");
  final formatt= DateFormat("HH:mm");
  final txtCancel = TextEditingController();

  Widget buildCancelDialog(BuildContext context) {
    return AlertDialog(
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildCancelHeader(),

            SizedBox(
              height: 10.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.9,
                  color: Colors.teal,
                ),
              ),
            ),

            buildDropDownSection(setState),

            TextField(
              maxLines: null,
              controller: txtCancel,
              keyboardType: TextInputType.multiline,
            ),

            CancelButton(context),
          ],
        );
      }),
    );
  }
  Widget buildCancelHeader() {
    return new Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Service Cancellation Request',
            style: const TextStyle(fontSize: 17.0, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  Widget buildDropDownSection(StateSetter setState) {

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reason :", style:TextStyle(color: Colors.teal) ,),


       // SizedBox(width: 5,),
        Expanded(child: DropdownButton(



            underline: SizedBox(),
            isExpanded: true,
            value: ddownvalue,
            icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
            items: _dropDownTypes,
            onChanged:  (value) {
    setState(() {
    printLog("RATE :: $value");
    ddownvalue = value;

    });
    },),
        ),

      ],
    );
  }
  Widget CancelButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: double.infinity, // match_parent
            child: RaisedButton(
              color: Colors.black,
              onPressed: () {

              },
              child: const Text('OK', style: TextStyle(fontSize: 20,color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }


}