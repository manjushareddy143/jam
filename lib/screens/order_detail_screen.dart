import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jam/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/models/invoice.dart';
import 'package:jam/models/order.dart';
import 'package:jam/models/order_cancelled.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/pdf_view.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/widget/otp_screen.dart';
import 'package:jam/screens/download.dart';
import 'package:jam/widget/widget_helper.dart';
import 'package:open_file/open_file.dart';
//import 'package:native_pdf_view/native_pdf_view.dart';
import 'dart:io' show Platform;

import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

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
    globals.context = context;
    // TODO: implement build
    return Scaffold(
//        appBar: new AppBar(leading: BackButton(color:Colors.black),
//    backgroundColor: Colors.white,
//    title: Text("Order Detail", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),),
      body: SingleChildScrollView(
          child: detail()
      ),

      //detailUI(),

    );
  }

  Widget backButton() {

    if(globals.localization == 'ar_SA') {
      return Positioned(right: 15, top: 45,
        child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => {
          Navigator.of(context).pop()
        },),
      );

    } else {
      return Positioned(left: 15, top: 45,
        child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => {
          Navigator.of(context).pop()
        },),
      );
    }
  }

  Widget refreshButton() {

    if(globals.localization == 'ar_SA') {
      return Positioned(left: 15, top: 55,
        child: GestureDetector(
          onTap: () {
            print("REFRESH ORDER");
            setState(() {
              findTotal();
              getOrderDetail();
            });

            },
            child: Icon(
              Icons.refresh,color: Colors.white,
              size: 28.0,
            ),
          ),
        );

    } else {
      return  Positioned(right: 15, top: 55,
        child: GestureDetector(
          onTap: () {
            print("REFRESH ORDER");
            findTotal();
            getOrderDetail();

          },
          child: Icon(
            Icons.refresh,color: Colors.white,
            size: 28.0,
          ),
        ),
      );
    }
  }


   Widget detail(){

     double positionRight = 0;
     double positionLeft = 0;
     double positionMark = 0;



    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .30,
//          width: MediaQuery.of(context).size.height * .50,
          color: Colors.grey[800],
          child: Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 5, bottom: 90 ),
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

        backButton(),

        // TITLE
        Positioned(left: 25, top: 120,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(AppLocalizations.of(context).translate('order_detail'), style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 18),

              ),
//              Padding(
//                  padding: EdgeInsets.all( 20.0),
//                  child:
//              ),
            ],
          ),
        ),

        refreshButton(),

        Container(
        alignment: Alignment.bottomCenter,
        padding: new EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .22,
            right: 2.0,
            left: 2.0),
          child: Column(
            children: [
              CardDetails(),



              Row(
                children: <Widget>[
                  if(order.status == 3 || order.status == 4)
                    if(globals.order.cancelled != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text((globals.order.cancelled != null) ? (globals.order.cancelled.reason != null) ? globals.order.cancelled.reason : "" : "",style: TextStyle(fontWeight: FontWeight.bold,
                                      color: Configurations.themColor, fontSize: 18),),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text((globals.order.cancelled != null) ? (globals.order.cancelled.comment != null) ?globals.order.cancelled.comment : ""  : ""),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),


                  if(order.status == 2 && this.isCustomer == false)
                    Expanded(
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.attach_money, color: Configurations.themColor, size: 20,),
                            SizedBox(width: 8,),
                            Text(AppLocalizations.of(context).translate('submit_invoice'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                        onTap:  () => {
                          insertIvoiceDetail(),
                        },
                      ),
                      flex: 2,),

                  SizedBox(width: 2),

                  if(order.status != 5 && order.status != 4 && order.status != 3 && order.status != 6 && order.status != 1)
                    Expanded(child: Container(
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.cancel, color: Configurations.themColor, size: 20,),
                            SizedBox(width: 8,),
                            Text(AppLocalizations.of(context).translate('cancel'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        onTap:  () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return buildCancelDialog(context);
                            },
                          )
                        },
                      ),
                      color: Colors.transparent,
                    ), flex: 2,),

                  if(order.status == 6 && this.isCustomer == false)
                    Expanded(child: Container(

                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.thumb_up, color: Configurations.themColor, size: 20,),
                            SizedBox(width: 8,),
                            Text(AppLocalizations.of(context).translate('complete'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),],),
                        onTap: () => {

                          showDialog(context: context,
                            builder: (BuildContext context) {
                              return buildCompleteDialog(context);},)} ,
                      ), ),flex: 2,),


                  if(order.status == 5)
                    Expanded(child: Container(

                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.file_download, color: Configurations.themColor, size: 20,),
                            SizedBox(width: 8,),
                            Text(AppLocalizations.of(context).translate('download_invoice'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),],),
                        onTap: () async {


                          if(Platform.isIOS) {
                            final invoiceURL = Configurations.INVOICE_DOWNLALD_URL +  "?id=" + order.id.toString();
                            print(invoiceURL);
                            _launchURL(invoiceURL);
                          } else {

                            Widget_Helper.showLoading(context);
                            DownLoadHelper down = new DownLoadHelper();
                            String status = await down.downloadFile(setState, order.id.toString());

                            Widget_Helper.dismissLoading(context);
                            final result = await OpenFile.open(status);
                            printLog(result);

                          }
                        } ,
                      ),
                    ),
                      flex: 2,),
                ],
              ),

              SizedBox(height: 20,),
          ],
        ),),


      ],
    );
   }

  _launchURL(url) async {
//    const url = Configurations.BASE_URL + "/Terms_and_Condition_JAM.html";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw AppLocalizations.of(context).translate('launch_url')+' $url';
    }
  }

   Widget CardDetails (){
     String statusString = "";
     var status_color = null;
     var status_icon = null;

     switch(order.status) {
       case 1: statusString = AppLocalizations.of(context).translate('order_p');
       status_color = Colors.blue;
       status_icon = Icons.pan_tool;
       break;
       case 2: statusString = AppLocalizations.of(context).translate('order_a');
       status_color = Colors.green;
       status_icon = Icons.check_circle;
       break;
       case 3:
         if(globals.currentUser.roles[0].slug == "customer") {
           statusString = AppLocalizations.of(context).translate('order_cancel'); // You
         } else {
           statusString = AppLocalizations.of(context).translate('order_cancel');// + globals.order.orderer_name;
         }

         status_color = Colors.red;
         status_icon = Icons.cancel;
         break;
       case 4:
         if(globals.currentUser.roles[0].slug == "customer") {
           statusString = AppLocalizations.of(context).translate('order_cancel_b');
         } else {
           statusString = AppLocalizations.of(context).translate('order_cancel_b')+" "+ globals.order.orderer_name;
         }

         status_color = Colors.red;
         status_icon = Icons.cancel;
         break;
       case 5: statusString = AppLocalizations.of(context).translate('order_c');
       status_color = Colors.green;
       status_icon = Icons.check_circle;
       break;
       case 6: statusString = AppLocalizations.of(context).translate('invoice_sub');
       status_color = Configurations.themColor;
       status_icon = Icons.attach_money;
       break;
       default : statusString = AppLocalizations.of(context).translate('order_c');
       status_color = Colors.green;
       status_icon = Icons.check_circle;
     }
     (globals.order.rating == null)? isRatingDisplay = false : isRatingDisplay = true;

     String name = "";
     if(order.provider.organisation != null) {
       name = order.provider.organisation.name;
     } else {
       name = order.provider.first_name + " " + order.provider.last_name;
     }

//     print(globals.order.invoice.working_hr);
     String comment = "";
     if(globals.order.rating != null) {
       comment = (globals.order.rating.comment == null || globals.order.rating.comment.length == 0) ? "" : globals.order.rating.comment;
     }
//     print(globals.order.rating.toString());



     String addressString = "";
     if(globals.order.address != null) {
       addressString= globals.order.address.name;
//       addressString += ", " +globals.order.address.;
       if(globals.order.address.address_line1 != "" && globals.order.address.address_line1 != null) {
         addressString += ", " + globals.order.address.address_line1;
       }

       if(globals.order.address.address_line2 != "" && globals.order.address.address_line2 != null) {
         addressString += ", " + globals.order.address.address_line2;
       }

       if(globals.order.address.landmark != "" && globals.order.address.landmark != null) {
         addressString += ", " + globals.order.address.landmark;
       }
       if(globals.order.address.district != "" && globals.order.address.district != null) {
         addressString += ", " + globals.order.address.district;
       }

       if(globals.order.address.city != "" && globals.order.address.city != null) {
         addressString += ", " + globals.order.address.city;
       }

       if(globals.order.address.postal_code != "" && globals.order.address.postal_code != null) {
         addressString += ", " + globals.order.address.postal_code;
       }
       addressString += ".";
     }
     return Container(
//         color: Colors.grey,
//         height: 900.0,
       margin: EdgeInsets.symmetric(
         vertical: 16.0,
         horizontal: 16.0,),
       decoration: new BoxDecoration(
         color: Colors.white,
         shape: BoxShape.rectangle,
         borderRadius: new BorderRadius.circular(10.0),),

       child: Column(
         children: <Widget>[
           Padding(
             padding:  EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
             child: Column(
               children: [
                 // Booking Detail
                 Padding(
                   padding: const EdgeInsets.fromLTRB(0,10.0,0,0),
                   child: Row(children :[
                     Text(AppLocalizations.of(context).translate('txt_book_details'), style:
                     TextStyle(color: Configurations.themColor,
                         fontWeight: FontWeight.w700,fontSize: 16),),
                     Padding(
                       padding:EdgeInsets.symmetric(horizontal:10.0),
                       child:Container(
                         height:0.5,
                         width:MediaQuery.of(context).size.width * 0.4,
                         color:Colors.grey,),),
                   ]
                   ),
                 ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     setProfilePic()
//                   ],
//                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [

                         Text(AppLocalizations.of(context).translate('txt_order_id')+ " "+globals.order.id.toString(), style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14),),

                       ],
                     )

                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [

                         Text(AppLocalizations.of(context).translate('txt_dt')+ " " , style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14),),
                         Text(globals.order.booking_date , style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w300,fontSize: 14),),


                       ],
                     )

                 ),




                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [

                         Text(AppLocalizations.of(context).translate('txt_tym')+ " " , style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14),),
                         Text(globals.order.end_time , style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w300,fontSize: 14),)

                       ],
                     )

                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [

                         Text(AppLocalizations.of(context).translate('txt_order_status')+ " " , style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14),),
                         Text( statusString, style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w300,fontSize: 14),)

                       ],
                     )

                 ),

                 // Service Detail
                 Padding(
                   padding: const EdgeInsets.fromLTRB(0,20.0,0,0),
                   child: Row(children :[
                     Text(AppLocalizations.of(context).translate('txt_service_detail')+ " ",
                       style:
                     TextStyle(color: Configurations.themColor,
                         fontWeight: FontWeight.w700,fontSize: 16),),
                     Padding(
                       padding:EdgeInsets.symmetric(horizontal:10.0),
                       child:Container(
                         height:0.5,
                         width:MediaQuery.of(context).size.width * 0.4,
                         color:Colors.grey,),),
//                          Divider(color: Colors.black,
//                            thickness: 1,
//                            height: 5,
//
//                            endIndent: 1.0,
//                            indent: 1.0,)

                   ]
                   ),
                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [

                         Text((this.isCustomer == true) ?AppLocalizations.of(context).translate('txt_vendor'):
                         AppLocalizations.of(context).translate('txt_customer'), style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14),),
                         Text((this.isCustomer == true) ? name : globals.order.orderer_name , style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w300,fontSize: 14),)

                       ],
                     )

                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [

                         Text(AppLocalizations.of(context).translate('txt_services')+" ", style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14), maxLines: 2,),
                         SizedBox(width: 5,),
                         Flexible(
                           child: Text((globals.localization == 'ar_SA') ?
                           globals.order.service.arabic_name : globals.order.service.name , style:
                           TextStyle(color: Colors.black,
                               fontWeight: FontWeight.w300,fontSize: 14), maxLines: 2,),
                         )

                       ],
                     )

                 ),

                 if(globals.order.category != null)
                   Padding(
                       padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                       child: Row(
                         children: [

                           Text(AppLocalizations.of(context).translate('txt_category')+" " , style:
                           TextStyle(color: Colors.black,
                               fontWeight: FontWeight.w500,fontSize: 14),),
                           Text((globals.localization == 'ar_SA') ? globals.order.category.arabic_name : globals.order.category.name , style:
                           TextStyle(color: Colors.black,
                               fontWeight: FontWeight.w300,fontSize: 14),)

                         ],
                       )

                   ),

                 Visibility(visible: isRatingDisplay,
                   child:Column(
                     mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       SizedBox(height: 10,),
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
                       Text((globals.order.rating == null) ? "" : comment,
                         textAlign: TextAlign.left,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(fontWeight: FontWeight.w400,
                             fontSize: 12.0,color: Colors.blueGrey),),
//                       Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(70, 5, 10,10),
//                             child:
//                             ,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(70, 5, 10,10),
//                             child:
//                           ),
//                         ],
////                  crossAxisAlignment: CrossAxisAlignment.center,
////                mainAxisAlignment: MainAxisAlignment.center,
//                       ),
//                       Text((globals.order.comment == null) ? "" : globals.order.comment,textAlign: TextAlign.left,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0,color: Colors.blueGrey),),
                     ],
                   ),

                 ),

                 /// SHOW OTP
                 if((order.status == 6 || order.status == 2) && this.isCustomer == true)
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Visibility(child:
                       Padding(
                           padding: EdgeInsets.fromLTRB(0, 0, 0,0),
                           child: OutlineButton(onPressed: () => {
                             showBookingOTP()
                           }, child: Text(AppLocalizations.of(context).translate('txt_otp')),
//                               shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                             borderSide: BorderSide(style: BorderStyle.solid, color: Configurations.themColor),
                           )
                       ),
                         visible: !showOTP,
                       ),

                       Visibility(child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           SizedBox(height: 50,),
                           Text(AppLocalizations.of(context).translate('txt_otp1'), style: TextStyle(fontWeight: FontWeight.bold),),
                           Text(globals.order.otp.toString(),  style: TextStyle(fontWeight: FontWeight.w400)),
                         ],
                       ),
                         visible: showOTP,),


                     ],
                   ),

                 if(isRatingDisplay == true)
                 SizedBox(height: 10,),

                 if(order.status == 5 && this.isCustomer == true)
                   Visibility(visible: !isRatingDisplay,
                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[

                         OutlineButton(
                           borderSide: BorderSide(style: BorderStyle.solid, color: Configurations.themColor),

                           onPressed: () => {
                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return buildRatingDialog(context);
                               },
                             )
                           },
                           child: Text(AppLocalizations.of(context).translate('txt_sub_rating')),

                         ),

//                         Padding(
//                             padding: EdgeInsets.fromLTRB(70, 10, 10,10),
//                             child:
//                         ),
                       ],
                     ),
                   ),

                 Padding(
                   padding: const EdgeInsets.fromLTRB(0,20.0,0,0),
                   child: Row(children :[
                     Text(AppLocalizations.of(context).translate('txt_cust'), style:
                     TextStyle(color: Configurations.themColor,
                         fontWeight: FontWeight.w700,fontSize: 16),),
                     Padding(
                       padding:EdgeInsets.symmetric(horizontal:10.0),
                       child:Container(
                         height:0.5,
                         width:MediaQuery.of(context).size.width * 0.3,
                         color:Colors.grey,),),
//                          Divider(color: Colors.black,
//                            thickness: 1,
//                            height: 5,
//
//                            endIndent: 1.0,
//                            indent: 1.0,)

                   ]
                   ),
                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [
                         Icon( Icons.location_on, color: Configurations.themColor,
                           size: 18,),
                         SizedBox(width: 5,),
                         Text(AppLocalizations.of(context).translate('txt_add')+"  ", style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14),),
                         Flexible(
                           child: Text(addressString , maxLines:2,style:
                           TextStyle(color: Colors.black,
                               fontWeight: FontWeight.w300,fontSize: 13),),
                         )

                       ],
                     )

                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [
                         Icon( Icons.mail_outline, color: Configurations.themColor,
                           size: 18,),
                         SizedBox(width: 5,),
                         Flexible(
                           child: Text(AppLocalizations.of(context).translate('txt_email')+ "  ",
                             maxLines: 3,
                             overflow: TextOverflow.ellipsis,
                             textAlign: TextAlign.start,
                             style:
                             TextStyle(color: Colors.black,
                               fontWeight: FontWeight.w500,fontSize: 14),
                             ),
                         ),
                         Text((globals.order.email == null)? "":globals.order.email, style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w300,fontSize: 14),)

                       ],
                     )

                 ),

                 Padding(
                     padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
                     child: Row(
                       children: [
                         Icon( Icons.phone_in_talk, color: Configurations.themColor,
                           size: 18,),
                         SizedBox(width: 5,),
                         Text(AppLocalizations.of(context).translate('txt_phn')+"  ", style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: 14),),
                         Text(globals.order.contact, style:
                         TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w300,fontSize: 14),)

                       ],
                     )

                 ),


                 Visibility(child: invoiceDetails(),
                   visible: (order.status == 6 || order.status == 5) ? true : false,),







               ],
             ),
           ),

           SizedBox(height: 20,),

           Row(

             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               if(order.status == 1 && order.status != 4 && order.status != 3 && this.isCustomer == false)
                 Expanded(child: ButtonTheme(
                   height: 50,
                   child:  RaisedButton(
                       color: Hexcolor('#70AF0D'),
                       textColor: Colors.white,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Icon(Icons.check_circle, color: Colors.white, size: 20,),
                           SizedBox(width: 10,),
                           Text(AppLocalizations.of(context).translate('accept'), style: TextStyle(fontSize: 14)
                           ),],),
                       onPressed: () => {print("Accept"),
                         orderAccept()}),), flex: 2,),

               if(order.status == 2)
                 Expanded(child: ButtonTheme(
                   height: 50,
                   child:  RaisedButton(
                       color: Hexcolor('#70AF0D'),
                       textColor: Colors.white,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Icon(Icons.check_circle, color: Colors.white, size: 20,),
                           SizedBox(width: 10,),
                           Text(AppLocalizations.of(context).translate('accepted'), style: TextStyle(fontSize: 14)
                           ),],),
                       onPressed: () => {
                         print("Accept"),
//                         orderAccept()
                       }
                       ),
                 ),
                   flex: 2,),
//                 Expanded(
//                   child:
//                 ButtonTheme(height: 50, child:  RaisedButton(
//                     color: Configurations.themColor,
//                     textColor: Colors.white,
//
//                     child: Row(
//                       children: <Widget>[
//                         Icon(Icons.attach_money, color: Colors.white, size: 20,),
//                         SizedBox(width: 8,),
//                         Text('Submit Invoice', style: TextStyle(fontSize: 14)
//                         ),],),
//                     onPressed: () => {print("COmplete"),
//                       insertIvoiceDetail(),
//                     })), flex: 2,),

//               if(order.status == 6 && this.isCustomer == false)
//                 Expanded(child: ButtonTheme(
//                   height: 50,
//                   child:  RaisedButton(color: Configurations.themColor,
//                       textColor: Colors.white,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                         Icon(Icons.thumb_up, color: Colors.white, size: 20,),
//                         SizedBox(width: 8,),
//                         Text('Complete', style: TextStyle(fontSize: 14)
//                         ),],),
//                       onPressed: () => {print("COmplete"),
//
//                         showDialog(context: context,
//                           builder: (BuildContext context) {
//                             return buildCompleteDialog(context);},)}),),flex: 2,),

               if(order.status != 5 && order.status != 4 && order.status != 3 && this.isCustomer == false)
                 SizedBox(width: 2,),

               if(order.status != 5 && order.status != 4 && order.status != 3 && order.status != 6 && order.status != 2)
                 Expanded(child: ButtonTheme(
                   height: 50,
                   child:  RaisedButton(color: Hexcolor('#C12E0A'),
                       textColor: Colors.white,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Icon(Icons.cancel, color: Colors.white, size: 20,),
                           SizedBox(width: 5,),
                           Text(AppLocalizations.of(context).translate('cancel'), style: TextStyle(fontSize: 14)
                           ),],
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
                 ), flex: 2,)
             ],
           ),








         ],
       )


     );
   }

  Widget setProfilePic(){
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        image:
        DecorationImage(
          image:
          AssetImage("assets/images/BG-1x.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(80.0),
        border: Border.all(
          color: Configurations.themColor,
          width: 0.9,
        ),
      ),
    );

  }

//  Widget detailUI(){
//     return SingleChildScrollView(
//         child: Column(mainAxisSize: MainAxisSize.min,
//         //crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           setOrderInfo(),
//           setServiceInfo(),
//           detailInfo(),
//           Visibility(child: invoiceDetails(),
//           visible: (order.status == 6 || order.status == 5) ? true : false,),
//
//           if(order.status == 5)
//           ButtonTheme(
//             minWidth: 270.0,
//             child:  RaisedButton(
//                 color: Configurations.themColor,
//                 textColor: Colors.white,
//                 child:  Text(
//                     AppLocalizations.of(context).translate('download_invoice'),
//                     style: TextStyle(fontSize: 16.5)
//                 ),
//               onPressed: () async {
//                   Widget_Helper.showLoading(context);
//                   DownLoadHelper down = new DownLoadHelper();
//                   String status = await down.downloadFile(setState, order.id.toString());
//                   Widget_Helper.dismissLoading(context);
//                   final result = await OpenFile.open(status);
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               if(order.status == 1 && order.status != 4 && order.status != 3 && this.isCustomer == false)
//               ButtonTheme(
//                 child:  RaisedButton(
//                     color: Configurations.themColor,
//                     textColor: Colors.white,
//                     child: Row(
//                       children: <Widget>[
//                         Icon(Icons.check_circle, color: Colors.white, size: 20,),
//                         SizedBox(width: 10,),
//                         Text(
//                             AppLocalizations.of(context).translate('accept'),
//                             style: TextStyle(fontSize: 14)
//                         ),
//                       ],
//                     ),
//                     onPressed: () => {
//                       print("Accept"),
//                       orderAccept()
//                     }
//                 ),
//               ),
//
//               if(order.status == 2 && this.isCustomer == false)
//                 ButtonTheme(
//                   child:  RaisedButton(
//                       color: Configurations.themColor,
//                       textColor: Colors.white,
//                       child: Row(
//                         children: <Widget>[
//                           Icon(Icons.attach_money, color: Colors.white, size: 20,),
//                           SizedBox(width: 8,),
//                           Text(
//                               AppLocalizations.of(context).translate('submit_invoice'),
//                               style: TextStyle(fontSize: 14)
//                           ),
//                         ],
//                       ),
//                       onPressed: () => {
//                         print("COmplete"),
//                         insertIvoiceDetail(),
////                         showDialog(
////                           context: context,
////                           builder: (BuildContext context) {
////                             return buildCompleteDialog(context);
////
////                           },
////                         )
//                       }
//                   ),
//                 ),
//               if(order.status == 6 && this.isCustomer == false)
//                 ButtonTheme(
//                   child:  RaisedButton(
//                       color: Configurations.themColor,
//                       textColor: Colors.white,
//                       child: Row(
//                         children: <Widget>[
//                           Icon(Icons.thumb_up, color: Colors.white, size: 20,),
//                           SizedBox(width: 8,),
//                           Text(
//                               AppLocalizations.of(context).translate('complete'),
//                               style: TextStyle(fontSize: 14)
//                           ),
//                         ],
//                       ),
//                       onPressed: () => {
//                         print("COmplete"),
//
//                   showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                            return buildCompleteDialog(context);
////
//                           },
//                         )
//                       }
//                   ),
//                 ),
//               if(order.status != 5 && order.status != 4 && order.status != 3 && this.isCustomer == false)
//               SizedBox(width: 50,),
//               if(order.status != 5 && order.status != 4 && order.status != 3 && order.status != 6)
//               ButtonTheme(
//                 child:  RaisedButton(
//                     color: Configurations.themColor,
//                     textColor: Colors.white,
//                     child: Row(
//                       children: <Widget>[
//                         Icon(Icons.cancel, color: Colors.white, size: 20,),
//                         SizedBox(width: 10,),
//                         Text(
//                             AppLocalizations.of(context).translate('cancel'),
//                             style: TextStyle(fontSize: 14)
//                         ),
//                       ],
//                     ),
//                     onPressed: () => {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return buildCancelDialog(context);
//
//                         },
//                       )
//                     }
//                 ),
//               ),
//             ],
//           ),
//         ]),
//     );
//  }


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

    String name = "";
    if(order.provider.organisation != null) {
      name = order.provider.organisation.name;
    } else {
      name = order.provider.first_name + " " + order.provider.last_name;
    }

    String comment = "";// (globals.order.rating.comment == null || globals.order.rating.comment.length > 0) ? "" : globals.order.rating.comment;

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
                Text((this.isCustomer == true) ? name : globals.order.orderer_name,
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
                      child: Text((globals.order.rating == null) ? "" : comment,textAlign: TextAlign.left,
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
         if((order.status == 6 || order.status == 2) && this.isCustomer == true)
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
      addressString = globals.order.address.name;

      if(globals.order.address.address_line1 != "" && globals.order.address.address_line1 != null) {
        addressString += ", " + globals.order.address.address_line1;
      }

      if(globals.order.address.address_line2 != "" && globals.order.address.address_line2 != null) {
        addressString += ", " + globals.order.address.address_line2;
      }

      if(globals.order.address.landmark != "" && globals.order.address.landmark != null) {
        addressString += ", " + globals.order.address.landmark;
      }

      if(globals.order.address.district != "" && globals.order.address.district != null) {
        addressString += ", " + globals.order.address.district;
      }
      if(globals.order.address.city != "" && globals.order.address.city != null) {
        addressString += ", " + globals.order.address.city;
      }

      if(globals.order.address.postal_code != "" && globals.order.address.postal_code != null) {
        addressString += ", " + globals.order.address.postal_code;
      }
      addressString += ".";
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
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).translate('comment')
              ),

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
            AppLocalizations.of(context).translate('rate'),
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
    data["comment"] = (txtComment.text.length ==0) ? "" : txtComment.text;
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
            buildCancelHeader(AppLocalizations.of(context).translate('service_can'), ),

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
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).translate('comment')
              ),
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
                data["comment"] = (txtCancel.text.length ==0 || txtCancel.text.length == null) ? " - " : txtCancel.text;
                data["booking_id"] = globals.order.id.toString();
                if(globals.currentUser.roles[0].slug == "customer") {
                  data["status"] = "4";
                } else {
                  data["status"] = "3";
                }
                orderStatusUpdate(data);
              },
              child:  Text(AppLocalizations.of(context).translate('ok'), style: TextStyle(fontSize: 20,color: Colors.white)),
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
            buildCancelHeader(AppLocalizations.of(context).translate('enter_otp')),

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
              child: Text(AppLocalizations.of(context).translate('submit'), style: TextStyle(fontSize: 20,color: Colors.white)),
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
      processCancelOrderResponse(syncUserResponse, data['status']);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  processCancelOrderResponse(Response res, String status)  {
    if (res != null) {
      if (res.statusCode == 200) {
        print("status change");
        Navigator.of(context).pop();
        ///////// change globale variable
        setState(() {
          if(globals.currentUser.roles[0].slug == "provider") {
            globals.order.status = int.parse(status);

            if(globals.order.status == 6) {
              getOrderDetail();
            }
            int idx = globals.listofOrders.indexWhere((element) => element.id == globals.order.id);
            if(idx != null) {
              globals.listofOrders[idx] = globals.order;
              print("LIST UPDATE");
            }
          } else {
//
          if(status == "4") {
            showInfoAlert(context, AppLocalizations.of(context).translate('booking_cancel'));

            int idx = globals.listofOrders.indexWhere((element) => element.id == globals.order.id);
            if(idx != null) {
              globals.order.status = 4;
              globals.order.cancelled = OrderCanelled(cancelReason, (txtCancel.text.length ==0 || txtCancel.text.length == null) ? " - " : txtCancel.text);
              globals.listofOrders[idx] = globals.order;
            }
          }




            print("ITS CUSTOMER");
          }
        });

      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
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



  void setOrderUpdate(int status) {
    setState(() {
             order.status = status;
            print("REFRESH DATA FROM API ::: ${order.status}");
            detail();

    });
  }

  processOrderResponse(Response res)  {
    if (res != null) {
      if (res.statusCode == 200) {
//        var data = json.decode(res.body);

        var data =  utf8.decode(res.bodyBytes); //json.decode(res.body);
//        printLog("RESMAYUR ==== ${utf8.decode(res.bodyBytes)}");
//        List roles = json.decode(data);
//        setState(() {

        var response_details = json.decode(res.body);
        printLog("Login Data: $response_details");
        //get auth UserID

        int status = response_details['status'];
        printLog("OrderStatus ::: $status");

        globals.order = Order.fromJson(json.decode(data));


        int idx = globals.listofOrders.indexWhere((element) => element.id == globals.order.id);

        if(idx != null) {
          globals.listofOrders[idx] = globals.order;

        }
        setOrderUpdate(status);


//          build(globals.context);
//          print("rating ::: ${globals.order.rating}");

//        });

      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }

  void insertIvoiceDetail(){
    showDialog(
      context: context,
      builder: (BuildContext context) => setOrderDetail(context),
    );
  }


  String findTotal() {
    printLog("findTotal method call : ${globals.order.servicePrice.price}");
    if(globals.order.invoice != null) {
      double cost = double.parse(globals.order.servicePrice.price);
      double serviceAmount = globals.order.invoice.working_hr * cost;

      int meterialAmount = globals.order.invoice.material_quantity * globals.order.invoice.material_price;

      int additional_total = globals.order.invoice.additional_charges * globals.order.invoice.working_hr;

      double sub_total = serviceAmount + additional_total + meterialAmount;

      double total_discount = sub_total - globals.order.invoice.discount;

//      double totalWithDiscount =  sub_total -  total_discount;
      double taxCut =  total_discount * globals.order.invoice.tax /100;
      double total = total_discount +  taxCut;

      return total.toStringAsFixed(2);
    } else {
      return "";
    }


  }

  Widget invoiceDetails(){
    String workingHour = (globals.order.invoice != null) ? globals.order.invoice.working_hr.toString() : "0";
    String materialQTY = (globals.order.invoice != null) ? globals.order.invoice.material_quantity.toString() : "0";
    String materialCost = (globals.order.invoice != null) ? globals.order.invoice.material_price.toString() : "0";
    String discount = (globals.order.invoice != null) ? globals.order.invoice.discount.toString() : "0";
    String tax = (globals.order.invoice != null) ? globals.order.invoice.tax.toString() : "0";
    String add_charge = (globals.order.invoice != null) ? globals.order.invoice.additional_charges.toString() : "0";
    String taxrate = (globals.order.invoice != null) ? globals.order.invoice.tax_rate.toString() : "0";




    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
    Padding(
      padding: const EdgeInsets.fromLTRB(0,10,0,0),
      child: Row(
        children: <Widget>[



          Text(AppLocalizations.of(context).translate('invoice'),
              style: TextStyle(color: Configurations.themColor, fontWeight: FontWeight.w700,fontSize: 16)),
          Padding(
            padding:EdgeInsets.symmetric(horizontal:10.0),
            child:Container(
              height:0.5,
              width:MediaQuery.of(context).size.width * 0.4,
              color:Colors.grey,),),

        ],
      ),
    ),



        Align(alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
            child: Text(AppLocalizations.of(context).translate('workinghrs')+" : " + workingHour, ),
          ),
        ),
//            Padding(
//              padding: EdgeInsets.fromLTRB(30, 10, 10,0),
//              child: Text("Materials : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
//            ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Text(AppLocalizations.of(context).translate('materials') , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

              Text(AppLocalizations.of(context).translate('qty')+" : " + materialQTY, ),
              Text(AppLocalizations.of(context).translate('price')+" : " + materialCost, ),
            ],
          ),
        ),
//            Column(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.all(1.0),
//                  child: Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Flexible(
//                          child:Text("Quantity :   " + materialQTY, ),
//                        ),
//                        SizedBox(width: 15,),
//                        Flexible(
//                          child:Text("Price :   " + materialCost, ),
//                        ),
//
//                      ]),
//                ),
//
//              ],),
        Padding(
          padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
          child: Text(AppLocalizations.of(context).translate('discount')+" : "  + discount, ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
          child: Text(AppLocalizations.of(context).translate('tax') +" : " + tax, ),
        ),


        Padding(
          padding: const EdgeInsets.fromLTRB(2,10.0,0,0),
          child: Text(AppLocalizations.of(context).translate('addcharge')+" : "  + add_charge, ),
        ),
        Align(alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2,10.0,0,2),
            child: Text(AppLocalizations.of(context).translate('total')+" : "  + findTotal() + "  QAR",style: TextStyle(color: Configurations.themColor, fontWeight: FontWeight.bold)),
          ),
        ),


      ],
    );

  }

  bool checkedValue = false;

  Widget setOrderDetail(BuildContext context){
      return AlertDialog(
          title:Center(child: Text(AppLocalizations.of(context).translate('order_detail'), style: TextStyle(fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.deepOrange),),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding( padding: EdgeInsets.only(top: 3, bottom: 5),
                        child: SizedBox(
                          height: 1.0,
                          child: new Center(
                            child: new Container(
                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                              height: 0.4,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.all(1.0),
                      child: Row(
                        children: [
                          Text(AppLocalizations.of(context).translate('timetaken')+" : "),
                          Expanded(
                            child: Container(height: 30,

                              child: TextFormField(
                                controller:wrking_hr,
                                textAlign: TextAlign.right,
                                cursorColor: Configurations.themColor,
                                decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Configurations.themColor)
                                ), labelStyle: TextStyle(color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Configurations.themColor),
                                  ),) ,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('enterworkhrs');
                                  }
                                  return null;
                                },


                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                              ),),
                          ),
                          SizedBox(width: 10,),
                          Text(AppLocalizations.of(context).translate('hrs'), style: TextStyle(fontWeight: FontWeight.bold),)


                        ],
                      ),),
//                      Padding(
//                        padding: const EdgeInsets.all(1.0),
//                        child: Text("Time Taken"),
//                      ),
//                     // Datepick(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Theme(data:ThemeData(unselectedWidgetColor: Configurations.themColor),
                              child: Checkbox(
                                value: checkedValue,
                                onChanged:  (newValue) {
                                  setState(() {
                                    checkedValue = newValue;
                                  });
                                },),
                            ),
                            Text(AppLocalizations.of(context).translate('materialused')),
                          ],

                        ),
                      ),


                      Visibility(
                        visible: checkedValue,
                        child: Container( height: 150,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              Padding( padding: EdgeInsets.only(top: 3, bottom: 5),
                                child: SizedBox(
                                  height: 1.0,
                                  child: new Center(
                                    child: new Container(
                                      margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                                      height: 0.4,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(5.0),
//                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                    children: <Widget>[
//                                      Flexible(
//                                          child: Text("Materials")
//                                      ),
//                                      Flexible(
//                                        child: Container(height: 10, width: 60,
//
//                                          child: Align(alignment:Alignment.center,child: TextField(controller: mtrl_used, )),
//                                        ),
//                                      ),
//                                    ]),
//                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                        child:Text(AppLocalizations.of(context).translate('qty')),
                                      ),
                                      Expanded(
                                        child: Container(height: 30, width: 100,

                                          child: TextField(
                                            controller: mtrl_qty..text='0',
                                            textAlign: TextAlign.right,
//                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Configurations.themColor)
                                            ), labelStyle: TextStyle(color: Colors.grey),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Configurations.themColor),
                                              ),) ,cursorColor: Configurations.themColor,


                                            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                                          ),),
                                      ),
                                    ]),
                              ),
                              Padding(padding: const EdgeInsets.all(5),
                              child: Align(alignment: Alignment.center ,child: Text("X")),),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[ Expanded(
                                      child:Text(AppLocalizations.of(context).translate('price')),
                                    ),
                                      Expanded(
                                        child: Container(height: 30, width: 100,

                                          child: TextField(
                                            textAlign: TextAlign.right,
                                            controller: mtrl_price..text='0',
                                            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                            decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Configurations.themColor)
                                            ), labelStyle: TextStyle(color: Colors.grey),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Configurations.themColor),
                                              ),) ,cursorColor: Configurations.themColor,

                                          ),),
                                      ),
                                    ]  ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding( padding: EdgeInsets.only(top: 3, bottom: 3),
                        child: SizedBox(
                          height: 1.0,
                          child: new Center(
                            child: new Container(
                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                              height: 0.4,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(AppLocalizations.of(context).translate('discount')+" : "),
                            Container(width: 90, height: 30,
                              padding: EdgeInsets.only(bottom: 1.0),
                              child: TextField(
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Configurations.themColor)
                              ),
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Configurations.themColor),
                                ),) ,cursorColor: Configurations.themColor,
                                controller: discnt..text='0',


                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                              ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(AppLocalizations.of(context).translate('tax')+" : "),
                            Container(width: 90, height: 30,
                              padding: EdgeInsets.only(bottom: 1.0),
                              child: TextField(textAlign: TextAlign.right,
                                decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Configurations.themColor)
                              ),
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Configurations.themColor),
                                ),) ,cursorColor: Configurations.themColor,
                                controller: tax..text='0',

                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                              ),),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: <Widget>[
                            Text(AppLocalizations.of(context).translate('addcharge')+" : "),
                            Expanded(
                              child: Container(width: 100, height: 30,
                                padding: EdgeInsets.only(bottom: 1.0),
                                child: TextField(textAlign: TextAlign.right,
                                  decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Configurations.themColor)
                                ),  labelStyle: TextStyle(color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Configurations.themColor),
                                  ),) ,cursorColor: Configurations.themColor,
                                  controller: add_charge..text='0',


                                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                                ),),
                            ),
                          ],
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 300.0,
                        child: RaisedButton(
                            color: Configurations.themColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),),
                            child: Text(
                                AppLocalizations.of(context).translate('btn_save'),
                                style: TextStyle(fontSize: 16.5)),
                            onPressed: () {callLoginAPI(setState); }),
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


  Future callLoginAPI(StateSetter setState) async {
    Map<String, String> data = new Map();
    data["order_id"] = globals.order.id.toString();
    data["working_hr"] = wrking_hr.text;
    data["tax_rate"] = (taxRate.text.isEmpty) ? "0" :  taxRate.text;
    data["tax"] = (tax.text.isEmpty) ? "0" :  tax.text;
    if(checkedValue) {
//      data["material_names"] =  ""; //(mtrl_used.text.isEmpty) ? "0" : mtrl_used.text ;
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
      processInvoiceResponse(syncUserResponse, setState);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }

  }
  void processInvoiceResponse(Response res, StateSetter setState){
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);

        print("order invoice response ::::::::$data");

        setState(() {
          globals.order.invoice = Invoice.fromJson(data);
          Navigator.pop(context);
//          getOrderDetail();
        });

        printLog('reached here');

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
                child: TextFormField( cursorColor: Colors.black,
                  decoration: InputDecoration( hintText: "worked hours plz", hintStyle: TextStyle(fontSize: 8) ),
                  controller: wrking_hr,
                  validator: (value) {
                  if (value.isEmpty) {
                     return "Please enter the working hours!!";
                     }
                     return null;
                    },



                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                ),),
              SizedBox(width: 10,),
              Text("Hours", style: TextStyle(fontWeight: FontWeight.bold),)

            ],
          ),
        ));
  }


}