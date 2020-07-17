import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/provider.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/InquiryForm.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:math' as math;
import 'package:jam/app_localizations.dart';
import 'package:jam/screens/vendor_profile.dart';
import 'package:jam/globals.dart' as globals;
//class ProviderListScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Center(child: ProviderListPage());
//  }
//}

class ProviderListPage extends StatefulWidget {
  final Service service;
  ProviderListPage({Key key, @required this.service}) : super(key: key);

  @override
  _ProviderListState createState() => _ProviderListState(service: this.service);
}

class _ProviderListState extends State<ProviderListPage> {
  final Service service;
  _ProviderListState({Key key, @required this.service});

  List<User> listofProviders;
  String image = "";

  SubCategory selectedSubCategory;
  List<DropdownMenuItem<SubCategory>> _dropDownSubCategory;
  String apiCallURL = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globals.context = context;
//    print('service.name === ${service.categories.length}');
//    print(service.id);
    if(service.categories.length > 0) {
      _dropDownSubCategory = buildSubCategoryDropDownMenuItems(service.categories);
      selectedSubCategory = _dropDownSubCategory[0].value;
    }

    apiCallURL = Configurations.PROVIDER_SERVICES_URL +
        "?service_id=" + this.service.id.toString() + "&lat=" + globals.latitude.toString() +
        "&long=" + globals.longitude.toString();

    new Future<String>.delayed(new Duration(microseconds: 10), () => null)
        .then((String value) {

      if(service.categories.length > 0) {
        apiCallURL += "&category_id=" + selectedSubCategory.id.toString();
      } else {
        apiCallURL += "&category_id=0";
      }
      print("apiCallURL === ${apiCallURL}");
      getProviders(apiCallURL);
    });
   // print("after getprovider!");
  }

  List<DropdownMenuItem<SubCategory>> buildSubCategoryDropDownMenuItems(List<SubCategory> listSubCategory) {
    List<DropdownMenuItem<SubCategory>> items = List();
    listSubCategory.forEach((val) {
      items.add(DropdownMenuItem(value: val, child: Text(val.name)));
    });
    return items;
  }

  getProviders(String url) async {
    try {
      HttpClient httpClient = new HttpClient();

      var syncProviderResponse = await httpClient.getRequest(context, url, null, null, true, false);
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
          listofProviders = User.processListOfUser(providers);
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
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
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

//  String selectedService;

  void changedDropDownItem(SubCategory selectedItem) {
    setState(() {
      selectedSubCategory = selectedItem;
      print(selectedSubCategory);
      if(service.categories.length > 0) {
        apiCallURL += "&category_id=" + selectedSubCategory.id.toString();
      }
      print("apiCallURL === ${apiCallURL}");
      getProviders(apiCallURL);
    });
  }

  List<Widget> listOfCards() {
    List<Widget> list = new List();

    list.add(Image.network(
      this.service.banner_image,
      fit: BoxFit.fill,
      width: MediaQuery. of(context). size. width,
      height: 100,
    ));

    if(this.service.categories.length > 0) {
      list.add(
          Row(
            children:[
              Text("Subcategories" , style: TextStyle(fontSize: 15 , color: Colors.black45)),
              SizedBox(width: 20,),
              Expanded(child:  DropdownButton(
                  underline: SizedBox(),
                  isExpanded: true,
                  value: selectedSubCategory,
                  icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
                  items: _dropDownSubCategory,
                  onChanged: changedDropDownItem),
              ),

            ],
          )
      );
    }


    for(int providerCount = 0; providerCount< listofProviders.length; providerCount++) {
      print("listofProviders === ${listofProviders[providerCount]}");
        User user = listofProviders[providerCount];
        list.add(setupCard(user, service));
    }


    return list;
  }

  AssetImage setImgPlaceholder() {
    return AssetImage("assets/images/BG-1x.jpg");
  }


  Widget setupCard(User user, Service service) {



    double rating = (user.rate.length == 0)? 0.0 : double.parse(user.rate[0].rate).floorToDouble(); //double.parse(provider.rate).floorToDouble();
    String review = (user.rate.length == 0)? "0" : user.rate[0].reviews.toString(); //double.parse(provider.rate).floorToDouble();
    String img = "";
    String name = "";
    if(user.organisation != null) {
      if(user.organisation.logo != null) {
        img = (user.organisation.logo.contains("http")) ? user.organisation.logo : Configurations.BASE_URL + user.organisation.logo;
      } else {
        img = null;
      }
      name = user.organisation.name;
    } else {
      if(user.image != null) {
        if(user.image.contains("http")) {
          img = user.image;
        } else {
          img = (user.image.contains(Configurations.BASE_URL)) ? user.image : Configurations.BASE_URL +user.image;
        }
      } else {
        img = null;
      }

      name = user.first_name;
    }

    print("img === ${img}");
    return
      new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            onTap: ()=> {
            print("USERSS ${user.services}"),
           Navigator.push(
           context,
          MaterialPageRoute (
              builder: (context) =>
              VendorProfileUIPage(provider: user, service: service, category: selectedSubCategory,) //provider.service
            )
           ),
            },
            leading: Container(
              width: 60,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    image: (img != null)?
                    NetworkImage(img) : setImgPlaceholder(),
                    fit: BoxFit.fill,
                  )),
            ),
            title: Text(name),
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//              Text(user.first_name),
//              Text(user.first_name)
//            ],),
            subtitle:   Text(AppLocalizations.of(context).translate('experience') +' 2 Years'),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: rating,
                  size: 20.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  //unfilledStar: Icon(Icons., color: Colors.grey),
                  spacing:0.0,
                  onRatingChanged: (v) {},
                ),
                Text( " " + review + " " + AppLocalizations.of(context).translate('reviews'),textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0,color: Colors.blueGrey),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Cost  ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold),
                ),
                Text(user.price,
                  style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold
                  ),
                ),
                Text("/hr",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),

          Align(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton.icon(
                        icon: Icon(Icons.monetization_on, color: Configurations.themColor),
                        label: Text(AppLocalizations.of(context).translate('quotes'), style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Configurations.themColor)),
                        onPressed: () {
                         if(globals.guest == true){
                            show();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InquiryPage(service: this.service, provider: user,
                                        category: selectedSubCategory)
                                )
                            );
                          }
                        },
                      ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: FlatButton.icon(
                      icon: Icon(
                          Icons.call, color: Configurations.themColor
                      ),
                      label: Text(
                          AppLocalizations.of(context).translate('call'),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Configurations.themColor
                          )
                      ),
                      onPressed: () {
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

  void show(){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        content: Text("You cant place order, Login first!!!", style: TextStyle(color: Colors.teal),),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton (
            child: new Text("OK", style: TextStyle(color: Colors.orangeAccent),),
            onPressed: () {
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => UserLogin()));
            },
          ),
        ],
      );
    });
  }
}