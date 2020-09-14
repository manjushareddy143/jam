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

//class ServiceSelection extends StatelessWidget{
//
//  @override
//  Widget build(BuildContext context) {
//    return ServiceSelectionUIPage();
//  }
//}
class ServiceSelectionUIPage extends StatefulWidget {


//  final int isInitialScreen;
//  @override
//  ServiceSelectionUIPage({Key key, @required this.isInitialScreen}) : super(key: key);
//
//  @override
//  _ProviderListState createState() => _ProviderListState(service: this.service);


  final int isInitialScreen;
  ServiceSelectionUIPage({Key key, @required this.isInitialScreen}) : super(key: key);

  @override
  ServiceSelectionUIPageState createState() => ServiceSelectionUIPageState(isInitialScreen: this.isInitialScreen);


}
class ServiceSelectionUIPageState extends State<ServiceSelectionUIPage> with TickerProviderStateMixin {

  final int isInitialScreen;
  ServiceSelectionUIPageState({Key key, @required this.isInitialScreen});

  List<Service> selectedListOfService;
  static List<SelectedService> selectedServices;
  List<SubCategory> selectedListOfCategory;

  @override
  void initState(){
    selectedListOfService = new List<Service>();
    selectedServices = new List<SelectedService>();
    selectedListOfCategory = new List<SubCategory>();
    globals.context = context;

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
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        List roles = data;
        setState(() {
          listofServices = Service.processServices(roles);
        });
      } else {
        setState(() {

        });
      }
    } else {
    }
  }

bool Value = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    if (listofServices == null) {
      return new Scaffold(
        appBar: new AppBar(backgroundColor: Configurations.themColor,
          automaticallyImplyLeading: false,
          title: new Text(AppLocalizations.of(context).translate('loading')),
        ),
      );
    } else {
      return new Scaffold(

        appBar: new AppBar(backgroundColor: Configurations.themColor,
          title: new Text(AppLocalizations.of(context)
              .translate('init_services')),
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
      parent: Padding(
        padding: EdgeInsets.only(left: 20,top: 5,bottom: 5, right: 20),
        child: Container(
          decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
              border: Border.all(width: 0.9,color: Configurations.themColor)),


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
          icon = Icons.chevron_right;
          } else {
          icon = Icons.keyboard_arrow_down;
          }
        });
      },
    );
  }


  Widget ChildCard(SubCategory category,Service service ) {

    return Padding(
      padding: EdgeInsets.only(left: 20,top: 5,bottom: 5, right: 20),
      child: Container(
        decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
            border: Border.all(width: 0.9,color: Configurations.themColor)),

        margin: const EdgeInsets.only(left: 25.0),
        child: Row(
            children: <Widget>[
              Checkbox(
                  value:  (selectedListOfCategory.contains(category)) ? true : false,
                  onChanged: (bool value) {
                    setState(() {
                      category.isSelected = value;
                      if (selectedListOfCategory.contains(category)) {
                        selectedListOfCategory.remove(category);
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
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Configurations.themColor),
                        ),
                        hintText: "QR"
                    ) ,
                    onTap: () => getCategoryField(category, service),
                    onChanged: myCategory,
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    textInputAction: TextInputAction.done,
                  ),),
              )
            ]),),
    );
  }




  Widget parentNoChild(Service service) {
    return Parent(
      parent: Padding(
        padding: EdgeInsets.only(left: 20,top: 5,bottom: 5, right: 20),
        child: Container(
          decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
              border: Border.all(width: 0.9,color: Configurations.themColor)),

          child: Row(
              children: <Widget>[
                Checkbox(
                    value:  (selectedListOfService.contains(service)) ? true : false,
                    onChanged: (bool value) {
                      setState(() {
                        service.isSelected = value;
                        if (selectedListOfService.contains(service)) {
                          selectedListOfService.remove(service);
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
                  child: Container(width: 90, height: 40,
                    padding: EdgeInsets.only(bottom: 0.0),
                    child:
                    TextField(

                      decoration: InputDecoration(
                      suffix: Text("QR"),
                      hintText: "QR", labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Configurations.themColor),
                        ),

                    ),
                      onTap: () => getSelectedField(service),
                      onChanged: myService,
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
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
  }
  static var parent;
  static SubCategory onTapCategory;
  void getCategoryField(SubCategory category, Service service) {
    onTapService= service;
    onTapCategory = category;
  }

  static String fieldValue;
  myService(String str) {
    fieldValue = str;
    storeFormValue();

  }

  myCategory(String str){
    fieldValue = str;
    storeFormValueChild();

  }
  void storeFormValueChild(){
    if((selectedListOfService.contains(onTapService))&&(selectedListOfCategory.contains(onTapCategory)) ){
      if(selectedServices.any((element) => element.service_id == onTapService.id &&
          element.category_id == onTapCategory.id) == false) {
        selectedServices.add(SelectedService(onTapService.id, onTapCategory.id, int.parse(fieldValue)));

      } else {
        SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == onTapService.id);
        sltdsrv =selectedServices.firstWhere((element) => element.category_id == onTapCategory.id);
        int idx = selectedServices.indexWhere((element) => element == sltdsrv);
        selectedServices[idx] =  SelectedService(sltdsrv.service_id, sltdsrv.category_id, int.parse(fieldValue));
      }

    } else {

      setState(() {
        if (selectedListOfService.contains(onTapService)) {
        } else {
          selectedListOfService.add(onTapService);
        }
        if (selectedListOfCategory.contains(onTapCategory)) {
        } else {
          selectedListOfCategory.add(onTapCategory);
        }
        selectedServices.add(SelectedService(onTapService.id, onTapCategory.id, int.parse(fieldValue)));
      });
    }
  }

  void storeFormValue() {

    if (selectedListOfService.contains(onTapService)) {
      if(selectedServices.any((element) => element.service_id == onTapService.id) == false) {
        selectedServices.add(SelectedService(onTapService.id, 0 , int.parse(fieldValue)));
      } else {
        SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == onTapService.id);
        int idx = selectedServices.indexWhere((element) => element == sltdsrv);
        selectedServices[idx] =  SelectedService(sltdsrv.service_id, 0, int.parse(fieldValue));
      }

    } else {
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
    bool isValid = true;
    for(int i = 0; i < selectedListOfService.length; i++) {
      if(selectedServices.any((element) => element.service_id == selectedListOfService[i].id)) {
      } else {
        isValid = false;
      }
    }
    if(isValid == false) {
      showInfoAlert(context, "Please insert Price for Services and Categories");
    }
    else {
      selectedListOfService.forEach((service) {
        if(selectedServices.any((selection) => service.id == selection.service_id)) {
            String srvcName = service.name;
            if (serviceNamesString.isEmpty) {
              serviceNamesString = "* " + srvcName;
            } else {
              if(!serviceNamesString.contains(srvcName)) {
                serviceNamesString += "\n* " +srvcName;
              }
            }
          if(selectedServices.where((element) => service.id == element.service_id).length > 0) {
            selectedServices.where((element) => service.id == element.service_id).forEach((element) {
              if(element.category_id != 0) {
                SubCategory sbctgry = service.categories.firstWhere((category) => category.id == element.category_id);
                if (serviceNamesString.isEmpty) {
                  serviceNamesString = "\t\t - " + sbctgry.name;
                } else {
                  serviceNamesString += "\n\t\t - " +sbctgry.name;
                }
              }
            });
          }
        }
      });



      if(this.isInitialScreen == 0) {
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => InitialProfileScreen(),
//            ));
        Navigator.pop(context);

      } else {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InitialProfileScreen(),
            ));

      }

    }
  }
}