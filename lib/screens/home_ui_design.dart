import 'dart:collection';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/models/service.dart';
import 'dart:math' as math;

import 'package:jam/placeholder_widget.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/myProfile.dart';
import 'package:jam/screens/provider_list_screen.dart';
import 'package:jam/swiper.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';


class HomeUIDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: HomeUIPage());
  }
}

class HomeUIPage extends StatefulWidget {
  HomeUIPage({Key key}) : super(key: key);

  @override
  _HomeUIPageState createState() => _HomeUIPageState();
}

class _HomeUIPageState extends State<HomeUIPage> {
  List<Service> listofServices;
  int serviceIndex = 0;
  bool isLoadin = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    new Future<String>.delayed(new Duration(microseconds: 10), () => null)
        .then((String value) {
      getServices();
    });
  }

  getServices() async {
    try {
      HttpClient httpClient = new HttpClient();
      var syncServicesResponse = await httpClient.getRequest(context,
          Configurations.SERVICES_ALL_URL , null, null, true, false);

      processServiceResponse(syncServicesResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }
  void processServiceResponse(Response res) {
    if (res != null) {

      if (res.statusCode == 200) {
        var data =  utf8.decode(res.bodyBytes); //json.decode(res.body);
        printLog("RESMAYUR ==== ${utf8.decode(res.bodyBytes)}");
        List roles = json.decode(data);

        setState(() {
          listofServices = Service.processServices(roles);
          isLoadin = false;
        });

      } else {
        printLog("login response code is not 200");
        setState(() {
          isLoadin = false;
        });

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    globals.context = context;
    if (isLoadin) {
      return new Scaffold(backgroundColor: Colors.orange[50],
        appBar: new AppBar(backgroundColor: Colors.deepOrange,
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    } else {
//      if(listofServices.length > 0) {




//


        return new Scaffold(
          backgroundColor: Colors.orange[50],
          body: CustomScrollView(
            slivers: <Widget>[
              SliverFixedExtentList(
                itemExtent: 50.0,
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,10,0),
                      child: Container(child: Text(AppLocalizations.of(context).translate('categories'),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),)),
                    ),
                  ],
                ),
              ),

              if(listofServices != null)
              SliverGrid(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 5.0,
                  ),
                  /*crossAxisCount: 3, // how many grid needed in a row
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,*/
                  delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int serviceIndex) {
                      return
                        // children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(color: Colors.white,
                            alignment: FractionalOffset.center,
                            height: 50.0,
                            width: 50.0,
//                          decoration: BoxDecoration(
//                            border: Border.all(color: Colors.white ),
//                          ),
                            child: new GestureDetector(
                              //tapping to go the corresponding view linked with it using navigator
                              onTap: () {

                                printLog('click == ${listofServices[serviceIndex].name}');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
//                                              ProfileUIPage()
                                            ProviderListPage(service: listofServices[serviceIndex])
                                    )
                                );
                                //, _service[serviceIndex]
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 46.00,
                                    height: 46.00,
                                    child: Image.network(
                                      Configurations.BASE_URL + listofServices[serviceIndex].icon_image,
                                      fit: BoxFit.fill,
                                    ),
                                  ), //new Icon(Icons.face),

                                 Padding(padding: EdgeInsets.all(5.0)),


                                  Flexible(
                                    child: Text((globals.localization == 'ar_SA') ? listofServices[serviceIndex].arabic_name : listofServices[serviceIndex].name,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 10,letterSpacing: 0.8,color: Colors.black,fontWeight: FontWeight.w600),

                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                    },
                    childCount: listofServices.length,
                  )
              ),

              // Banner Swipe
              SliverFixedExtentList(
                itemExtent: 200.0,
                delegate: SliverChildListDelegate(
                  [
                    Container(child: CarouselDemo()),
                  ],
                ),
              ),

              //
              SliverFixedExtentList(
                itemExtent: 200.0,
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('home_txt_why'),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 28.0,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context).translate('home_txt_we'),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 19.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(width:  100,
                                child: GestureDetector(
                                  onTap: () => {
                                    print("EMAIL TO SUPPORT"),
                                  launch(_emailLaunchUri.toString())
                                  },
                                  child: Container(
//                                  width: 50,
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.account_box,
                                            color: Configurations.themColor, size: 40.0),
                                        Text(
                                          AppLocalizations.of(context).translate('support_email'),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                )


                                  ,),

                                SizedBox(width: 100,
                                child: GestureDetector(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.chat,
                                            color: Configurations.themColor, size: 40.0),
                                        Text(
                                          AppLocalizations.of(context).translate('support_chat'),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => {
                                    print("CALL TO CHAT"),
                                    launch(whatsAppChat("").toString())
                                  },
                                ),),

                                SizedBox(width: 100,
                                  child: GestureDetector(
                                    child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Icon(MaterialIcons.person,
                                                color: Configurations.themColor, size: 40.0),
                                            Text(
                                              AppLocalizations.of(context).translate('support_call'),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        )
                                    ),
                                    onTap: () => {
                                      print("CALL TO SUPPORT"),
                                      launch(_makePhoneCall('tel:+97477837501').toString())
                                    },
                                  ),
                                )
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );


    }
  }
  Future<void> _launched;

  String whatsAppChat(String message) {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/+97477837501/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=+97477837501&text=${Uri.parse(message)}";
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'admin@jam.com',
      queryParameters: {
        'subject': 'JAM%20Support'
      }
  );


//  SliverPersistentHeader makeHeader(String headerText) {
}

//class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//  _SliverAppBarDelegate({
//    @required this.minHeight,
//    @required this.maxHeight,
//    @required this.child,
//  }); //configuration for the slivers layout
//  final double minHeight;
//  final double maxHeight;
//  final Widget child;
//
//  @override
//  double get minExtent => minHeight;
//
//  @override
//  double get maxExtent => math.max(maxHeight, minHeight);
//
//  @override
//  Widget build(
//      BuildContext context, double shrinkOffset, bool overlapsContent) {
//    return new SizedBox.expand(child: child); //box with a specified size
//  }
//
//  @override //called to check if the present delegate is different from old delegate, if yes it rebuilds
//  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//    return maxHeight != oldDelegate.maxHeight ||
//        minHeight != oldDelegate.minHeight ||
//        child != oldDelegate.child;
//  }
//}
