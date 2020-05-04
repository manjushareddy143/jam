import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

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
      String apiUrl, Map data, List<http.MultipartFile> files) async {

    var body = json.encode(data);

    Map responseData = new HashMap();
    showLoading(context);
    printLog('start call === $apiUrl');
    bool isNetworkAvailable = await checkInternetConnection();

    if (isNetworkAvailable) {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields.addAll(data);

      if(files != null) {
        print('files');
        request.files.addAll(files);
      }

      var response = await request.send();
//      printLog(response.statusCode);
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
          await http.post(apiUrl, headers: headers, body: data);

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
    showLoading(context);

    printLog(apiUrl);

    bool isNetworkAvailable = await checkInternetConnection();
    if (isNetworkAvailable) {
      Map<String, String> headers = new Map();

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
    if (response.statusCode == 400) {
      printLog(response.statusCode);
      final respStr = await response.stream.bytesToString();
      print('ERROR === $respStr');
//      processLogout(context);
      //to indicate caller doesn't need to handle API response
      return null;
    }
    //success
    else if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      print('mydata === $respStr');
      print('mydata === ${response}');
      Map responseData = jsonDecode(respStr);
        return responseData;

    } else if (response.statusCode == 406) {
      final respStr = await response.stream.bytesToString();
      print('ERROR DATA === $respStr');
      String errorMsg  =  "";
      Map data = jsonDecode(respStr);
      data['error'].forEach((key, val){
        printLog(key);
        printLog(val[0]);
        errorMsg += " " + val[0];
      });

      showInfoAlert(context, errorMsg);
    }
    else {
      return null;
    }
  }

  http.Response  handleResponse(BuildContext context, http.Response response, bool hideLoad) {
    dismissLoading(context);
    printLog(response.statusCode);
    printLog(response.body);
    if (response.statusCode == 400) {
      return null;
    } else if (response.statusCode == 204) {
      return response;
    }
    else if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 406) {
      print('error');
      Map data = jsonDecode(response.body);
      String errorMsg  =  "";
      data['error'].forEach((key, val){
        printLog(key);
        printLog(val[0]);
        errorMsg += " " + val[0];
      });
      showInfoAlert(context, errorMsg);
    } else {
      //show error only if't is set to true
//      if (shouldShowError) {
//      var data = jsonDecode(response.body);


//      Map<String, dynamic> message =new HashMap<String, dynamic>();
//      message = data['error'];
//      print('error');
//      print(data['error']);

          showInfoAlert(context, 'Unknown error from server, code: ${response.statusCode}');


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
