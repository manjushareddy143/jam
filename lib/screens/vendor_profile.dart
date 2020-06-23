import 'dart:convert';
import 'dart:io';
import 'package:jam/models/service.dart';
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
class Profile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return VendorProfileUIPage();
    //Center(child: );
  }
}
class VendorProfileUIPage extends StatefulWidget {

  final User provider;
  final Service service;
  VendorProfileUIPage({Key key, @required this.provider, @required this.service}) : super(key: key);
//  VendorProfileUIPage({ Key key }) : super(key: key);
  @override
  VendorProfileState createState() => new VendorProfileState(provider: this.provider, service: this.service );
}
class VendorProfileState extends State<VendorProfileUIPage> with TickerProviderStateMixin {

  final User provider;
  final Service service;
  VendorProfileState({Key key, @required this.provider, @required this.service});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabList.add(new Tab(text: 'About',));
    tabList.add(new Tab(text: "Reviews",));
    _tabController= TabController(vsync: this, length: tabList.length);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Provider vendor;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   /* if(vendor == null) {
      return new Scaffold(

        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    }else{ */
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white70,
        title: Text("Vendor Profile", style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),),),


        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              setupVendor(MediaQuery.of(context).size),
              setupVendorDetails(),
            // setupVendorTab(),
            ],
          ),
        ),
      );
    }
 // }
  Widget setupVendor(Size screenSize )
  {
    String name = "";
    if(this.provider.organisation != null) {
      name = this.provider.organisation.name;
    } else {
      name = this.provider.first_name + " " + this.provider.last_name;
    }


    return Container(decoration: BoxDecoration(
      color: Colors.black,
    ),
      height: screenSize.height /3.0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20,bottom: 5),child: _buildProfileImage()),
          Center(
            child: Text(name,
              textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
              style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
          Padding(padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("32",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w300)),
                    Text("Job done",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200))
                  ],

                ),
                Column(

                  children: <Widget>[
                    Row(children:<Widget> [
                      Text("4.2",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w300)),
                      Icon(Icons.star, color: Colors.orangeAccent, size: 18,)
                    ]),
                    Text("Rating",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("2 Yr.",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w300)),
                    Text("Experience",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200))
                  ],
                ),
              ],

            ),
          )

        ],

      ),
    );
  }

  AssetImage setImgPlaceholder() {
    return AssetImage("assets/images/BG-1x.jpg");
  }


  Widget _buildProfileImage(){

    String img = null;


  /*  if(this.provider.organisation != null) {
      if(this.provider.organisation.logo != null) {
        img = (this.provider.organisation.logo.contains(Configurations.BASE_URL)) ? this.provider.organisation.logo :
        Configurations.BASE_URL + this.provider.organisation.logo;
      } else {
        img = null;
//        img = (user.organisation.logo.contains(Configurations.BASE_URL)) ? user.organisation.logo : Configurations.BASE_URL + user.organisation.logo;
      }


    } else {
      if(this.provider.image != null) {
        img = (this.provider.image.contains(Configurations.BASE_URL)) ? this.provider.image :
        Configurations.BASE_URL + this.provider.image;
      } else {
//        img = (user.image.contains(Configurations.BASE_URL)) ? user.image : Configurations.BASE_URL +user.image;
      }


    } */


    return Center(
      child: Container(

        height: 100,
        width:100,
          decoration: BoxDecoration(
        image:
      DecorationImage(
        image: (img != null)?
        NetworkImage(img) : setImgPlaceholder(),
        fit: BoxFit.cover,
      ), borderRadius: BorderRadius.circular(80.0),
    border: Border.all(
    color: Colors.white,
    width: 0.5,
          )

      ),
    ),);

  }
  Widget setupVendorDetails() {
    print("PROVIDER ==== ${this.provider}");
    return Padding( padding: EdgeInsets.fromLTRB(20,20,20,5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.person, color: Colors.blueGrey, size: 20,),
              SizedBox(width: 10,),
              Text(this.provider.gender, style: TextStyle(color: Colors.blueGrey),)

            ],
          ),

          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          Row(
            children: <Widget>[
              Icon(Icons.location_on, color: Colors.blueGrey, size: 20,),
              SizedBox(width: 10,),
              Text((this.provider.address != null) ? "From" + this.provider.address[0].city : "", style: TextStyle(color: Colors.blueGrey),)

            ],
          ),
          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.local_library, color: Colors.blueGrey, size: 20,),
              SizedBox(width: 10,),
              Text("Knows English and Hindi", style: TextStyle(color: Colors.blueGrey),)

            ],
          ),
          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.access_time, color: Colors.blueGrey, size: 20,),
              SizedBox(width: 10,),
              Text("Monday - Friday | 9:30AM - 6:30PM", style: TextStyle(color: Colors.blueGrey),)

            ],
          ),
          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.settings, color: Colors.blueGrey, size: 20,),
              SizedBox(width: 10,),
              Flexible(
                child: Text("Wet Servicing, Repairing Work, Gas Charging, Intstallation/Uninstallation Services",
                  maxLines: 2,style: TextStyle(color: Colors.blueGrey),),
              )

            ],
          ),
          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.mail, color: Colors.blueGrey, size: 20,),
              SizedBox(width: 10,),
              Text("info@partservices.com", style: TextStyle(color: Colors.blueGrey),)

            ],
          ),
          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.call, color: Colors.blueGrey, size: 20,),
              SizedBox(width: 10,),
              Text("+911234567890", style: TextStyle(color: Colors.blueGrey),)

            ],
          ),
          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),










        ],
      ),
    );
  }
  List<Tab> tabList = List();
  TabController _tabController;
  Widget setupVendorTab(){
    return Column(
        children: <Widget>[
          new Container(color: Colors.black12,
            width: double.infinity,
            child: TabBar(
                controller: _tabController,
                indicatorColor: Configurations.themColor,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.black,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 2,
                      color: Configurations.themColor,
                    ),
                    insets: EdgeInsets.only(
                        left: 15,
                        right: 8,
                        bottom: 0)),
                isScrollable: true,

                //indicatorColor: Colors.teal,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs : tabList
            ),
          ),
          Container(
            height: 200,

            child: TabBarView(
              controller: _tabController,

              children:
              tabList.map((Tab tab){
                return _getPage(tab);
              }).toList(),

            ),),
        ]
    );
  }

  Widget _getPage(Tab tab){
    switch(tab.text){
      case 'About' : return setAboutus();
      case 'Reviews' : return setReviews();

    }
  }
  Widget setAboutus(){
    return Padding( padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'About Us', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ) ),
          SizedBox(height: 5,),
          Flexible(
            child: Text("Il y a peu de possibilité de travail alors beaucoup de gens quittent la campagne pour aller chercher du travail en ville.Après avoir quitté l'école je voudrais vivre en ville parce que je trouve qu'il y a plus de culture et c'est plus passionnant"
            , maxLines: 14,style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),),
          ),
          Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
                  borderRadius: BorderRadius.all( Radius.circular(2))),
                child: FlatButton.icon(
//                          color: Colors.red,
                  icon: Icon(Icons.monetization_on, color: Configurations.themColor), //`Icon` to display
                  label: Text(AppLocalizations.of(context).translate('quotes'), style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      color: Configurations.themColor)), //`Text` to display
                  onPressed: () {
                   // printLog('provider::: ${provider}');
                  /*  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InquiryPage())); */
                  },
                ),
              ),
              Padding(padding: EdgeInsets.all(10),
                child: Container(decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
                    borderRadius: BorderRadius.all( Radius.circular(2)),color: Colors.teal),
                  child: FlatButton.icon(
                    icon: Icon(
                        Icons.call, color: Colors.white
                    ),
                    label: Text(
                        AppLocalizations.of(context).translate('call'),
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white
                        )
                    ),
                    onPressed: () {
                      print('Call Press');
                    },
                  ),
                ),
              )
            ],
          ),


        ],
      ),
    );


  }
  Widget setReviews(){
    return Padding( padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Ratings & Reviews', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15 ) ),
          
          Padding(padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("4.0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 ),),
                Icon(Icons.star, color: Colors.orangeAccent, size: 15,),
                Text("1 Review"),
              ],
            ),
          ),
          Padding( padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: 1.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
       //   SwiperReviews(),




        ],
      ),
    );
  }
  Widget SwiperReviews(){
    return Swiper(
      layout: SwiperLayout.CUSTOM,
        //itemWidth: 600.0,
        itemBuilder: (BuildContext context, int photoIndex){
        return Column(
          children: <Widget>[
            Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("0", style: TextStyle(color:Colors.grey),),
                    Text("Excellent", style: TextStyle(color: Colors.grey),),
                    Row(
                      children: <Widget>[
                        Text("5", style: TextStyle(color: Colors.grey)),
                        Icon(Icons.star, color: Colors.grey,)
                      ],
                    )
                  ],
                ),
                Column( children: <Widget>[
                  Text("1", style: TextStyle(color:Colors.orangeAccent),),
                  Text("Good", style: TextStyle(color: Colors.teal),),
                  Row(
                    children: <Widget>[
                      Text("4", style: TextStyle(color: Colors.grey)),
                      Icon(Icons.star, color: Colors.orangeAccent,)
                    ],
                  )
                ],),
                Column( children: <Widget>[
                  Text("0", style: TextStyle(color:Colors.grey),),
                  Text("Average", style: TextStyle(color: Colors.grey),),
                  Row(
                    children: <Widget>[
                      Text("3", style: TextStyle(color: Colors.grey)),
                      Icon(Icons.star, color: Colors.grey,)
                    ],
                  )
                ],),
                Column( children: <Widget>[
                  Text("0", style: TextStyle(color:Colors.grey),),
                  Text("Bad", style: TextStyle(color: Colors.grey),),
                  Row(
                    children: <Widget>[
                      Text("2", style: TextStyle(color: Colors.grey)),
                      Icon(Icons.star, color: Colors.grey,)
                    ],
                  )
                ],),
                Column( children: <Widget>[
                  Text("0", style: TextStyle(color:Colors.grey),),
                  Text("Very Bad", style: TextStyle(color: Colors.grey),),
                  Row(
                    children: <Widget>[
                      Text("1", style: TextStyle(color: Colors.grey)),
                      Icon(Icons.star, color: Colors.grey,)
                    ],
                  )
                ],),

              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20,bottom: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 Row(
                   children: <Widget>[
                     Text("Nancy", style: TextStyle(fontWeight: FontWeight.w400),),

                   ],
                 ),

                  Text("27 Sep 2019 | Repairing work", style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),)


                ],
              )
            ),
            SizedBox(height: 5,),
            Flexible(
              child: Text("Il y a peu de possibilité de travail alors beaucoup de gens quittent la campagne pour aller chercher du travail en ville.Après avoir quitté l'école je voudrais vivre en ville parce que je trouve qu'il y a plus de culture et c'est plus passionnant"
                , maxLines: 14,style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),),
            ),

            Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
                    borderRadius: BorderRadius.all( Radius.circular(2))),
                  child: FlatButton.icon(
//                          color: Colors.red,
                    icon: Icon(Icons.monetization_on, color: Configurations.themColor), //`Icon` to display
                    label: Text(AppLocalizations.of(context).translate('quotes'), style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                        color: Configurations.themColor)), //`Text` to display
                    onPressed: () {
                      // printLog('provider::: ${provider}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InquiryPage()));
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),
                  child: Container(decoration:BoxDecoration(border: Border.all(color: Configurations.themColor, width: 1),
                      borderRadius: BorderRadius.all( Radius.circular(2)),color: Colors.teal),
                    child: FlatButton.icon(
                      icon: Icon(
                          Icons.call, color: Colors.white
                      ),
                      label: Text(
                          AppLocalizations.of(context).translate('call'),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                          )
                      ),
                      onPressed: () {
                        print('Call Press');
                      },
                    ),
                  ),
                )
              ],
            ),



          ],
        );

        }
    );

  }
}