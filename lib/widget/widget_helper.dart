

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// ignore: camel_case_types
class Widget_Helper {

  static String fieldName = "";
  static String fieldValue = "";


  static Map reportData = new Map<String, String>();


  static Widget txtDisplay(String txtData, TextStyle txtStyle, double paddingSpace) {
    return Container(
      padding: EdgeInsets.all(paddingSpace),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(txtData, style: txtStyle,)),
        ],
      ),
    );
  }


  static myStr(String str) {
    fieldValue = str;
    storeFormValue();
  }


  static void storeFormValue() {
    if(reportData.containsKey(fieldValue)) {
      reportData.update(fieldName, (value) => fieldValue);
    } else {
      reportData[fieldName] = fieldValue;
    }
  }

  static GlobalKey<State> _keyLoader = new GlobalKey<State>();

  static void dismissLoading(BuildContext context) {
      Navigator.of(context, rootNavigator: true).pop();
  }

  static void showLoading(BuildContext context) {

    //show loading view only if it is set to true
//    if (shouldShowLoading) {
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
//    }
  }

  static void getSelectedField(String fieldLbl) {
    fieldName = fieldLbl;
  }

  static Widget txtInputNoHint(String countText, var textNameController,
      int maxFieldLength, TextInputType inputKeyboardType, String Key, String isRequired) {

    return Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
//            Text(countText),
            Expanded(child: Text(countText)),
            Expanded(child: TextFormField(
              onTap: () => getSelectedField(Key),
              maxLength: maxFieldLength,
              textAlign: TextAlign.right,
              keyboardType: inputKeyboardType, //TextInputType.number,
              decoration: InputDecoration(
                // hintText: "0",
              ),
              validator: (value) {
                if(isRequired== '1') {
                  if (value.isEmpty) {
                    return 'Please enter value for $Key';
                  }
                  return null;
                } else {
                  return null;
                }
              },
              controller: textNameController,
              onSaved: (String value) {
                print('msg: $value');
              },
              onChanged: myStr,
//              onEditingComplete: () => {
//                print(textNameController.text),
//              },
            )),

            Padding(
              padding: EdgeInsets.all(8.0),
            ),
          ],
        )
    );
  }

  static validatorMethod(String val) {
//    printLog('msg: $val');
    return val.length < 6 ?
    'Still too short' : null;
  }

  static Widget gridMenus(BuildContext context, String lableName,String menuImage, Widget Function() screen) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => screen(),
                  ));
            },
            padding: EdgeInsets.all(0.0),
            child: new Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(menuImage),
                    )
                )),
          ),
          SizedBox(height: 10),
          Text(lableName, textAlign: TextAlign.center,)
        ],
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: Color(0xFFFF000000)),
          left: BorderSide(width: 0.5, color: Color(0xFFFF000000)),
          right: BorderSide(width: 0.5, color: Color(0xFFFF000000)),
          bottom: BorderSide(width: 0.5, color: Color(0xFFFF000000)),
        ),
      ),
    );
  }

  /*
   static Widget txtInput(String countText, var textNameController,
      String defaultValue, int maxFieldLength,
      TextInputType inputKeyboardType) {
    return Container(
        //padding: EdgeInsets.all(2),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(countText)),
            Expanded(child: TextFormField(
              maxLength: maxFieldLength,
              keyboardType: inputKeyboardType,
              textAlign: TextAlign.right,
              controller: textNameController,
              decoration: InputDecoration(
                hintText: defaultValue,
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
              validator: (val) =>
              val.length < 6 ?
              'Still too short' : null,
              onSaved: (String value) {
                printLog('msg: $value');
              },
            )),
          ],
        )
    );
  }
   */
}
