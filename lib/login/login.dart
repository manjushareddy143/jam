import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jam/services.dart';

class UserLogin extends StatefulWidget {

  _user createState() => new _user();
}


class _user extends State<UserLogin>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
   bool _value1 = false;

  void _value1Changed(bool value) => setState(() => _value1 = value);


  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color= Colors.teal;
    return new Material(

          child:  SingleChildScrollView(
            //child:Padding(

              // padding: const EdgeInsets.fromLTRB(5,20,5,20),
                child: new Column(

                 crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  new Image.asset("assets/images/BG-1x.jpg",
                    height: 250.0, width: double.infinity, fit: BoxFit.fill, ),
                  //Container(
                    //decoration: new BoxDecoration(
                     //image: new DecorationImage(
                    // image: new AssetImage("assets/images/6745.jpg"),
                     //fit: BoxFit.fill,     )
                      // )
                      //),
                  SizedBox(height: 30),
                  new Image.asset("assets/images/Logo-1x.png",
                    height: 40.0, width: 80.0 , fit: BoxFit.fill, ),
                   /*new Text(
                     'JAM    ',
                     textAlign: TextAlign.center,
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(fontWeight: FontWeight.bold,background: paint ,  color: Colors.white, fontSize: 40.0, ),
                   ), */
                  new Text(
                    'LOGIN USER',
                    textAlign: TextAlign.center,

                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 32.0,),
                  ),
                  SizedBox(height: 30),
                  
                  Container( padding: new  EdgeInsets.all(20),
                    child:
                   Column(children: <Widget>[

                    new TextFormField(


                    obscureText: false,
                       decoration: InputDecoration( suffixIcon: Icon(Icons.face),
                      border: OutlineInputBorder(),
                      labelText: 'Email or Username',
                    ),
                  ),
                    SizedBox(height: 20),
                     new TextField(
                    obscureText: true,
                    decoration: InputDecoration( suffixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  ],
                  ),
                  ),

                  Container( padding: new  EdgeInsets.fromLTRB(25,0,25,25), child:  Row(
                    children: <Widget>[
                      Checkbox(value: _value1, onChanged: _value1Changed),
                      Text("Remember", ),
                      Spacer(),
                      Text("Forget Password?",  style: TextStyle( color: Colors.teal),),
                     // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                    ],
                  ),),
                  SizedBox(height: 10),
                  new  FlatButton(
                    color: Colors.teal,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(150,10,150,10),
                    onPressed: () {

                      Navigator.push(
                           context,
                          MaterialPageRoute(
                            builder: (context) => CollapsingList(),

                          ));


                    },
                    child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                  Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),

                      Text("Sign In", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                      // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                    ],
                  ),),
                  SizedBox(height: 30,),
                  Text('Skip for Now',
                    textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),



             ]
            )
          )
          );

  }

}