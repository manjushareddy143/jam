import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:jam/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/models/order.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/pdf_view.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/widget/otp_screen.dart';
import 'package:jam/screens/download.dart';
import 'package:jam/widget/widget_helper.dart';
import 'package:open_file/open_file.dart';
//import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;

//import 'package:path_provider/path_provider.dart';


class OrderDetail extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: DetailUIPage());
  }
}
class DetailUIPage extends StatefulWidget {
  final Order order;
  final bool isCustomer;
  DetailUIPage({Key key, @required this.order, @required this.isCustomer}) : super(key: key);
  @override
  _DetailUIPageState createState() => _DetailUIPageState(order: this.order, isCustomer: this.isCustomer);
}
class _DetailUIPageState extends State<DetailUIPage> {
  final Order order;
  final bool isCustomer;

  _DetailUIPageState({Key key, @required this.order, @required this.isCustomer});
  bool isRatingDisplay = true;
  bool showOTP = false;
  List<DropdownMenuItem<String>> _dropDownTypes;
  List _customerCancelReasonList = ["Too Slow","Vendor not responding", "Last minute plans"];
  List _vendorCancelReasonList = ["Too Far","Customer not reachable", "Address not available"];
  String cancelReason;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globals.context = context;
    if(this.isCustomer == true) {
      _dropDownTypes = buildAndGetDropDownMenuItems(_customerCancelReasonList);
    } else {
      _dropDownTypes = buildAndGetDropDownMenuItems(_vendorCancelReasonList);
    }
   cancelReason = _dropDownTypes[0].value;

    printLog("this.isCustomer mayur ${this.isCustomer}");
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
      cancelReason = selectedItem;
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
           Visibility(child: invoiceDetails(),
           visible: (order.status == 6 || order.status == 5) ? true : false,),

           if(order.status == 5)
           ButtonTheme(
             minWidth: 270.0,
             child:  RaisedButton(
                 color: Configurations.themColor,
                 textColor: Colors.white,
                 child: const Text(
                     'Download Invoice',
                     style: TextStyle(fontSize: 16.5)
                 ),
               onPressed: () async {
                   Widget_Helper.showLoading(context);
                   DownLoadHelper down = new DownLoadHelper();
                   String status = await down.downloadFile(setState, order.id.toString());
                   Widget_Helper.dismissLoading(context);
                   final result = await OpenFile.open(status);
               },
             ),
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               if(order.status == 1 && order.status != 4 && order.status != 3 && this.isCustomer == false)
               ButtonTheme(
                 child:  RaisedButton(
                     color: Configurations.themColor,
                     textColor: Colors.white,
                     child: Row(
                       children: <Widget>[
                         Icon(Icons.check_circle, color: Colors.white, size: 20,),
                         SizedBox(width: 10,),
                         Text(
                             'Accept',
                             style: TextStyle(fontSize: 14)
                         ),
                       ],
                     ),
                     onPressed: () => {
                       print("Accept"),
                       orderAccept()
                     }
                 ),
               ),

               if(order.status == 2 && this.isCustomer == false)
                 ButtonTheme(
                   child:  RaisedButton(
                       color: Configurations.themColor,
                       textColor: Colors.white,
                       child: Row(
                         children: <Widget>[
                           Icon(Icons.attach_money, color: Colors.white, size: 20,),
                           SizedBox(width: 8,),
                           Text(
                               'Submit Invoice',
                               style: TextStyle(fontSize: 14)
                           ),
                         ],
                       ),
                       onPressed: () => {
                         print("COmplete"),
                         insertIvoiceDetail(),
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return buildCompleteDialog(context);
//
//                           },
//                         )
                       }
                   ),
                 ),
               if(order.status == 6 && this.isCustomer == false)
                 ButtonTheme(
                   child:  RaisedButton(
                       color: Configurations.themColor,
                       textColor: Colors.white,
                       child: Row(
                         children: <Widget>[
                           Icon(Icons.thumb_up, color: Colors.white, size: 20,),
                           SizedBox(width: 8,),
                           Text(
                               'Complete',
                               style: TextStyle(fontSize: 14)
                           ),
                         ],
                       ),
                       onPressed: () => {
                         print("COmplete"),

                   showDialog(
                           context: context,
                           builder: (BuildContext context) {
                            return buildCompleteDialog(context);
//
                           },
                         )
                       }
                   ),
                 ),
               if(order.status != 5 && order.status != 4 && order.status != 3 && this.isCustomer == false)
               SizedBox(width: 50,),
               if(order.status != 5 && order.status != 4 && order.status != 3)
               ButtonTheme(
                 child:  RaisedButton(
                     color: Configurations.themColor,
                     textColor: Colors.white,
                     child: Row(
                       children: <Widget>[
                         Icon(Icons.cancel, color: Colors.white, size: 20,),
                         SizedBox(width: 10,),
                         Text(
                             'Cancel',
                             style: TextStyle(fontSize: 14)
                         ),
                       ],
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
             ],
           ),
         ]),
     );
  }


 Widget setOrderInfo(){
   String statusString = "";
   var status_color = null;
   var status_icon = null;

   switch(order.status)
   {
     case 1: statusString = 'Order Pending';
     status_color = Colors.blue;
     status_icon = Icons.pan_tool;
     break;
     case 2: statusString = 'Order Accept';
     status_color = Colors.green;
     status_icon = Icons.check_circle;
     break;
     case 3:
       if(globals.currentUser.roles[0].slug == "customer") {
         statusString = 'Order Cancel'; // You
       } else {
         statusString = 'Order Cancel';// + globals.order.orderer_name;
       }

     status_color = Colors.red;
     status_icon = Icons.cancel;
     break;
     case 4:
       if(globals.currentUser.roles[0].slug == "customer") {
         statusString = 'Order Cancel by You';
       } else {
         statusString = 'Order Cancel by ' + globals.order.orderer_name;
       }

     status_color = Colors.red;
     status_icon = Icons.cancel;
     break;
     case 5: statusString = 'Order Completed';
     status_color = Colors.green;
     status_icon = Icons.check_circle;
     break;
     case 6: statusString = 'Invoice Submitted';
     status_color = Configurations.themColor;
     status_icon = Icons.attach_money;
     break;
     default : statusString = 'Order Completed';
     status_color = Colors.green;
     status_icon = Icons.check_circle;
   }
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

            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(statusString,
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 12)),
                  SizedBox(width: 10,),
                  Icon(status_icon, color: status_color, size: 15,),
                ],
              ),
            ),

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
                Text((this.isCustomer == true) ?"Vendor: " : "Customer: ",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
                Text((this.isCustomer == true) ? globals.order.provider.first_name : globals.order.orderer_name,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 20)),
              ],
            ),
          ),

         Visibility(visible: isRatingDisplay,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(70, 5, 10,10),
                      child:
                      SmoothStarRating(
                        allowHalfRating: false,
                        starCount: 5,
                        rating: (globals.order.rating == null)? 0.0 : globals.order.rating.rating.floorToDouble(),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(70, 5, 10,10),
                      child: Text((globals.order.rating == null) ? "" : globals.order.rating.comment,textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0,color: Colors.blueGrey),),
                    ),
                  ],
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
                ),
                Text((globals.order.comment == null) ? "" : globals.order.comment,textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0,color: Colors.blueGrey),),
              ],
            ),

          ),

          /// SHOW OTP
         if(order.status == 6 || order.status == 2 && this.isCustomer == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(child:
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0,0),
                  child: OutlineButton(onPressed: () => {
                    showBookingOTP()
                  }, child: Text("GET OTP"),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Configurations.themColor)
                  )
              ),
               visible: !showOTP,
              ),

              Visibility(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50,),
                  Text("OTP: ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(globals.order.otp.toString(),  style: TextStyle(fontWeight: FontWeight.w400)),
                ],
              ),
              visible: showOTP,),


            ],
          ),

          if(order.status == 5 && this.isCustomer == true)
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
              Text(globals.order.service.name)
            ],
          ),
          ),

          if(globals.order.category != null)
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 10,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Category", style: TextStyle(fontSize: 12, color: Colors.grey),),
                SizedBox(height: 5,),
                Text(globals.order.category.name)
              ],
            ),
          ),

        ],
      )
    );
 }

 void showBookingOTP() {
    setState(() {
      showOTP = true;
    });

 }



 Widget detailInfo() {
   String addressString = "";
    if(globals.order.address != null) {
      addressString = globals.order.address.address_line1;
      if(globals.order.address.address_line2 != "" && globals.order.address.address_line2 != null) {
        addressString += ", " + globals.order.address.address_line2;
      }

      if(globals.order.address.landmark != "" && globals.order.address.landmark != null) {
        addressString += ", " + globals.order.address.landmark;
      }
      addressString += ", " + globals.order.address.district
          + ", " + globals.order.address.city + ", " + globals.order.address.postal_code + ".";
    }


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
          await httpClient.postRequest(context, Configurations.BOOKING_RATING_URL, data, true);
      processRatingResponse(syncUserResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  processRatingResponse(Response res)  {
    if (res != null) {
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        getOrderDetail();
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

  Widget buildCancelDialog(BuildContext context) {
    return AlertDialog(
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildCancelHeader("Service Cancellation Request", ),

            SizedBox(
              height: 10.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.9,
                  color: Configurations.themColor,
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

  final format = DateFormat("dd-MM-yyyy");
  final formatt= DateFormat("HH:mm");
  final txtCancel = TextEditingController();

  Widget buildCancelHeader(String title) {
    return new Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 16.0, color: Configurations.themColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  Widget buildDropDownSection(StateSetter setState) {

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reason :", style:TextStyle(color: Configurations.themColor) ,),
       // SizedBox(width: 5,),
        Expanded(child: DropdownButton(



            underline: SizedBox(),
            isExpanded: true,
            value: cancelReason,
            icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
            items: _dropDownTypes,
            onChanged:  (value) {
              setState(() {
                printLog("RATE :: $value");
                cancelReason = value;
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
                Map<String, String> data = new Map();
                data["reason"] = cancelReason;
                data["comment"] = txtCancel.text;
                data["booking_id"] = globals.order.id.toString();
                if(globals.currentUser.roles[0].slug == "customer") {
                  data["status"] = "4";
                } else {
                  data["status"] = "3";
                }
                orderStatusUpdate(data);
              },
              child: const Text('OK', style: TextStyle(fontSize: 20,color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
  Widget VendorBilling(BuildContext context){
    return AlertDialog();
  }

  Widget buildCompleteDialog(BuildContext context) {
    return AlertDialog(
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildCancelHeader("ENTER OTP"),

            SizedBox(
              height: 10.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.9,
                  color: Configurations.themColor,
                ),
              ),
            ),

            Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Container(padding: EdgeInsets.all(0),
                  width: 230,
                  height: 40,
                  child: PinEntryTextField(//fieldWidth: 500, fontSize: 100,
                    showFieldAsBox: true,
                    fields: 4,
                    onSubmit: submitPin,
//                  fieldWidth: 300.0,
//                  fontSize: 10,

                  ),
                ),

              ],
            ),
            SizedBox(height: 10),
            SubmitButton(context),

          ],
        );
      }),
    );
  }

  String otp = "";

  submitPin(String pin) {
    print(pin);
    otp = pin;
  }

  Widget SubmitButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: double.infinity, // match_parent
            child: RaisedButton(
              color: Configurations.themColor,
              onPressed: () {
                Map<String, String> data = new Map();
                data["booking_id"] = globals.order.id.toString();
                data["status"] = "5";
                data["otp"] = otp;
                orderStatusUpdate(data);
              },
              child: Text('SUBMIT', style: TextStyle(fontSize: 20,color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }


  void orderAccept() {
    Map<String, String> data = new Map();
    data["booking_id"] = globals.order.id.toString();
    data["status"] = "2";
    orderStatusUpdate(data);
  }

  void  orderStatusUpdate(Map<String, String> data) async {
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      print('api call start signup');
      var syncUserResponse =
          await httpClient.postRequest(context, Configurations.BOOKING_STATUS_URL, data, true);
      processCancelOrderResponse(syncUserResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  processCancelOrderResponse(Response res)  {
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

  void getOrderDetail() async {
    HttpClient httpClient = new HttpClient();
    print('api call start signup');
    var syncUserResponse =
    await httpClient.getRequest(context, Configurations.BOOKING_URL + "/" + globals.order.id.toString(), null,
        null, true, false);
    processOrderResponse(syncUserResponse);
  }

  processOrderResponse(Response res)  {
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("data ::: $data");

        setState(() {
          globals.order = Order.fromJson(data);
          int idx = globals.listofOrders.indexWhere((element) => element.id == globals.order.id);
          if(idx != null) {
            globals.listofOrders[idx] = globals.order;
          }
          print("rating ::: ${globals.order.rating}");
          build(context);
        });

      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    } else {
      showInfoAlert(context, "Unknown error from server");
    }
  }

  void insertIvoiceDetail(){
    showDialog(
      context: context,
      builder: (BuildContext context) => setOrderDetail(context),
    );
  }


  String findTotal() {
    if(order.invoice != null) {
      double cost = double.parse(order.provider.servicePrice.price);
      double serviceAmount = order.invoice.working_hr * cost;
      int meterialAmount = order.invoice.material_quantity * order.invoice.material_price;
      int additional_total = order.invoice.additional_charges * order.invoice.working_hr;
      double sub_total = serviceAmount + additional_total + meterialAmount;
      double total_discount = sub_total * order.invoice.discount/100;
      double totalWithDiscount =  sub_total -  total_discount;
      double taxCut =  totalWithDiscount * order.invoice.tax /100;
      double total = totalWithDiscount -  taxCut;
      print("total ${total}");
      return total.toString();
    } else {
      return "";
    }


  }

  Widget invoiceDetails(){
    String workingHour = (order.invoice != null) ? order.invoice.working_hr.toString() : "0";
    String materialQTY = (order.invoice != null) ? order.invoice.material_quantity.toString() : "0";
    String materialCost = (order.invoice != null) ? order.invoice.material_price.toString() : "0";
    String discount = (order.invoice != null) ? order.invoice.discount.toString() : "0";
    String tax = (order.invoice != null) ? order.invoice.tax.toString() : "0";
//    String tax_rate = (order.invoice != null) ? order.invoice.tax_rate.toString() : "0";
    String add_charge = (order.invoice != null) ? order.invoice.additional_charges.toString() : "0";



    return Card(
        margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(child: Text("Invoice Details",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20))),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 10,10),
              child: Text("Working Hours :   " + workingHour),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 10,2),
              child: Text("Materials"),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child:Text("Quantity :    " + materialQTY),
                        ),
                        Flexible(
                          child:Text("Price :    " + materialCost),
                        ),

                      ]),
                ),

              ],),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 10,2),
              child: Text("Discount :    " + discount),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 2, 10,2),
              child: Text("Tax :             " + tax),
            ), Padding(
              padding: EdgeInsets.fromLTRB(30, 2, 10,2),
              child: Text("Rate :           0%"),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 10,10),
              child: Text("Additional Charge :    " + add_charge),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 10,10),
              child: Text("Total :   " + findTotal() + "  QAR",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),


          ],
        )


    );

  }

  bool checkedValue = false;

  Widget setOrderDetail(BuildContext context){
      return AlertDialog(

          title:Center(child: Text("Order Detail"),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text("Time Taken"),
                      ),
                      Datepick(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: checkedValue,
                              onChanged:  (newValue) {
                                setState(() {
                                  checkedValue = newValue;
                                });
                              },),
                            Text("Material Used"),
                          ],

                        ),
                      ),

                      Visibility(
                        visible: checkedValue,
                        child: Container( height: 100,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Flexible(
                                          child: Text("Materials")
                                      ),
                                      Flexible(
                                        child: Container(height: 10, width: 60,

                                          child: TextField(controller: mtrl_used),
                                        ),
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Flexible(
                                        child:Text("Quantity"),
                                      ),
                                      Flexible(
                                        child: Container(height: 10, width: 60,

                                          child: TextField(controller: mtrl_qty,


                                            keyboardType: TextInputType.number,

                                          ),),
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[ Flexible(
                                      child:Text("Price"),
                                    ),
                                      Flexible(
                                        child: Container(height: 10, width: 60,

                                          child: TextField(

                                            controller: mtrl_price,
                                            keyboardType: TextInputType.number,

                                          ),),
                                      ),
                                    ]  ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Discount:"),
                            Container(width: 70, height: 30,
                              padding: EdgeInsets.only(bottom: 1.0),
                              child: TextField( decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )) ,
                                controller: discnt,


                                keyboardType: TextInputType.number,

                              ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("Tax"),
                            Container(width: 40, height: 30,
                              padding: EdgeInsets.only(bottom: 1.0),
                              child: TextField( decoration: InputDecoration() ,
                                controller: tax,

                                keyboardType: TextInputType.number,

                              ),),
                            SizedBox(width: 5,),
                            Text("Rate"),
                            Container(width: 40, height: 30,

                              child: TextField( decoration: InputDecoration(suffixText: '%') ,
                                controller: taxRate,


                                keyboardType: TextInputType.number,

                              ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: <Widget>[
                            Text("Additional Charge"),
                            Container(width: 70, height: 30,
                              padding: EdgeInsets.only(bottom: 1.0),
                              child: TextField( decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )) ,
                                controller: add_charge,


                                keyboardType: TextInputType.number,

                              ),),
                          ],
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 300.0,
                        child: RaisedButton(
                            color: Configurations.themColor,
                            textColor: Colors.white,
                            child: Text(
                                AppLocalizations.of(context).translate('btn_save'),
                                style: TextStyle(fontSize: 16.5)),
                            onPressed: () {callLoginAPI(); }),
                      ),
                    ],
                  ),
                );
              }
          )
      );
  }
  final wrking_hr = TextEditingController();
  final taxRate = TextEditingController();
  final tax = TextEditingController();
  final mtrl_used = TextEditingController();
  final mtrl_qty = TextEditingController();
  final mtrl_price = TextEditingController();
  final add_charge = TextEditingController();
  final discnt = TextEditingController();


  Future callLoginAPI() async {
    Map<String, String> data = new Map();
    data["order_id"] = globals.order.id.toString();
    data["working_hr"] = wrking_hr.text;
    data["tax_rate"] = (taxRate.text.isEmpty) ? "" :  taxRate.text;
    data["tax"] = (tax.text.isEmpty) ? "" :  tax.text;
    if(checkedValue) {
      data["material_names"] = (mtrl_used.text.isEmpty) ? "" : mtrl_used.text ;
      data["material_quantity"] = ( mtrl_qty.text.isEmpty) ? "0" :  mtrl_qty.text;
      data["material_price"] = ( mtrl_price.text.isEmpty) ? "0" : mtrl_price.text;
    }

    data["additional_charges"] = ( add_charge.text.isEmpty) ? "0" : add_charge.text;
    data["discount"] = ( discnt.text.isEmpty) ? "0" : discnt.text;
    printLog(data);
    try {
      HttpClient httpClient = new HttpClient();
      var syncUserResponse =
      await httpClient.postRequest(context, Configurations.INVOICE_GENERATE_URL, data, true);
      processInvoiceResponse(syncUserResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }

  }
  void processInvoiceResponse(Response res){
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("data::::::::$data");
       Navigator.of(context).pop();

//        showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return buildCompleteDialog(context);
//
//                           },
//                         );

      }
    }



  }


  Widget Datepick() {
    return Container(color: Colors.orangeAccent,
        height: MediaQuery.of(context).copyWith().size.height / 18,
        width: MediaQuery.of(context).copyWith().size.width / 1.4,
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(width: 70, height: 20,
                padding: EdgeInsets.only(bottom: 1.0),
                child: TextField( cursorColor: Colors.black,
                  controller: wrking_hr,



                  keyboardType: TextInputType.number,

                ),),
              SizedBox(width: 10,),
              Text("Hours", style: TextStyle(fontWeight: FontWeight.bold),)

            ],
          ),
        ));
  }


}