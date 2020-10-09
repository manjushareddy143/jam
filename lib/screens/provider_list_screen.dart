import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
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
    if (service.categories.length > 0) {
//      print('test ==== ${service.categories[0].toJson()}');
      _dropDownSubCategory =
          buildSubCategoryDropDownMenuItems(service.categories);
      selectedSubCategory = _dropDownSubCategory[0].value;
    }

    apiCallURL = Configurations.PROVIDER_SERVICES_URL +
        "?service_id=" +
        this.service.id.toString() +
        "&lat=" +
        globals.latitude.toString() +
        "&long=" +
        globals.longitude.toString();

    new Future<String>.delayed(new Duration(microseconds: 10), () => null)
        .then((String value) {
      if (service.categories.length > 0) {
        apiCallURL += "&category_id=" + selectedSubCategory.id.toString();
      } else {
        apiCallURL += "&category_id=0";
      }
      print("apiCallURL === ${apiCallURL}");
      getProviders(apiCallURL);
    });
    // print("after getprovider!");
  }

  List<DropdownMenuItem<SubCategory>> buildSubCategoryDropDownMenuItems(
      List<SubCategory> listSubCategory) {
    List<DropdownMenuItem<SubCategory>> items = List();
    listSubCategory.forEach((val) {
      items.add(DropdownMenuItem(
          value: val,
          child: Text((globals.localization == 'ar_SA')
              ? val.arabic_name
              : val.name))); // val.name
    });
    return items;
  }

  getProviders(String url) async {
    try {
      HttpClient httpClient = new HttpClient();

      var syncProviderResponse =
          await httpClient.getRequest(context, url, null, null, true, false);
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
    globals.context = context;
    if (listofProviders == null) {
      return new Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: new AppBar(
          backgroundColor: Colors.deepOrange,
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.orange[50],
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context).translate('vendorlist'),
              //listofProviders.length.toString() + ' ' + this.service.name,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: listOfCards(),
            ),
          ));
    }
  }

//  String selectedService;

  void changedDropDownItem(SubCategory selectedItem) {
    setState(() {
      selectedSubCategory = selectedItem;
      print(selectedSubCategory);
      if (service.categories.length > 0) {
        apiCallURL += "&category_id=" + selectedSubCategory.id.toString();
      }
      print("apiCallURL === ${apiCallURL}");
      getProviders(apiCallURL);
    });
  }

  List<Widget> listOfCards() {
    List<Widget> list = new List();

    if (this.service.categories.length > 0) {
      list.add(Row(
        children: [
          Text(AppLocalizations.of(context).translate('subcat'),
              style: TextStyle(fontSize: 15, color: Colors.black45)),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                value: selectedSubCategory,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Configurations.themColor,
                ),
                items: _dropDownSubCategory,
                onChanged: changedDropDownItem),
          ),
        ],
      ));
    }

    for (int providerCount = 0;
        providerCount < listofProviders.length;
        providerCount++) {
      User user = listofProviders[providerCount];
      list.add(setupCard(user, service));
    }

    return list;
  }

  AssetImage setImgPlaceholder() {
    return AssetImage("assets/images/BG-1x.jpg");
  }

  Widget setupCard(User user, Service service) {
    double rating = (user.rate.length == 0)
        ? 0.0
        : double.parse(user.rate[0].rate)
            .floorToDouble(); //double.parse(provider.rate).floorToDouble();
    String review = (user.rate.length == 0)
        ? "0"
        : user.rate[0].reviews
            .toString(); //double.parse(provider.rate).floorToDouble();
    String img = "";
    String name = "";
    if (user.organisation != null) {
      if (user.organisation.logo != null) {
        img = (user.organisation.logo.contains("http"))
            ? user.organisation.logo
            : Configurations.BASE_URL + user.organisation.logo;
      } else {
        img = null;
      }
      name = user.organisation.name;
    } else {
      if (user.image != null) {
        if (user.image.contains("http")) {
          img = user.image;
        } else {
          img = (user.image.contains(Configurations.BASE_URL))
              ? user.image
              : Configurations.BASE_URL + user.image;
        }
      } else {
        img = null;
      }

      name = user.first_name;
    }
    return new Container(
      height: 80.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          GestureDetector(
            child: vendorCard(user, service, capitalize(name)),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VendorProfileUIPage(
                            provider: user,
                            service: service,
                            category: selectedSubCategory,
                          ) //provider.service
                      )),
            },
          ),
          vendorThumbnail(img, user)
        ],
      ),
    );
  }

  Widget vendorThumbnail(String img, User user) {
    print(globals.localization);

    FractionalOffset alignment = FractionalOffset.centerLeft;
    if (globals.localization == 'ar_SA') {
      alignment = FractionalOffset.centerRight;
    }

    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 8.0),
      alignment: alignment,
      child: Container(
        width: 90,
        height: 150,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            image: new DecorationImage(
              image: (img != null) ? NetworkImage(img) : setImgPlaceholder(),
              fit: BoxFit.cover,
            )),
        child: GestureDetector(
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VendorProfileUIPage(
                          provider: user,
                          service: service,
                          category: selectedSubCategory,
                        ) //provider.service
                    )),
          },
        ),
      ),
    );
  }

  Widget vendorCard(User user, Service service, String name) {
    EdgeInsets margin1 = EdgeInsets.only(left: 40.0);
    EdgeInsets margin2 = EdgeInsets.only(left: 55.0, top: 10);
    if (globals.localization == 'ar_SA') {
      margin1 = EdgeInsets.only(right: 40.0);
      margin2 = EdgeInsets.only(right: 55.0, top: 10);
    }

    String rate = (user.rate.length > 0)
        ? double.parse(user.rate[0].rate).floor().toStringAsFixed(0)
        : "0";

    return new Container(
      height: 90.0,
      margin: margin1,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              width: 400,
              margin: margin2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('experience') +
                        ' 2 Years',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: VerticalDivider(
              color: Colors.black,
              thickness: 0.5,
              width: 5,
              endIndent: 5.0,
              indent: 5.0,
            ),
            flex: 0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: null,
                        icon: Icon(
                          Icons.star_border,
                          color: Colors.black,
                          size: 20,
                        ),
                        label: Text(
                          rate + "/5",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  width: 100,
                  height: 18,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: null,
                        icon: Icon(
                          Icons.call,
                          color: Colors.black,
                          size: 20,
                        ),
                        label: Text(
                          AppLocalizations.of(context).translate('call'),
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  width: 100,
                  height: 18,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: FlatButton.icon(
                    onPressed: () {
                      if (globals.guest == true) {
                        show();
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InquiryPage(
                                    service: this.service,
                                    provider: user,
                                    category: selectedSubCategory)));
                      }
                    },
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                      size: 20,
                    ),
                    label: Text(
                      AppLocalizations.of(context).translate('book'),
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  width: 100,
                  height: 18,
                )
              ],
            ),
            flex: 0,
          )
        ],
      ),
    );
  }

  void show() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "You cant place order, Login first!!!",
              style: TextStyle(color: Colors.teal),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "OK",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => UserLogin()));
                },
              ),
            ],
          );
        });
  }
}
