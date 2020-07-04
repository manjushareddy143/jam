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
  List<Map<String,String>> selectedServicesJson = new List<Map<String,String>>();
  @override
  void initState(){
    print("lets see");
    printLog(selectedServicesJson);
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
        body: Column(
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

  Widget ParentWithChild(Service service) {
    return Parent(
      parent: Container(
        child: Card(elevation: 3.0,
          margin: EdgeInsets.fromLTRB(0.5, 5, 0.5, 5),
          child: Row(
              children: <Widget>[
                Checkbox(

                    value:  (selectedListOfService.contains(service)) ? true : false,
                    onChanged: (bool value) {

                     printLog(value);
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
        ),),
      childList: ChildList(
        children:setupChildList(service)
      ),
    );
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
                    printLog(value);
                    setState(() {
                      category.isSelected = value;
                      if (selectedListOfCategory.contains(category)) {
                        selectedListOfCategory.remove(category);
                      } else {
                        selectedListOfCategory.add(category);
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
                  child: TextField( decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  )) ,
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

  static List<Service> selectedListOfService = new List<Service>();
  List<SelectedService> selectedServices = new List<SelectedService>();
//  static int storeCategory;
   static List<SubCategory> selectedListOfCategory = new List<SubCategory>();


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
                      printLog(value);
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
                Padding(padding: EdgeInsetsDirectional.fromSTEB(10,2,1,2),
                  child: Container(width: 90, height: 30,
                    padding: EdgeInsets.only(bottom: 1.0),
                    child:
                    TextField( decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),

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
    if((selectedListOfService.contains(onTapService))&&(selectedListOfCategory.contains(onTapCategory)) ){
      SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == onTapService.id);
      sltdsrv =selectedServices.firstWhere((element) => element.category_id == onTapCategory.id);
      int idx = selectedServices.indexWhere((element) => element == sltdsrv);
      print("index === ${idx} == val ${sltdsrv.service_id} ${sltdsrv.category_id}");
      selectedServices[idx] =  SelectedService(sltdsrv.service_id, sltdsrv.category_id, int.parse(fieldValue));
    }
    else if((selectedListOfCategory.contains(onTapCategory))&& (!(selectedListOfService.contains(onTapService)))){
      SelectedService sltdsrv = selectedServices.firstWhere((element) => element.category_id == onTapCategory.id);
      setState(() {
        selectedListOfService.add(onTapService);

      });
      int idx = selectedServices.indexWhere((element) => element == sltdsrv);
      selectedServices[idx] =  SelectedService(onTapService.id, sltdsrv.category_id, int.parse(fieldValue));


    }
    else{
      setState(() {
        selectedListOfService.add(onTapService);
        selectedListOfCategory.add((onTapCategory));
        selectedServices.add(SelectedService(onTapService.id, onTapCategory.id, int.parse(fieldValue)));
      });

    }


  }

  void storeFormValue() {

    if (selectedListOfService.contains(onTapService)) {
       SelectedService sltdsrv = selectedServices.firstWhere((element) => element.service_id == onTapService.id);

       int idx = selectedServices.indexWhere((element) => element == sltdsrv);
       print("index === ${idx} == val ${sltdsrv.service_id}");

      selectedServices[idx] =  SelectedService(sltdsrv.service_id, 0, int.parse(fieldValue));
    }

    else {
      setState(() {
        selectedListOfService.add(onTapService);
        selectedServices.add(SelectedService(onTapService.id, 0 , int.parse(fieldValue)));
      });

    }
  }

  List<Service> listofServices;
  String serviceNamesString = "";

  void serviceSave() {
    setState(() {
      selectedServices.forEach((element) {
        print("elements ${element.toJson()}");
      });



        String rawJson = jsonEncode(selectedServices);
        print(rawJson);

     // }
    });

  }
  final prfl_servicePrice = TextEditingController();
}