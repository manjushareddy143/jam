import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart';
//import 'package:jam/api/detail.dart';
import 'package:jam/login/login.dart';
import 'package:jam/models/service.dart';
import 'package:jam/screens/splash_screen.dart';
import 'package:jam/services.dart';

import 'package:flutter/material.dart';
import 'package:jam/utils/preferences.dart';
//import 'package:jam/api/network.dart';
//import 'package:jam/utils/httpclient.dart';
//import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
main() {
  runApp(MyApp());
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  void setLocale(Locale locale) {
      setState(() {
        printLog("*language locale set locale");
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(

      locale: _locale,
       localizationsDelegates:[
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
