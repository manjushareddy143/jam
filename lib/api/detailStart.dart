//import 'package:flutter/material.dart';
//import 'package:jam/api/detail.dart';
//import 'package:jam/placeholder_widget.dart';
//import 'package:jam/services.dart';
//
//class HomeStart extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _HomeStart();
//  }
//}
//class _HomeStart extends State<HomeStart> {
//  int _currentIndex = 0;
//  final List<Widget> _children = [
//    HomeDesign(),
//    PlaceholderWidget(Colors.white),
//    PlaceholderWidget(Colors.deepOrange),
//    PlaceholderWidget(Colors.green)
//  ];
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.white70,
//        title:
//          Text('1100 +  AC Services',
//            textAlign: TextAlign.left,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.black,  ), ),
//      ),
//      body: DetailPage(),
//      //_children[_currentIndex],
//      bottomNavigationBar: BottomNavigationBar(
//
//        onTap: onTabTapped,// this will be set when a new tab is tapped
//        currentIndex: _currentIndex, // new
//        selectedItemColor: Colors.teal,
//        unselectedItemColor: Colors.grey,
//        backgroundColor: Colors.white,
//        iconSize: 30,
//        type: BottomNavigationBarType.fixed,
//
//        items: [ BottomNavigationBarItem(
//            icon: Icon(
//              Icons.home,),
//            title: new Text("Home")
//        ),
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.category,),
//              title: new Text("Categories")
//          ),
//          BottomNavigationBarItem(
//              icon: Icon(
//                  Icons.perm_identity),
//              title: new Text("My Account")
//          ),
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.train,),
//              title: new Text("Orders")
//
//          ),
//        ],
//      ),
//    );
//  }
//  void onTabTapped(int index) {
//    setState(() {
//      _currentIndex = index;
//    });
//  }
//}


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
as location_picker;
import 'package:google_map_location_picker/google_map_location_picker.dart';
//import 'package:google_map_location_picker_example/keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:jam/api/i18n.dart';
import 'package:jam/app_localizations.dart';

import 'package:jam/globals.dart' as globals;
import 'package:jam/screens/home_screen.dart';
import 'package:jam/utils/utils.dart';

class NewPage extends StatelessWidget {
  LocationResult _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Center(child: LocationPage());
  }
}

class LocationPage extends StatefulWidget {
  LocationPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LocationResult _pickedLocation;
  String address = "";
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;

  @override

  void initState() {
    super.initState();
    setCustomMapPin(pinLocationIcon).then((onValue) {
      pinLocationIcon = onValue;
    });
  }




  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(

    target: LatLng(globals.longitude, globals.latitude),
    zoom: 19.151926040649414
  );

//  static final CameraPosition _kLake = CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(37.43296265331129, -122.08832357078792),
//      tilt: 59.440717697143555,
//      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    String addressString = "";
    LatLng pinPosition = LatLng(globals.latitude, globals.longitude);

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation = CameraPosition(
        zoom: 16,
        bearing: 30,
        target: pinPosition
    );

    // TODO: implement build
    return Scaffold(
      body:
      GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
//        mapType: MapType.hybrid,
        markers: _markers,
        initialCameraPosition: initialLocation,
        
        onMapCreated: (GoogleMapController controller) {
          print("ADDDRESS::: ${controller}");
          _controller.complete(controller);


//          getAddress(globals.location);
          setState(() {
            _markers.add(
                Marker(
                    markerId: MarkerId("User"),
                    position: pinPosition,
                    icon: pinLocationIcon
                )
            );
          });
        },

        onTap: (latLogn) {

          print("latLogn::: $latLogn");
          setState(() {
            getAddress(LatLng(latLogn.latitude, latLogn.longitude)).then((onValue) {
              globals.newAddress = onValue;
              addressString = globals.newAddress.addressLine;
            });
            _markers.add(
                Marker(
                    markerId: MarkerId("User"),
                    position: latLogn,
                    icon: pinLocationIcon
                )
            );
          });
        },

      ),
     floatingActionButton: FloatingActionButton.extended(
       onPressed: (){
         setState(() {
           globals.addressChange = true;
         });
         print("before change");
         printLog(globals.addressLocation.addressLine.toString());


         print("change in address");
         printLog(globals.newAddress.addressLine.toString());
         Navigator.push(context,
             MaterialPageRoute(builder: (context) => HomeScreen()));
       }, //_goToTheLake,
       label: Text(AppLocalizations.of(globals.context)
           .translate('btn_save')),
       //icon: Icon(Icons.save),
       backgroundColor:Colors.teal,

     ),
    );



//          Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              RaisedButton(
//                onPressed: () async {
//                  LocationResult result = await  showLocationPicker(
//                    context,
//                    "AIzaSyCL5hZ74ZmuVnHlFMc6EWAYBQ8aDSsF4sU",
//                    initialCenter: LatLng(31.1975844, 29.9598339),
//                    resultCardAlignment: Alignment.bottomCenter,
////                    searchBarBoxDecoration: DecoratedBox(
////                      decoration: BoxDecoration(
////                        gradient: RadialGradient(
////                          center: const Alignment(-0.5, -0.6),
////                          radius: 0.15,
////                          colors: <Color>[
////                            const Color(0xFFEEEEEE),
////                            const Color(0xFF111133),
////                          ],
////                          stops: <double>[0.9, 1.0],
////                        ),
////                      ),
////                    )
////                    ,
////                    resultCardDecoration: BoxDecoration(
////                      color: Colors.red,
////                      image: DecorationImage(
////                        image: NetworkImage('https:///flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
////                        fit: BoxFit.cover,
////                      ),
////                      border: Border.all(
////                        color: Colors.black,
////                        width: 8,
////                      ),
////                      borderRadius: BorderRadius.circular(12),
////                    ),
//
////                    resultCardPadding: EdgeInsets.fromLTRB(800, 0, 0, 0),
////                    searchBarBoxDecoration: DecoratedBox(),
//                    requiredGPS: true,
//                    automaticallyAnimateToCurrentLocation: true,
////                    mapStylePath: 'assets/mapStyle.json',
//                    myLocationButtonEnabled: true,
//                    layersButtonEnabled: true,
////                    resultCardAlignment: Alignment.bottomCenter,
////                    searchBarBoxDecoration:
//                  );
//
//
////                      .then((onValue) {
////                    print("VALUE ________= $onValue");
////                  });
//                  print("result = ${result.latLng}");
////                  getAddress(result.latLng);
//                  getAddress(result.latLng).then((onValue) {
//                    setState(() => address = onValue);
//                  });
//
//                },
//                child: Text('Pick location'),
//              ),
//              Text(address),
//            ],
//          ),
//        );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

/*  Future<String> getAddress(LatLng latLng) async {

    final query = "1600 Amphiteatre Parkway, Mountain View";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");

    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    print("ADDDRESS::: ${first.featureName} : ${first.addressLine}");

    return first.addressLine;
  } */

}