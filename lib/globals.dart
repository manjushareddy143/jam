// TODO Implement this library.

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jam/models/order.dart';
import 'package:jam/login/customerSignup.dart';
import 'package:jam/models/user.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:geopoint/geopoint.dart';
import 'package:geopoint_location/geopoint_location.dart';

BuildContext context;
String orderStatus;
String fcmToken;
bool isCustomer = true;
Order order;
User currentUser;
double longitude;
double latitude;
//GeoPoint location;
dynamic addressLocation;

bool isVendor = false;
