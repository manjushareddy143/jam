import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:jam/api/i18n.dart';
//import 'package:jam/api/detail.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/invoice.dart';
import 'package:jam/models/order.dart';
import 'package:jam/models/service.dart';
import 'package:jam/screens/order_detail_screen.dart';
import 'package:jam/screens/customer_order_list.dart';
import 'package:jam/screens/splash_screen.dart';
import 'package:jam/services.dart';

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:jam/utils/preferences.dart';
//import 'package:jam/api/network.dart';
//import 'package:jam/utils/httpclient.dart';
//import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
import 'package:jam/api//i18n.dart' as location_picker;
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_geofence/geofence.dart';

main() {
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
//  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);

  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//  static int msgCount = 0;
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if(globals.msgCount%2==0) {
          Map data = message['data'];
          if(data.containsKey('status')) {
            printLog("COME FOR STAUTS");

            String msg = "";
            switch(message['data']['status']) {
              case "1" :
                msg = AppLocalizations.of(globals.context).translate('book_placed');
                break;
              case "2" :
                printLog("ACCEPT");
                msg = AppLocalizations.of(globals.context).translate('order_accept');
                break;
              case "3" :
                msg = AppLocalizations.of(globals.context).translate('order_cancel_vendor');
                break;
                case "4" :
                msg = AppLocalizations.of(globals.context).translate('order_cancel_user');
                break;
              case "5" :
                msg = AppLocalizations.of(globals.context).translate('order_complete');
                break;
              case "6" :
                msg = AppLocalizations.of(globals.context).translate('check_total_cost');
                break;
            }

            printLog("MSG == ${msg}");

            pushInfoAlert(globals.context, message['notification']['title'], msg);
          } else {
            pushInfoAlert(globals.context, message['notification']['title'], message['notification']['body']);
          }


          setState(() {
//            OrderDetail detail = new OrderDetail();
//            detail.build(globals.context);
//            Orders orderList = new Orders();
//            orderList.build(globals.context);

            if(data.containsKey('status')) {
              globals.orderStatus = message['data']['status'];
              if(globals.order == null) {
                  int idx = globals.listofOrders.indexWhere((element) => element.id == int.parse(message['data']['order']));
                  if(idx != null) {
                    globals.order = globals.listofOrders.firstWhere((element) => element.id == int.parse(message['data']['order']));
                    globals.order.status = int.parse(message['data']['status']);
                    if(globals.order.status.toString() == "6") {
                      var invoice = json.decode(message['data']['invoice']);
                      globals.order.invoice = Invoice(invoice['id'], invoice['additional_charges'], invoice['discount'], "", invoice['material_price'], invoice['material_quantity'], invoice['order_id'], invoice['tax'], invoice['working_hr'], 0);
                    }
                    //print("globals.order hours == ${globals.order.invoice.working_hr}");
                    globals.listofOrders[idx] = globals.order;
                  }




              } else
                {
                if(globals.order.id.toString() == message['data']['order']) {

                  globals.order.status = int.parse(message['data']['status']);
                  if(globals.order.status.toString() == "6") {
                    var invoice = json.decode(message['data']['invoice']);
                    globals.order.invoice = Invoice(invoice['id'], invoice['additional_charges'], invoice['discount'], "", invoice['material_price'], invoice['material_quantity'], invoice['order_id'], invoice['tax'], invoice['working_hr'], 0);
                  }
                  int idx = globals.listofOrders.indexWhere((element) => element.id == globals.order.id);
                  if(idx != null) {
                    globals.listofOrders[idx] = globals.order;
                  }
//                  print("globals.order.status ========= ${globals.order.status}");

                }
                else {
                  int idx = globals.listofOrders.indexWhere((element) => element.id == int.parse(message['data']['order']));
                  if(idx != null) {
                    globals.order = globals.listofOrders.firstWhere((element) => element.id == int.parse(message['data']['order']));
                    globals.order.status = int.parse(message['data']['status']);
                    globals.listofOrders[idx] = globals.order;
                  }
                }




              }

              
            } else {
              print("onlly order");
            }

          });
          // something else you wanna execute
        };
        globals.msgCount++;

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch 22: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
//      onBackgroundMessage:(Map<String, dynamic> message) async {
//        print("onBackground: $message");
//      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      Preferences.saveObject("fcm_token", token);
      globals.fcmToken = token;
      print("token: $token");
    });
  }


  void setLocale(Locale locale) {
      setState(() {
        printLog("*language locale set locale");
      _locale = locale;
      globals.localization = locale.toString();
    });
  }

  @override
  Widget build(BuildContext context)  {
    return
      MaterialApp(

      locale: _locale,
       localizationsDelegates:[
         location_picker.S.delegate,
         S.delegate,
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
           const Locale('en', 'US'), //English
           const Locale('ar', 'SA'), //Arabic
        ],
        localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            printLog("*language locale is null!!!");
            return supportedLocales.first;
          }

          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode ||
                supportedLocale.countryCode == locale.countryCode) {
              printLog("*language ok $supportedLocale");
              return supportedLocale;
            }
          }

          printLog("*language to fallback ${supportedLocales.first}");
          return supportedLocales.first;
        },

        home:   SplashScreen());
  }
}
