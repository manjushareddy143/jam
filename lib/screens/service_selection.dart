import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/models/selected_service.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/app_localizations.dart';
import 'package:tree_view/tree_view.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:http/http.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/screens/initial_profile.dart';

class ServiceSelection extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ServiceSelectionUIPage();
      //Center(child: );
  }
}
class ServiceSelectionUIPage extends StatefulWidget {

  ServiceSelectionUIPage({ Key key }) : super(key: key);
  @override
  ServiceSelectionUIPageState createState() => new ServiceSelectionUIPageState();
}
class ServiceSelectionUIPageState extends State<ServiceSelectionUIPage> with TickerProviderStateMixin {

  List<Service> selectedListOfService;
  static List<SelectedService> selectedServices;
//  static int storeCategory;
  List<SubCategory> selectedListOfCategory;

  @override
  void initState(){
    print("lets see");
    selectedListOfService = new List<Service>();
    selectedServices = new List<SelectedService>();
    selectedListOfCategory = new List<SubCategory>();

    selectedServices.clear();
    serviceNamesString = "";
    new Future<String>.delayed(new Duration(microseconds: 10), () => null)
        .then((String value) {
      getServices();
    });


  }
  getServices() async {
    try {
      HttpClient httpClient = new HttpClient();
      var syncServicesResponse = await httpClient.getRequest(
          context, Configurations.SERVICES_ALL_URL, null, null, true, false);

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
          listofServices = Service.processServices(roles);
          print("listofServices === ${listofServices.length}");
        });
      } else {
        printLog("login response code is not 200");
        setState(() {

        });
      }
    } else {
      print('no data');
    }
  }

bool Value = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    if (listofServices == null) {
      return new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    } else {
      return new Scaffold(

        appBar: new AppBar(
          title: new Text("Select Services"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 500,
                child: Stack(
                  children: <Widget>[
                    TreeView(
                      hasScrollBar: true,
                      parentList: setupParentList(),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: 300.0,
                child: RaisedButton(
                    color: Configurations.themColor,
                    textColor: Colors.white,
                    child: Text(
                        AppLocalizations.of(context).translate('btn_save'),
                        style: TextStyle(fontSize: 16.5)),
                    onPressed: () {
                      serviceSave();
                    }),
              ),

            ],
          ),
        ),
      );
    }
  }


  List<Parent> setupParentList() {
    List<Parent> list = new List();
    for(int prntCount =0; prntCount < listofServices.length; prntCount++) {
      if(listofServices[prntCount].categories.length > 0) {
        list.add(ParentWithChild(listofServices[prntCount]));
      } else {
        list.add(parentNoChild(listofServices[prntCount]));
      }

    }
    return list;
  }

  List<Widget> setupChildList(Service service) {
    List<Widget> list = new List();
    for(int chldCount = 0; chldCount < service.categories.length; chldCount++) {
      list.add(ChildCard(service.categories[chldCount],service));
    }
    return list;
  }

  var icon = Icons.chevron_right;
  bool isClickCard = false;
  Widget ParentWithChild(Service service) {
    return Parent(
      parent: Container(
        child: Card(elevation: 3.0,
          margin: EdgeInsets.fromLTRB(0.5, 5, 0.5, 5),
          child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(icon),
                    onPressed: () {
                      setState(() {

                      });
                  }
                ),
//                Checkbox(
//                    value:  (selectedListOfService.contains(service)) ? true : false,
//                    onChanged: (bool value) {
//
//                     printLog(value);
//                     setState(() {
//                       service.isSelected = value;
//                       if (selectedListOfService.contains(service)) {
//                          selectedListOfService.remove(service);
////                          SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == service.id);
////                          selectedServices.remove(sltdsrv);
//                      } else {
//                         selectedListOfService.add(service);
//                     }
//
//                     });
//                   }
//                    ),
                Container( height: 40, width: 40,
                  padding: EdgeInsets.all(2),
                  child: Image.network(service.icon_image),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Text(
                      service.name,
                      maxLines: 3,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),]),
        ),

      ),

      childList: ChildList(
        children:setupChildList(service)
      ),
      callback: (isSelected) {
        setState(() {
          if(isSelected) {
//            icon = Icons.star;
          icon = Icons.chevron_right;
          } else {
          icon = Icons.keyboard_arrow_down;
//            icon = Icons.keyboard;
          }
        });
      },
    );
  }

  isClickChild(Service service) {
    printLog("isClick === ${service.id}");
    setState(() {
//      isClickCard = isClick;
//      if(isClick == false) {
//
//        icon = Icons.keyboard_arrow_down;
//      } else {
//        icon = Icons.chevron_right;
//      }
    });

  }


  Widget ChildCard(SubCategory category,Service service ) {

    return Container(
      margin: const EdgeInsets.only(left: 25.0),
      child: Card(elevation: 2.0,
        margin: EdgeInsets.fromLTRB(0.5, 5, 0.5, 5),
        child: Row(
            children: <Widget>[
              Checkbox(
                  value:  (selectedListOfCategory.contains(category)) ? true : false,
                  onChanged: (bool value) {
                    setState(() {
                      category.isSelected = value;
                      if (selectedListOfCategory.contains(category)) {
                        selectedListOfCategory.remove(category);
//                        SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == service.id &&
//                            element.category_id == category.id);
//                        selectedServices.remove(sltdsrv);
                      } else {
                        selectedListOfCategory.add(category);
                        if (selectedListOfService.contains(service)) {
                        } else {
                          selectedListOfService.add(service);
                        }

                      }
                    });
                  }),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Text(
                  category.name,
                  maxLines: 3,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(padding: EdgeInsetsDirectional.fromSTEB(1,2,1,2),

                child: Container(width: 90, height: 30,
                  padding: EdgeInsets.only(bottom: 1.0),
                  child: TextField(
                    decoration: InputDecoration(
                        suffix: Text("QR"),
                        hintText: "QR"
                    ) ,
                    onTap: () => getCategoryField(category, service),

                    onChanged: myCategory,
                    keyboardType: TextInputType.number,

                  ),),
              )



              //TextField(
              // controller: prfl_servicePrice,
              //keyboardType: TextInputType.number,

              // ),
            ]),
      ),);
  }




  Widget parentNoChild(Service service) {
    return Parent(
      parent: Container(
        child: Card(elevation: 3.0,
          margin: EdgeInsets.fromLTRB(0.5, 5, 0.5, 5),
          child: Row(
              children: <Widget>[
                Checkbox(
                    value:  (selectedListOfService.contains(service)) ? true : false,
                    onChanged: (bool value) {
                      setState(() {
                        service.isSelected = value;
                        if (selectedListOfService.contains(service)) {
                          selectedListOfService.remove(service);
//                          SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == service.id);
//                          selectedServices.remove(sltdsrv);
                        } else {
                          selectedListOfService.add(service);
                        }
                      });
                    }
                    ),
                Container(height: 40, width: 40,
                  padding: EdgeInsets.all(2),
                  child: Image.network(service.icon_image),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Text(
                      service.name,
                      maxLines: 3,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(padding:  EdgeInsets.fromLTRB(10, 0, 0, 0),
//                EdgeInsetsDirectional.fromSTEB(10,2,1,0),
                  child: Container(width: 90, height: 40,
                    padding: EdgeInsets.only(bottom: 0.0),
                    child:
                    TextField(

                      decoration: InputDecoration(
//                          enabledBorder: OutlineInputBorder(
//                        borderSide: BorderSide(color: Colors.grey)
//                    ),
//                      prefixText: "QR",
                      suffix: Text("QR"),
                      hintText: "QR"

                    ),
                      onTap: () => getSelectedField(service),
                      onChanged: myService,
                      keyboardType: TextInputType.number,
//                      onEditingComplete: doneEdit,
//                      onSubmitted: doneSubmit,
                    ),
                  ),
                )
              ]),
        ),
      ),
      childList: ChildList(
          children: []
      ),
    );
  }


  static Service onTapService;
  void getSelectedField(Service service) {
    onTapService = service;


    print("selectedServices.length ${selectedServices.length}");
    selectedServices.forEach((element) {
      print("elements ${element.toJson()}");
    });

  }
  static var parent;
  static SubCategory onTapCategory;
  void getCategoryField(SubCategory category, Service service) {
    onTapService= service;
    onTapCategory = category;


    print("service ${service.name} category ${category.name} ${category.id}");
    selectedServices.forEach((element) {
      print("elements ${element.toJson()}");
    });

  }

  static String fieldValue;
  myService(String str) {
    print("onChange $str");
    fieldValue = str;
    storeFormValue();

  }

  myCategory(String str){
    print("onchangeChild $str");
    fieldValue = str;
    storeFormValueChild();

  }
  void storeFormValueChild(){

    if(selectedServices.any((element) => element.category_id == onTapCategory.id) == false) {
      selectedServices.add(SelectedService(onTapService.id, onTapCategory.id, int.parse(fieldValue)));
    } else {

      if((selectedListOfService.contains(onTapService))&&(selectedListOfCategory.contains(onTapCategory)) ){
        print("YES");
        SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == onTapService.id);
        sltdsrv =selectedServices.firstWhere((element) => element.category_id == onTapCategory.id);
        int idx = selectedServices.indexWhere((element) => element == sltdsrv);
        print("index === ${idx} == val ${sltdsrv.service_id} ${sltdsrv.category_id}");
        selectedServices[idx] =  SelectedService(sltdsrv.service_id, sltdsrv.category_id, int.parse(fieldValue));
      }
      else if((selectedListOfCategory.contains(onTapCategory))&& (!(selectedListOfService.contains(onTapService)))){
        print("NO");
        SelectedService sltdsrv = selectedServices.firstWhere((element) => element.category_id == onTapCategory.id);
        setState(() {
          if (selectedListOfService.contains(onTapService)) {
            selectedListOfService.remove(onTapService);
          } else {
            selectedListOfService.add(onTapService);
          }
        });
        int idx = selectedServices.indexWhere((element) => element == sltdsrv);
        selectedServices[idx] =  SelectedService(onTapService.id, sltdsrv.category_id, int.parse(fieldValue));
      }
      else{
      print("NUTERAL");
      setState(() {
        if (selectedListOfService.contains(onTapService)) {
          selectedListOfService.remove(onTapService);
        } else {
          selectedListOfService.add(onTapService);
        }
        if (selectedListOfCategory.contains(onTapCategory)) {
          selectedListOfCategory.remove(onTapCategory);
        } else {
          selectedListOfCategory.add(onTapCategory);

        }
        selectedServices.add(SelectedService(onTapService.id, onTapCategory.id, int.parse(fieldValue)));
      });

    }
    }

  }

  void storeFormValue() {

    if (selectedListOfService.contains(onTapService)) {


      if(selectedServices.any((element) => element.service_id == onTapService.id) == false) {
        selectedServices.add(SelectedService(onTapService.id, 0 , int.parse(fieldValue)));
      } else {
        SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == onTapService.id);
        print("yes ${sltdsrv}");
        int idx = selectedServices.indexWhere((element) => element == sltdsrv);
        print("index === ${idx} == val ${sltdsrv.service_id}");
        selectedServices[idx] =  SelectedService(sltdsrv.service_id, 0, int.parse(fieldValue));
      }

    } else {
      print("NO");
      setState(() {
        selectedListOfService.add(onTapService);
        selectedServices.add(SelectedService(onTapService.id, 0 , int.parse(fieldValue)));
      });

    }
  }

  List<Service> listofServices;
  static String serviceNamesString = "";

  void serviceSave() {

    serviceNamesString = "";

    printLog("${selectedListOfService.length} :: ${selectedServices.length}");
//    printLog("$selectedListOfService");
//    if(selectedListOfService.length != selectedServices.length ) {
//      showInfoAlert(context, "Please insert Price for Services and Categories");
//    }
    bool isValid = true;
    selectedServices.forEach((element) {
      print("selectedServices ${element.toJson()}");
    });
    for(int i = 0; i < selectedListOfService.length; i++) {
//      print("data === ${selectedServices.where((element) => element.service_id == selectedListOfService[i].id).length}");
      print("data === ${selectedServices.any((element) => element.service_id == selectedListOfService[i].id)}");
      print("service ${selectedListOfService[i].id}");
      if(selectedServices.any((element) => element.service_id == selectedListOfService[i].id)) {
      } else {
        print("no element");
        isValid = false;
      }
    }
    if(isValid == false) {
      showInfoAlert(context, "Please insert Price for Services and Categories");
    } else {

      selectedListOfService.forEach((service) {

        if(selectedServices.any((selection) => service.id == selection.service_id)) {
//          Service srvc = selectedListOfService.firstWhere((service) => service.id == element.service_id);
//          if(srvc != null) {
            String srvcName = service.name;
            if (serviceNamesString.isEmpty) {
              serviceNamesString = "* " + srvcName;
            } else {
              if(!serviceNamesString.contains(srvcName)) {
                serviceNamesString += "\n* " +srvcName;
              }
            }
          }
//        }


//        if(selectedServices.any((selection) => selection.category_id == service.category_id)) {
//          SubCategory ctgr = selectedListOfCategory.firstWhere((category) => category.id == element.category_id);
//          if(ctgr != null) {
//            String ctgrName = ctgr.name;
//            if (serviceNamesString.isEmpty) {
//              serviceNamesString = "\t - " + ctgrName;
//            } else {
//              if(!serviceNamesString.contains(ctgrName)) {
//                serviceNamesString += "\n\t - " +ctgrName;
//              }
//            }
//          }
//        }


      });

//      selectedServices.forEach((element) {
//        print("SELECTED DATA -===  ${element.toJson()}");
//
//        if(selectedListOfService.any((service) => service.id == element.service_id)) {
//          Service srvc = selectedListOfService.firstWhere((service) => service.id == element.service_id);
//          if(srvc != null) {
//            String srvcName = srvc.name;
//            if (serviceNamesString.isEmpty) {
//              serviceNamesString = "* " + srvcName;
//            } else {
//              if(!serviceNamesString.contains(srvcName)) {
//                serviceNamesString += "\n* " +srvcName;
//              }
//            }
//          }
//        }
//
//        if(selectedListOfCategory.any((category) => category.id == element.category_id)) {
//          SubCategory ctgr = selectedListOfCategory.firstWhere((category) => category.id == element.category_id);
//          if(ctgr != null) {
//            String ctgrName = ctgr.name;
//            if (serviceNamesString.isEmpty) {
//              serviceNamesString = "\t - " + ctgrName;
//            } else {
//              if(!serviceNamesString.contains(ctgrName)) {
//                serviceNamesString += "\n\t - " +ctgrName;
//              }
//            }
//          }
//        }
//      });

    }


    printLog("serviceNamesString === ${serviceNamesString}");
//    printLog("selected Services === ${selectedServices.length}");
//    printLog("Category === ${selectedListOfCategory.length}");
//    printLog("Services === ${selectedListOfService.length}");
//    if(selectedServices.length > 0) {
//      setState(() {
//        for(int i = 0; i < selectedListOfService.length; i++) {
//          String name = selectedListOfService[i].name;
//
//        }
//
////        print("service ==$serviceNamesString");
//
//
//        for(int i = 0; i < selectedListOfCategory.length; i++) {
//          String name = selectedListOfCategory[i].name;
////          print("single cate name ==$name");
//          if (serviceNamesString.isEmpty) {
//            serviceNamesString = "* " + name;
//          } else {
//            serviceNamesString += "\n* " +name;
//          }
//        }
////        print("category ==$serviceNamesString");
//
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InitialProfileScreen(),
            ));
//      });
//
//    } else {
//      showInfoAlert(context, "Please select services");
//
//    }

    
  }
  final prfl_servicePrice = TextEditingController();
}