import 'dart:ui';

import 'package:hexcolor/hexcolor.dart';

class Configurations {
  //URLS
  // droetker_staging / droetker

  static const String BASE_URL = "https://staging.jam-app.com";

  static const String APP_URL = "";
  static const String API_VERSION = "/api/v1";
//  static const String About_Account_URL = "https://mybms.in/a/droetker";
  static const String REGISTER_URL = BASE_URL + APP_URL + API_VERSION + "/register";
  static const String REGISTER_PROVIDER_URL = BASE_URL + APP_URL + API_VERSION + "/register_provider";
  static const String PROFILE_URL = BASE_URL + APP_URL + API_VERSION + "/init_profile";
  static const String LOGIN_URL = BASE_URL + APP_URL + API_VERSION + "/login";
  static const String BOOKING_URL = BASE_URL + APP_URL + API_VERSION + "/booking";
  static const String PROVIDER_BOOKING_URL = BASE_URL + APP_URL + API_VERSION + "/booking/provider";

  static const String PROVIDER_SERVICES_URL = BASE_URL + APP_URL + API_VERSION + "/providers/service";
  static const String SERVICES_ALL_URL = BASE_URL + APP_URL + API_VERSION +"/all_services";
  static const String BOOKING_RATING_URL = BASE_URL + APP_URL + API_VERSION +"/experience";
  static const String BOOKING_STATUS_URL = BASE_URL + APP_URL + API_VERSION +"/booking_status";


  static Color themColor = Hexcolor('#0ca798');
  //IN SECONDS
  static const int CHECK_INTERNET_TIMEOUT = 15;

  //No of SMS per API
  static const int NO_OF_SMS_PER_API = 100;

  //should print errors ?
  static const bool IS_ERROR_LOG_ENABLED = true;
}
