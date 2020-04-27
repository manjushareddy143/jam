import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:pulse/resources/my_colors.dart';
//import 'package:pulse/resources/my_strings.dart';
import 'package:jam/utils/utils.dart';

class HttpClient {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  //default is true
  //true->it will show info alert if API gives error like wrong username,password,etc
  //false->it will not show any alert to user even if their are erros
  bool shouldShowError;

  //default is true
  //true->it will show loading view until API response comes
  //false->it will show loading view
  bool shouldShowLoading;



  HttpClient({bool shouldShowError = true, bool shouldShowLoading = true}) {
    this.shouldShowError = shouldShowError;
    this.shouldShowLoading = shouldShowLoading;
  }

  Future<Map> postMultipartRequest(BuildContext context,
      String apiUrl, Map data) async {
    Map responseData = new HashMap();
    showLoading(context);
    printLog('start call');
    bool isNetworkAvailable = await checkInternetConnection();

    if (isNetworkAvailable) {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields.addAll(data);
      var response = await request.send();
      printLog(response.statusCode);
      responseData = await handleMultipartResponse(context, response);
      return responseData;
    } else {
      handleNoInternet(context);
      responseData['code'] = "12163";
      //to indicate caller don't need to handle the API response
      return responseData;
  }

  }

  Future<http.Response> postRequest(
      BuildContext context, String apiUrl, Map data) async {
    showLoading(context);
    bool isNetworkAvailable = await checkInternetConnection();

    if (isNetworkAvailable) {
      Map<String, String> headers = new Map();

      var body = json.encode(data);

//      headers["Content-Type"] = "application/json";
//      headers["Authorization"] = 'Basic';
      print(apiUrl + " 123");

      http.Response response =
          await http.post(apiUrl, headers: headers, body: body);

      response = handleResponse(context, response, true);

      return response;
    } else {
      handleNoInternet(context);
      //to indicate caller don't need to handle the API response
      return null;
    }
  }

  Future<http.Response> getRequest(
      BuildContext context, String apiUrl, Map<String, String> data,
      String token, bool showLoad, bool hideLoad) async {
    //String apiUrl = baseUrl + "${url}";
//    print('showLoad: $showLoad');
    showLoading(context);

    printLog(apiUrl);

    bool isNetworkAvailable = await checkInternetConnection();
    if (isNetworkAvailable) {
      Map<String, String> headers = new Map();

//      String params = "";

//      if (data != null) {
//        apiUrl += "?";
//        data.forEach((k, v) {
//          params = params + k + "=" + v + "&";
//        });
//        if (params.length > 0) {
//          params = params.substring(0, params.length - 1);
//        }
//      }
//
//      apiUrl += params;

      printLog(apiUrl);

//      headers["Content-Type"] = "application/json";
      //headers["Authorization"] = "Bearer ${token}";
//      headers["Authorization"] = "$token"; //"Basic";

      http.Response response = await http.get(apiUrl);

      response = handleResponse(context, response, hideLoad);

      return response;
    } else {
      handleNoInternet(context);
      //to indicate caller don't need to handle the API response
      return null;
    }
  }

  Future<Map> handleMultipartResponse(BuildContext context, dynamic response) async {
    print(response.statusCode);
    dismissLoading(context);
    if (response.statusCode == 400 || response.statusCode == 406) {
      printLog(response.statusCode);
//      processLogout(context);
      //to indicate caller doesn't need to handle API response
      return null;
    }
    //success
    else if (response.statusCode == 200) {
      print('200 ok');
      final respStr = await response.stream.bytesToString();
      print('mydata === $respStr');
      Map responseData = jsonDecode(respStr);
      if(responseData['code'] ==  "200") {
        return responseData;
      } else {
        showInfoAlert(context, responseData['message']);
        return null;
      }
    } else {
      String message = response.statusCode.toString();
      showInfoAlert(context, message);
      return null;
    }
  }

//handle POST and GET response
  //null will be return in case of error,so caller will not process the response, it will be handled here it self by showing alert or logging out
  http.Response  handleResponse(BuildContext context, http.Response response, bool hideLoad) {
//    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    printLog("Response : $response");

      dismissLoading(context);

    printLog(response.statusCode);
    printLog(response.body);

    //handle token expire and logout the user (400 and 406 indicates expired tokens)
    if (response.statusCode == 400 || response.statusCode == 406) {



      showInfoAlert(context, response.body);
//      processLogout(context);
      //to indicate caller doesn't need to handle API response
      return null;
    } else if (response.statusCode == 200) {
      print('200 ok');
      return response;
    } else {
      //show error only if't is set to true
//      if (shouldShowError) {
      var data = jsonDecode(response.body);

//      Map<String, dynamic> message =new HashMap<String, dynamic>();
//      message = data['error'];
      print('error');
      print(data['error']);

//          showInfoAlert(context, message[0]);


//      }
      //to indicate caller doesn't need to handle API response
      return null;
    }
  }

  //show loading view
  void showLoading(BuildContext context) {
    //show loading view only if it is set to true
    if (shouldShowLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            key: _keyLoader,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: EdgeInsets.all(16.0),
                    child: new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.tealAccent),
                    )),
                new Text("Please wait"),
              ],
            ),
          );
        },
      );
    }
  }

  //close loading view
  void dismissLoading(BuildContext context) {
    if (shouldShowLoading) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  //internet is not available
  void handleNoInternet(BuildContext context) {
    //we show loading before checking the internet connection, so close this if we don't have internet
    dismissLoading(context);
    if (shouldShowError) {
      showInfoAlert(context, "No Internet");
    }
  }
}
