import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/models/service.dart';
import 'dart:math' as math;

import 'package:jam/placeholder_widget.dart';
import 'package:jam/screens/provider_list_screen.dart';
import 'package:jam/swiper.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';

class HomeUIDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: HomeUIPage());
  }
}

class HomeUIPage extends StatefulWidget {
  const HomeUIPage({Key key}) : super(key: key);

  @override
  _HomeUIPageState createState() => _HomeUIPageState();
}

class _HomeUIPageState extends State<HomeUIPage> {
  List<Service> listofServices;
  int serviceIndex = 0;

//  List<String> serviceImage = [
//    'assets/images/paint.jpeg',
//    'assets/images/ac.jpeg',
////    'assets/images/electric.jpeg',
////    'assets/images/homeclean.jpg',
////    'assets/images/plumbing.jpeg',
////    'assets/images/agri.jpeg',
//  ];
//  List<String> servicePhrase = [
//    'Painting & Decor',
//    'AC installing & repair',
////    'Electrical Works',
////    'Home cleaning & Home Maids',
////    'Plumbing',
////    'Agricultural & garden services',
//  ];
//  final List<Widget> _service = [
//    //CollapsingList(),
//    //DetailPage(),
//    PlaceholderWidget(Colors.red),
//    HomeStart(),
//    PlaceholderWidget(Colors.grey),
//    PlaceholderWidget(Colors.white),
//    PlaceholderWidget(Colors.deepOrange),
//    PlaceholderWidget(Colors.green)
//  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    new Future<String>.delayed(new Duration(seconds: 5), () => null)
        .then((String value) {
      getServices();
    });
  }

  getServices() async {
    try {
      HttpClient httpClient = new HttpClient();
      var syncServicesResponse = await httpClient.getRequest(context,
          "http://jam.savitriya.com/api/v1/all_services", null, null, true, false);
      processServiceResponse(syncServicesResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }
  void processServiceResponse(Response res) {
    print('get daily format');
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print(data);
        List roles = data;
        setState(() {
          print("mayur 22");

          listofServices = Service.processServices(roles);
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
    print("mayur 11");
    if (listofServices == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else {
      return new Scaffold(
        body: CustomScrollView(
          //view that contains an expanding app bar followed by a list & grid
          slivers: <Widget>[
            makeHeader(""),
            //calling appbar method by passing the Text as argument.
            //Padding: const EdgeInsets.all(8.0),

            SliverGrid(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                /*crossAxisCount: 3, // how many grid needed in a row
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,*/
                delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int serviceIndex) {
                    return
                        // children: <Widget>[
                        Container(
                      alignment: FractionalOffset.center,
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]),
                      ),
                      child: new GestureDetector(
                        //tapping to go the corresponding view linked with it using navigator
                        onTap: () {

//                          printLog(listofServices[serviceIndex].name);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProviderListPage(service: listofServices[serviceIndex],))); //, _service[serviceIndex]
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 100.00,
                              height: 100.00,
                              child: Image.network(
                                listofServices[serviceIndex].icon_image,
                                fit: BoxFit.fill,
                              ),
                            ), //new Icon(Icons.face),

                            Padding(padding: EdgeInsets.all(1.0)),

                            Text(listofServices[serviceIndex].name,
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: listofServices.length,
                )),

            SliverFixedExtentList(
              itemExtent: 200.0,
              delegate: SliverChildListDelegate(
                [
                  Container(child: CarouselDemo()),
                ],
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 200.0,
              delegate: SliverChildListDelegate(
                [
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Why We Are?',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 28.0,
                            ),
                          ),
                          Text(
                            'We value our customers',
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
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.account_box,
                                        color: Colors.teal, size: 40.0),
                                    Text(
                                      'Verified Professionals',
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.assignment,
                                        color: Colors.teal, size: 40.0),
                                    Text(
                                      'Insured Work',
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  Icon(MaterialIcons.person,
                                      color: Colors.teal, size: 40.0),
                                  Text(
                                    'Professional Support',
                                  )
                                ],
                              )),
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

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
        //pinned: true,
        delegate: _SliverAppBarDelegate(
      minHeight: 60.0,
      maxHeight: 200.0,
      child: Container(
        //color: Colors.lightBlue,
        child: Center(
          child:
              //Text(headerText))),
              Image.asset(
            "assets/images/topbar.jpg",
            fit: BoxFit.fill,
          ),
        ),
      ),
    ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  }); //configuration for the slivers layout
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child); //box with a specified size
  }

  @override //called to check if the present delegate is different from old delegate, if yes it rebuilds
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
