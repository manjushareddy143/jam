import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/screens/InquiryForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/models/provider.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:jam/app_localizations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;

class Profile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return VendorProfileUIPage();
  }
}
class VendorProfileUIPage extends StatefulWidget {

  final User provider;
  final Service service;
  final SubCategory category;
  VendorProfileUIPage({Key key, @required this.provider, @required this.service,
    @required this.category}) : super(key: key);
//  VendorProfileUIPage({ Key key }) : super(key: key);
  @override
  VendorProfileState createState() => new VendorProfileState(provider: this.provider,
      service: this.service, category: this.category);
}
class VendorProfileState extends State<VendorProfileUIPage> with TickerProviderStateMixin {

  final User provider;
  final Service service;
  final SubCategory category;
  VendorProfileState({Key key, @required this.provider, @required this.service,
    @required this.category});
int swiperIndex =0;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Provider vendor;
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    // TODO: implement build
    var r = this.provider.rate;
      return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(backgroundColor: Colors.deepOrange,
        title: Text(AppLocalizations.of(context).translate('vendorprofile'), style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),),),


        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              setupProfile(),
              setReviews(),






//              setupVendor(MediaQuery.of(context).size),
//              setupVendorDetails(),

           // setupVendorTab(),
            ],
          ),
        ),
      );
    }
 // }
  Widget setupProfile(){
    return Container(
      height: 460.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: [
          setCard(),
          setImage(),
          setButton()

        ],
      ),
    );
  }
  Widget setButton(){
    return  Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: AlignmentDirectional.bottomCenter,
//      decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
//        borderRadius: BorderRadius.all( Radius.circular(10))),
      child: ButtonTheme(minWidth: 250,
        child: RaisedButton(
          padding: EdgeInsets.all(5.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),),

                                color: Configurations.themColor,
                                textColor: Colors.white,
         child: Text(AppLocalizations.of(context).translate('bookappointment'), style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: Colors.white)), //`Text` to display


          onPressed: () {
            if(globals.guest == true){
              show();
            } else {
              printLog('this.category::: ${this.category}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InquiryPage(service: service, provider: provider,
                            category: this.category,)));
            }
          },
        ),
      ),
    );
  }

  void show(){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text(AppLocalizations.of(context).translate('skip_placeOrder'), style: TextStyle(color: Configurations.themColor),),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton (
                child: new Text(AppLocalizations.of(context).translate('ok'), style: TextStyle(color: Colors.orangeAccent),),
                onPressed: () {
                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => UserLogin()));
                },
              ),
            ],
          );
        });
  }

  Widget setCard(){

    print("NAME == ${this.provider.first_name}");
    String name = "";
    if(this.provider.organisation != null) {
      name = this.provider.organisation.name;
    } else {
      name = this.provider.first_name + " " + this.provider.last_name;
    }


    String services = "";
    this.provider.services.forEach((element) {
      if (services.isEmpty) {
        services = (globals.localization == 'ar_SA') ? element.service.arabic_name : element.service.name;
      } else {
        if(!services.contains((globals.localization == 'ar_SA') ? element.service.arabic_name : element.service.name)) {
          if(globals.localization == 'ar_SA') {
            services += ", " + element.service.arabic_name;
          } else {
            services += ", " + element.service.name;
          }

        }
      }

      if(element.categories != null) {
        if (services.isEmpty) {
          if(globals.localization == 'ar_SA') {
            services = " - " +  element.categories.arabic_name;
          } else {
            services = " - " +  element.categories.name;
          }
        } else {
          if(globals.localization == 'ar_SA') {
            services += " - " +  element.categories.arabic_name;
          } else {
            services += " - " +  element.categories.name;
          }
//          services += " - " +element.categories.name;
        }
      }
    });

    String email = (this.provider.email != null) ? this.provider.email : "-";
    if(this.provider.organisation != null) {
      email = this.provider.organisation.admin.email;
    }

    String contact = (this.provider.contact != null) ? this.provider.contact : "-";
    if(this.provider.organisation != null) {
      contact = this.provider.organisation.admin.contact;
    }





    return Container(
      height: 1000,
        margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 30, bottom: 22),
    decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: new BorderRadius.circular(8.0),),

        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                    FlatButton.icon(onPressed: null,
                      icon: Icon(Icons.call, color: Configurations.themColor, size: 13,),
                      label: Text(AppLocalizations.of(context).translate('call'), style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500, fontSize: 14),),
                    ),


                FlatButton.icon(onPressed: () {
                  if(globals.guest == true){
                    show();
                  } else {
                    printLog('this.category::: ${this.category}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InquiryPage(
                                  service: service, provider: provider,
                                  category: this.category,)));
                  }
                },
                  icon: Icon(Icons.calendar_today, color: Configurations.themColor, size: 13,),
                  label: Text(AppLocalizations.of(context).translate('book'), style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500, fontSize: 14),),
                ),
            ]),



            Padding(
              padding: const EdgeInsets.only(top:8.0,bottom: 5),
              child: Center(
                child: Text(name,
                  textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                  style: TextStyle( fontSize: 17.0,fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
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
            Padding(padding: EdgeInsets.all(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text((this.provider.jobs_count == 0) ? "0" :this.provider.jobs_count.toString() ,
                          style: TextStyle(color: Colors.black,fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Text(AppLocalizations.of(context).translate('jobdone'),style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w400,fontSize: 11))
                    ],

                  ),
                  Column(

                    children: <Widget>[
                      Row(children:<Widget> [
                        Text((this.provider.rate.length == 0) ? "0" :
                        double.parse(this.provider.rate[0].rate).floorToDouble().toString(),
                            style: TextStyle(color: Colors.black,fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        Icon(Icons.star, color: Colors.orangeAccent, size: 13,)
                      ]),
                      Text(AppLocalizations.of(context).translate('rating'),style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w400,fontSize: 11))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("2 Yr.",style: TextStyle(color: Colors.black,fontSize: 13,
                          fontWeight: FontWeight.w600)),
                      Text(AppLocalizations.of(context).translate('experience'),style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w400,fontSize: 11))
                    ],
                  ),
                ],

              ),
            ),
            Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
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
           Padding( padding: EdgeInsets.fromLTRB(20,5,20,5),
           child: Column(
             children: [
               Row(
                 children: <Widget>[
                   Icon(Icons.person, color: Colors.grey, size: 14,),
                   SizedBox(width: 10,),

                   Text(AppLocalizations.of(context).translate(this.provider.gender), style:
                   TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 13),)

                 ],
               ),
               Padding(
                 padding: const EdgeInsets.only(top:8.0),
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.location_on, color: Colors.grey, size: 14,),
                     SizedBox(width: 10,),
                     Text((this.provider.address != null) ?  this.provider.address[0].city : "", style:
                     TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 13),)
//            Text("")

                   ],
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(top:8.0),
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.local_library, color: Colors.grey, size: 14,),
                     SizedBox(width: 10,),
                     Text(AppLocalizations.of(context).translate(this.provider.languages), style:
                     TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 13),)

                   ],
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(top:8.0),
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.access_time, color: Colors.grey, size: 14,),
                     SizedBox(width: 10,),
                     Text("Monday - Friday | 9:30AM - 6:30PM", style:
                     TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 13),)

                   ],
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(top:8.0),
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.mail, color: Colors.grey, size: 14,),
                     SizedBox(width: 10,),
                     Text(email, style:
                     TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),)

                   ],
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(top:8.0),
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.settings, color: Colors.grey, size: 14,),
                     SizedBox(width: 10,),
                     Expanded(
                       child: Text(services,
                         maxLines: 3,style:
                         TextStyle(color: Colors.black, fontWeight: FontWeight.w600),)
                     )

                   ],
                 ),
               ),

             ],
           ),),



          ],

    ),
    );

  }
  Widget setImage(){
    String img = "";
//    (this.provider.image != null && this.provider.image.contains("http"))
//        ? this.provider.image : Configurations.BASE_URL + this.provider.image;

    if( (this.provider.image != null && this.provider.image.contains("http"))) {
      img = this.provider.image;
    } else if(this.provider.image == null) {
      img = null;
    } else {
      img =  Configurations.BASE_URL + this.provider.image;
    }
    if(this.provider.organisation != null) {
      img = (this.provider.organisation.logo != null && this.provider.organisation.logo.contains("http"))
          ? this.provider.organisation.logo : Configurations.BASE_URL +this.provider.organisation.logo;
    }
    print("IM == ${img}");
    return new Container(
//      margin: new EdgeInsets.symmetric(
//          vertical: 8.0
//      ),
     //alignment: FractionalOffset.center,
      alignment: AlignmentDirectional.topCenter,

      child: Container(
        width: 73,
        height: 65,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            image: new DecorationImage(
              image: (img != null)?
              NetworkImage(img) : setImgPlaceholder(),
              fit: BoxFit.cover,
            )),
      ),
    );

  }
//  Widget setupVendor(Size screenSize )
//  {
//    print("NAME == ${this.provider.first_name}");
//    String name = "";
//    if(this.provider.organisation != null) {
//      name = this.provider.organisation.name;
//    } else {
//      name = this.provider.first_name + " " + this.provider.last_name;
//    }
//
//
//    return Container(decoration: BoxDecoration(
//      color: Colors.black,
//    ),
//      height: screenSize.height /3.0,
//      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//
//        children: <Widget>[
//          Padding(padding: EdgeInsets.only(top: 20,bottom: 5),child: _buildProfileImage()),
//          Center(
//            child: Text(name,
//              textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
//              style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w400,
//                  color: Colors.white),
//            ),
//          ),
//          Padding(padding: EdgeInsets.all(15),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                Column(
//                  children: <Widget>[
//                    Text((this.provider.jobs_count == 0) ? "0" :this.provider.jobs_count.toString() ,style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w300)),
//                    Text("Job done",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200))
//                  ],
//
//                ),
//                Column(
//
//                  children: <Widget>[
//                    Row(children:<Widget> [
//                      Text((this.provider.rate.length == 0) ? "0" :
//                      double.parse(this.provider.rate[0].rate).floorToDouble().toString(),
//                          style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w300)),
//                      Icon(Icons.star, color: Colors.orangeAccent, size: 18,)
//                    ]),
//                    Text("Rating",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200))
//                  ],
//                ),
//                Column(
//                  children: <Widget>[
//                    Text("2 Yr.",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w300)),
//                    Text("Experience",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200))
//                  ],
//                ),
//              ],
//
//            ),
//          )
//
//        ],
//
//      ),
//    );
//  }

  AssetImage setImgPlaceholder() {
    return AssetImage("assets/images/BG-1x.jpg");
  }


//  Widget _buildProfileImage(){
//
//
//    String img = "";
////    (this.provider.image != null && this.provider.image.contains("http"))
////        ? this.provider.image : Configurations.BASE_URL + this.provider.image;
//
//    if( (this.provider.image != null && this.provider.image.contains("http"))) {
//      img = this.provider.image;
//    } else if(this.provider.image == null) {
//      img = null;
//    } else {
//      img =  Configurations.BASE_URL + this.provider.image;
//    }
//    if(this.provider.organisation != null) {
//      img = (this.provider.organisation.logo != null && this.provider.organisation.logo.contains("http"))
//          ? this.provider.organisation.logo : Configurations.BASE_URL +this.provider.organisation.logo;
//    }
//  print("IM == ${img}");
//
//
//    return Center(
//      child: Container(
//
//        height: 100,
//        width:100,
//          decoration: BoxDecoration(
//        image:
//      DecorationImage(
//        image: (img != null)?
//        NetworkImage(img) : setImgPlaceholder(),
//        fit: BoxFit.cover,
//      ), borderRadius: BorderRadius.circular(80.0),
//    border: Border.all(
//    color: Colors.white,
//    width: 0.5,
//          )
//
//      ),
//    ),);
//
//  }
//  Widget setupVendorDetails() {
////    print("PROVIDER ==== ${this.provider.organisation.admin.first_name}");
//
//    String services = "";
//    this.provider.services.forEach((element) {
//      if (services.isEmpty) {
//        services = element.service.name;
//      } else {
//        if(!services.contains(element.service.name)) {
//          services += ", " +element.service.name;
//        }
//      }
//
//      if(element.categories != null) {
//        if (services.isEmpty) {
//          services = " - " + element.categories.name;
//        } else {
//          services += " - " +element.categories.name;
//        }
//      }
//    });
//
//    String email = (this.provider.email != null) ? this.provider.email : "-";
//    if(this.provider.organisation != null) {
//      email = this.provider.organisation.admin.email;
//    }
//
//    String contact = (this.provider.contact != null) ? this.provider.contact : "-";
//    if(this.provider.organisation != null) {
//      contact = this.provider.organisation.admin.contact;
//    }
//
//
//
//
//    return Padding( padding: EdgeInsets.fromLTRB(20,20,20,5),
//      child: Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Icon(Icons.person, color: Colors.blueGrey, size: 20,),
//              SizedBox(width: 10,),
//              Text(this.provider.gender, style: TextStyle(color: Colors.blueGrey),)
//
//            ],
//          ),
//          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: SizedBox(
//              height: 1.0,
//              child: new Center(
//                child: new Container(
//                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                  height: 0.2,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//          ),
//
//          Row(
//            children: <Widget>[
//              Icon(Icons.location_on, color: Colors.blueGrey, size: 20,),
//              SizedBox(width: 10,),
//              Text((this.provider.address != null) ? "From " + this.provider.address[0].city : "", style: TextStyle(color: Colors.blueGrey),)
////            Text("")
//
//            ],
//          ),
//          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: SizedBox(
//              height: 1.0,
//              child: new Center(
//                child: new Container(
//                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                  height: 0.2,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//          ),
//
//          Row(
//            children: <Widget>[
//              Icon(Icons.local_library, color: Colors.blueGrey, size: 20,),
//              SizedBox(width: 10,),
//              Text("Knows "+ this.provider.languages, style: TextStyle(color: Colors.blueGrey),)
//
//            ],
//          ),
//          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: SizedBox(
//              height: 1.0,
//              child: new Center(
//                child: new Container(
//                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                  height: 0.2,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//          ),
//
//          Row(
//            children: <Widget>[
//              Icon(Icons.access_time, color: Colors.blueGrey, size: 20,),
//              SizedBox(width: 10,),
//              Text("Monday - Friday | 9:30AM - 6:30PM", style: TextStyle(color: Colors.blueGrey),)
//
//            ],
//          ),
//          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: SizedBox(
//              height: 1.0,
//              child: new Center(
//                child: new Container(
//                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                  height: 0.2,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//          ),
//
//          Row(
//            children: <Widget>[
//              Icon(Icons.settings, color: Colors.blueGrey, size: 20,),
//              SizedBox(width: 10,),
//              Flexible(
//                child: Text(services,
//                  maxLines: 2,style: TextStyle(color: Colors.blueGrey),),
//              )
//
//            ],
//          ),
//          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: SizedBox(
//              height: 1.0,
//              child: new Center(
//                child: new Container(
//                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                  height: 0.2,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//          ),
//
//          Row(
//            children: <Widget>[
//              Icon(Icons.mail, color: Colors.blueGrey, size: 20,),
//              SizedBox(width: 10,),
//              Text(email, style: TextStyle(color: Colors.blueGrey),)
//
//            ],
//          ),
//          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: SizedBox(
//              height: 1.0,
//              child: new Center(
//                child: new Container(
//                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                  height: 0.2,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//          ),
//
//          Row(
//            children: <Widget>[
//              Icon(Icons.call, color: Colors.blueGrey, size: 20,),
//              SizedBox(width: 10,),
//              Text((contact != null) ? contact : "-", style: TextStyle(color: Colors.blueGrey),)
//
//            ],
//          ),
//          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: SizedBox(
//              height: 1.0,
//              child: new Center(
//                child: new Container(
//                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                  height: 0.2,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//          ),
//
//
//        ],
//      ),
//    );
//  }

//  List<Tab> tabList = List();
//  TabController _tabController;
//
//  Widget setupVendorTab(){
//    return Column(
//        children: <Widget>[
//          new Container(color: Colors.black12,
//            width: double.infinity,
//            child: TabBar(
//                controller: _tabController,
//                indicatorColor: Configurations.themColor,
//                labelColor: Colors.teal,
//                unselectedLabelColor: Colors.black,
//                indicator: UnderlineTabIndicator(
//                    borderSide: BorderSide(
//                      width: 2,
//                      color: Configurations.themColor,
//                    ),
//                    insets: EdgeInsets.only(
//                        left: 15,
//                        right: 8,
//                        bottom: 0)),
//                isScrollable: true,
//
//                //indicatorColor: Colors.teal,
//                indicatorSize: TabBarIndicatorSize.tab,
//                tabs : tabList
//            ),
//          ),
//          Container(
//            height: 550,
//
//            child: TabBarView(
//              controller: _tabController,
//
//              children:
//              tabList.map((Tab tab){
//                return _getPage(tab);
//              }).toList(),
//
//            ),),
//        ]
//    );
//  }
//
//  Widget _getPage(Tab tab){
//    switch(tab.text){
//    //  case 'About' : return setAboutus();
//      case 'Reviews' : return setReviews();
//
//    }
//  }
//  Widget setAboutus(){
//    return Padding( padding: EdgeInsets.all(20),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text(
//              'About Us', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ) ),
//          SizedBox(height: 5,),
//          Flexible(
//            child: Text("Il y a peu de possibilité de travail alors beaucoup de gens quittent la campagne pour aller chercher du travail en ville.Après avoir quitté l'école je voudrais vivre en ville parce que je trouve qu'il y a plus de culture et c'est plus passionnant"
//            , maxLines: 14,style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),),
//          ),
//          SizedBox(height: 10,),
//          Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              Container(decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
//                  borderRadius: BorderRadius.all( Radius.circular(5))),
//                child: FlatButton.icon(
//                  padding: EdgeInsets.all(5.0),
////                          color: Colors.red,
//                  icon: Icon(Icons.monetization_on, color: Configurations.themColor), //`Icon` to display
//                  label: Text(AppLocalizations.of(context).translate('quotes'), style: TextStyle(
//                      fontSize: 18.0,
//                      fontWeight: FontWeight.w300,
//                      color: Configurations.themColor)), //`Text` to display
//                  onPressed: () {
//                    printLog('this.category::: ${this.category}');
//                   Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) =>
//                                InquiryPage(service: service, provider: provider,
//                                  category: this.category,)));
//                  },
//                ),
//              ),
//              Padding(padding: EdgeInsets.all(10),
//                child: Container(decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
//                    borderRadius: BorderRadius.all( Radius.circular(5)),color: Colors.teal),
//                  child: FlatButton.icon(
//                    padding: EdgeInsets.fromLTRB(20,5,20,5),
//                    icon: Icon(
//                        Icons.call, color: Colors.white
//                    ),
//                    label: Text(
//                        AppLocalizations.of(context).translate('call'),
//                        style: TextStyle(
//                            fontSize: 18.0,
//                            fontWeight: FontWeight.w400,
//                            color: Colors.white
//                        )
//                    ),
//                    onPressed: () {
//                      print('Call Press');
//                    },
//                  ),
//                ),
//              )
//            ],
//          ),
//
//
//        ],
//      ),
//    );
//
//
//  }

  bool showReview = false;
  Widget setReviews(){
    showReview = (this.provider.reviews.length == 0) ? false : true;
    showReview = (this.provider.reviews.length == 0) ? false : true;
  String title = (this.provider.reviews.length == 0) ? "No Ratings" : "Ratings & Reviews";



    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//          Text(
//              title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15 ) ),
//          SizedBox(
//            height: 20,
//          ),
        for(int index = 0; index< provider.reviews.length; index++)
          if(this.provider.reviews[index].rate_by != null)
            Visibility(child:
          Container(
//            height: 160,
//            width: 320,
            padding: EdgeInsets.only(right: 20, left: 20),
            child:
            Card(color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 0),
                        child: Text(
                          this.provider.reviews[index].rating.toString() + ".0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 ),),),
//                        Expanded(
//                          child: ,
//                          flex: 2,
//                        ),
//                      Padding(padding: EdgeInsets.only(top: 10, bottom: 5),
//                        child: Row( mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text(this.provider.reviews[index].rating.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 ),),
//                            Icon(Icons.star, color: Colors.orangeAccent, size: 15,),
//                            Text(this.provider.reviews.length.toString()+" Review"),
//                          ],
//                        ),
//                      ),
//                      Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
//                        child: SizedBox(
//                          height: 1.0,
//                          child: new Center(
//                            child: new Container(
//                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
//                              height: 0.2,
//                              color: Colors.grey,
//                            ),
//                          ),
//                        ),
//                      ),


//                    SizedBox(height: 20,),

                      Padding(padding: EdgeInsets.only(right: 20, top: 10, bottom: 0),
                        child: Row(
                          children: <Widget>[
                            Text(capitalize(this.provider.reviews[index].rate_by.first_name ), style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
//                            Text(" / Posted on", style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12,))
                          ],
                        ),
                      ),
//                        Expanded(child: ,
//                          flex: 3,),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 8.0),
//                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Row(
//                              children: <Widget>[
//                                Text(this.provider.reviews[index].rate_by.first_name, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
//                                Padding(
//                                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
//                                  child: SmoothStarRating(
//                                    allowHalfRating: false,
//                                    starCount: 5,
//                                    rating:  this.provider.reviews[index].rating.toDouble(),
//                                    size: 20.0,
//                                    filledIconData: Icons.star,
//                                    halfFilledIconData: Icons.star,
//                                    color: Colors.orangeAccent,
//                                    borderColor: Colors.orangeAccent,
//                                    spacing:0.0,
//
//
//
//                                  ),
//                                ),
//
//
//                              ],
//                            ),
//
//                            Text("27 Sep 2019 | Repairing work", style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),)
//
//
//                          ],
//                        ),
//                      ),
//                    SizedBox(height: 10,),
//                    SizedBox(
//                      height: 50,
//                      child:
//                    ),
//                    SizedBox(height: 10,),

                      ]),
                  Padding(padding: EdgeInsets.only(left: 55, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Text( (this.provider.reviews[index].comment == null) ? "" : this.provider.reviews[index].comment,
                          maxLines: 14,style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),),
                      ],
                    ),
                  ),

                ],
              )



            ),
          ),
            visible: showReview,),

      ],
    );
  }


}