import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:jam/api/detailStart.dart';
import 'package:jam/models/service.dart';
import 'dart:math' as math;

import 'package:jam/placeholder_widget.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/provider_list_screen.dart';
import 'package:jam/swiper.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/globals.dart' as globals;

class CategoryScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Center(child: CategoryPage());
  }
}

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}



class _CategoryPageState extends State<CategoryPage> {


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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getServices() async {
    try {
      HttpClient httpClient = new HttpClient();
      var syncServicesResponse = await httpClient.getRequest(context,
          Configurations.SERVICES_ALL_URL, null, null, true, false);

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
//        var data = json.decode(res.body);
        var data =  utf8.decode(res.bodyBytes); //json.decode(res.body);
        printLog("RESMAYUR ==== ${utf8.decode(res.bodyBytes)}");
        List roles = json.decode(data);


//        List roles = data;
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
    // TODO: implement build
    if (isLoadin) {
      return new Scaffold(backgroundColor: Colors.orange[50],
        appBar: new AppBar(backgroundColor: Colors.deepOrange,
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    } else {
//      if(listofServices.length > 0) {
      return new Scaffold(backgroundColor: Colors.orange[50],
        body: SingleChildScrollView(
       // if(listofServices != null)
         child:  Column(children:


         listOfCards(),

         ),
        ),
      );
    }
  }
  List<Widget> listOfCards() {
    List<Widget> list = new List();
    for(int orderCount = 0; orderCount< listofServices.length; orderCount++) {
      list.add(SetupCard(listofServices[orderCount]));
    }
    return list;
  }

  Widget SetupCard(Service service){

      return
    GestureDetector(
      onTap:(){Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProviderListPage(service: service)
          )
      );},
      child: Card(margin: EdgeInsets.fromLTRB(10, 10, 10, 10),

      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.all(5),
            child:  Image.network( Configurations.BASE_URL +
              service.icon_image,
              height: 40.0, width: 80.0, fit: BoxFit.contain,),
          ),

          Padding(padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
            child: Text((globals.localization == 'ar_SA') ? service.arabic_name : service.name,maxLines: 2,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,

            ),
          )
        ],
      ),

  ),
    );}
}