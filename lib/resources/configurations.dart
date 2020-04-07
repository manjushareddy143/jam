class Configurations {
  //URLS
  // droetker_staging / droetker
  static const String BASE_URL = "https://mybms.in/";
  static const String ACCOUNT_URL = "a/droetker_staging/api/";
  static const String About_Account_URL = "https://mybms.in/a/droetker";
  static const String LOGIN_URL = BASE_URL + ACCOUNT_URL + "login";
  static const String DailyReportFormats_URL =  BASE_URL + ACCOUNT_URL + "dailyreportformats";
  static const String TeamInfo_URL =  BASE_URL + ACCOUNT_URL + "teaminfo";
  static const String SMS_LIST_URL = BASE_URL + ACCOUNT_URL + "messages";
  static const String Send_Report = BASE_URL + ACCOUNT_URL + "logcallsms";

  //IN SECONDS
  static const int CHECK_INTERNET_TIMEOUT = 15;

  //No of SMS per API
  static const int NO_OF_SMS_PER_API = 100;

  //should print errors ?
  static const bool IS_ERROR_LOG_ENABLED = true;
}
