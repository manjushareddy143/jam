//
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:jam/utils/utils.dart';
//import 'package:jam/widget/widget_helper.dart';
//
//
//class FullScreenDialog extends StatefulWidget {
//  @override
//  FullScreenDialogState createState() => new FullScreenDialogState();
//}
//
//class FullScreenDialogState extends State<FullScreenDialog> {
//  TextEditingController _skillOneController = new TextEditingController();
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  bool _autoValidate = false;
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          leading: IconButton(
//            icon: Icon(Icons.clear, color: Colors.white),
//            onPressed: () => Navigator.of(context).pop(),
//          ),
//          title: new Text("Enter OTP",),
//
//        ),
//        body: Form(
//          key: _formKey,
//            autovalidate: _autoValidate,
//            child: new Padding(child: new ListView(
//              children: <Widget>[
//                SizedBox(height: 30,),
//                TextFormField(
//                  controller: _skillOneController,
//                  validator: (value){
//                    if (value.isEmpty) {
//                      return 'Please enter OTP';
//                    }
//                    return null;
//                  },
//                  decoration: InputDecoration(
//                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 10),
//                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1,  ), ),
//                    labelText: 'OTP',),
//
//                ),
//                SizedBox(height: 20,),
//
//                Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text("Resend OTP"),
//                    IconButton(icon: Icon(Icons.refresh), onPressed: () {
//
//                    },
//                    ),
//
//                    // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
//                  ],
//
//                ),
//                ),
//                Row(
//                  children: <Widget>[
//
//                    new Expanded(child: new RaisedButton(
//                      onPressed: () {
//                        _validateInputs();
//                      }, child: new Text("Submit"),))
//                  ],
//                )
//              ],
//            ), padding: const EdgeInsets.symmetric(horizontal: 20.0),)
//        )
//    );
//  }
//  void _validateInputs() {
//    if (_formKey.currentState.validate()) {
//      _formKey.currentState.save();
//    } else {
//      setState(() {
//        _autoValidate = true;
//      });
//    }
//  }
//
//}
