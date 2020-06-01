// TODO Implement this library.

import 'package:flutter/cupertino.dart';
import 'package:jam/models/order.dart';
import 'package:jam/login/customerSignup.dart';
import 'package:jam/models/user.dart';
import 'package:jam/screens/home_screen.dart';

BuildContext context;
String orderStatus;
String fcmToken;
bool isCustomer = true;
Order order;
User currentUser;
bool isVendor = false;
