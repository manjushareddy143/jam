import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jam/models/provider.dart';
import 'package:jam/models/service.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/InquiryForm.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:math' as math;

class ProviderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: ProviderListPage());
  }
}

class ProviderListPage extends StatefulWidget {
  final Service service;
  ProviderListPage({Key key, @required this.service}) : super(key: key);

  @override
  _ProviderListState createState() => _ProviderListState(service: this.service);
}

class _ProviderListState extends State<ProviderListPage> {
  final Service service;
  _ProviderListState({Key key, @required this.service});

  List<Provider> listofProviders;

//  int acIndex = 0;
//  List<String> acImage = [
//    'assets/images/vicky.jpg',
//    'assets/images/ayu.jpg',
//    'assets/images/shah.jpg',
//    'assets/images/sal.jpg',
//  ];
//  List<String> acName = [
//    'Himanshu Malik',
//    'Afrar Sheikh',
//    'Abdur Rahman',
//    'Osama',
//  ];
//  List<String> acExp = ['1', '3', '3.5', '4'];
//  List<String> acRev = ['3', '3', '5', '2'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('service.name === ${service}');
    print(service.id);

    new Future<String>.delayed(new Duration(seconds: 5), () => null)
        .then((String value) {
      getProviders();
    });
  }

  getProviders() async {
    try {
      HttpClient httpClient = new HttpClient();
      var syncProviderResponse = await httpClient.getRequest(context,
          Configurations.PROVIDER_SERVICES_URL + "?id=" + this.service.id.toString(), null, null, true, false);
      processProvidersResponse(syncProviderResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processProvidersResponse(Response res) {
    print('get daily format');
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print('providers=== $data');
        List providers = data;
        setState(() {
          listofProviders = Provider.processProviders(providers);
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

    if (listofProviders == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white70,
            title: Text(
              listofProviders.length.toString() + ' ' + this.service.name,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: listOfCards(),
            ),
          )
      );
    }

  }

  List<Widget> listOfCards() {
    List<Widget> list = new List();

    list.add(Image.network(
      this.service.banner_image,
      fit: BoxFit.contain,
    ));

    for(int providerCount = 0; providerCount< listofProviders.length; providerCount++) {
      printLog(listofProviders[providerCount].first_name);
      list.add(setupCard(listofProviders[providerCount]));
    }


    return list;
  }


  Widget setupCard(Provider provider) {
    return new Card(
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
                        provider.image),
                    fit: BoxFit.fill,
                  )),
            ),
            title: Text(provider.first_name),
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

//          SizedBox(
//            height: 10,
//          ),
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
                          print('Quotes Press');

                          Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) =>
                              InquiryPage(service: this.service)));
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
    );
  }

  _ratingChange(int rate) {
    printLog('rating change $rate');
  }
}
