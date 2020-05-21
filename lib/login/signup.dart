import 'package:flutter/material.dart';
class Signup extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      child: signupScreenUI(),
    );
  }
  Widget signupScreenUI(){
    return Container(margin: EdgeInsets.all(20),
    child: Column( children: <Widget>[

      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(


          decoration: InputDecoration( suffixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: "First Name"
          ),
         //..text = 'KAR-MT30',

        ),
      ),
     SizedBox(height: 10,),


     Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(

          decoration: InputDecoration( suffixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: "Last Name"),

        ),
      ),
      SizedBox(height: 10,),


      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(


          decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: "Phone Number"),

          keyboardType: TextInputType.phone,

        ),
      ),
      SizedBox(height: 10,),

      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(

          obscureText: true,
          decoration: InputDecoration( suffixIcon: Icon(Icons.security),
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: "Password"),
         //..text = 'KAR-MT30',

        ),
      ),
      SizedBox(height: 10,),





      ButtonTheme(
        minWidth: 300.0,
        child:  RaisedButton(
          color: Colors.teal,


            textColor: Colors.white,
            child:  Text(

              "Sign Up",
                style: TextStyle(fontSize: 16.5)
            ),


        ),
      ),





    ],)
      ,);
  }
}