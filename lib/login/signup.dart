

import 'package:flutter/material.dart';



class SignUp extends StatefulWidget {

  _Sign createState() => new _Sign();
}
class _Sign extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return new Material(

        child: new Form(


            child: SingleChildScrollView(
              child: new Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'REGISTER',
                      textAlign: TextAlign.center,

                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w400,
                        fontSize: 32.0,
                        color: Colors.teal, ),
                    ),

                    SizedBox(height: 40,),

                    Row(children: <Widget>[
                      Text("Name", style: TextStyle(fontWeight:FontWeight.w400, fontSize: 25,  ),),
                      //Spacer(),
                      TextField(controller: TextEditingController(),),
                    ],),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[
                      Text("Email", style: TextStyle(fontWeight:FontWeight.w400, fontSize: 25,  ),),
                      Spacer(),
                      Text("hello"),
                    ],),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[
                      Text("Password", style: TextStyle(fontWeight:FontWeight.w400, fontSize: 25,  ),),
                      Spacer(),
                      Text("hello"),
                    ],),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[
                      Text("Confirm Password", style: TextStyle(fontWeight:FontWeight.w400, fontSize: 25,  ),),
                      Spacer(),
                      Text("hello"),
                    ],),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[
                      Text("Contact", style: TextStyle(fontWeight:FontWeight.w400, fontSize: 25,  ),),
                      Spacer(),
                      Text("hello"),
                    ],),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[
                      Text("Type", style: TextStyle(fontWeight:FontWeight.w400, fontSize: 25,  ),),
                      Spacer(),
                      Text("hello"),
                    ],),
                    SizedBox(height: 10,),
              new  RaisedButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(150,10,150,10),
                  //invokes _authUser function which validate data entered as well does the api call
                  child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 20)
                  ),
                  onPressed: () {


                  },
              ),





                  ]),

            ),
        )
    );
  }
}