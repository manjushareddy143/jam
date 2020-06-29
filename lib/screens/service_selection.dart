import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/app_localizations.dart';
import 'package:tree_view/tree_view.dart';

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

  @override
  void initState(){


  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(

      appBar: new AppBar(
        title: new Text("Select Services"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            height: 400,
            child: Stack(
              children: <Widget>[
                TreeView(
                  hasScrollBar: true,
                  parentList: [
                    Parent(
                      parent: Container(
//                          margin: EdgeInsets.only(left: 4),
                        child: Card(elevation: 0.0,
                            child: ListTile( leading: Icon(Icons.navigate_next),
                                title:Text('Desktop'))),
                      ),
                      childList: ChildList(
                        children: <Widget>[
                          Parent(
                            parent: Container(
//                                margin: const EdgeInsets.only(left: 8.0),
                              child: Card(elevation: 0.0, child:
                              ListTile(leading:Icon(Icons.navigate_next),
                                  title:Text('Home')),),
                            ),
                            childList: ChildList(
                              children: <Widget>[

                                Container(
//                                    margin: const EdgeInsets.only(left: 12.0),
                                  child: Card(elevation: 0.0, child:
                                  ListTile(leading:Icon(Icons.insert_drive_file),
                                      title:Text('Resume.docx')),),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Text("data")
          
        ],
      ),
    );
  }
}