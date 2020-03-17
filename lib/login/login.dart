import 'package:flutter/material.dart';
import 'package:jam/services.dart';

class UserLogin extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);


  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color= Colors.greenAccent;
    return new Material(

          child: new SingleChildScrollView(
            child:Padding(
               padding: const EdgeInsets.fromLTRB(5,20,5,20),
                child: new Column(

               crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              
                  new Image.asset("assets/images/6745.jpg",
                    height: 250.0, width: double.infinity, fit: BoxFit.fill, ),
                  //Container(
                    //decoration: new BoxDecoration(
                     //image: new DecorationImage(
                    // image: new AssetImage("assets/images/6745.jpg"),
                     //fit: BoxFit.fill,     )
                      // )
                      //),
                   new Text(
                     'JAM    ',
                     textAlign: TextAlign.center,
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(fontWeight: FontWeight.bold,background: paint , color: Colors.white, fontSize: 40.0, ),
                   ),
                  new Text(
                    'LOGIN USER',
                    textAlign: TextAlign.center,

                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38.0,),
                  ),
                  new TextFormField(


                    obscureText: false,
                    decoration: InputDecoration( 
                      border: OutlineInputBorder(),
                      labelText: 'EMAIL',
                    ),
                  ),

                  new TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  new  RaisedButton(
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
                  )



             ]
            )
          )
          )
    );
  }

}