import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jam/login/signup.dart';
import 'package:jam/services.dart';
import 'package:jam/api/network.dart';
import 'package:jam/home_widget.dart';





class UserLogin extends StatefulWidget {

  _user createState() => new _user();
}


class _user extends State<UserLogin>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _primeKey = GlobalKey<State>();
  //const String loginURL ="";
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool _value1 = false;
  final txtUser = TextEditingController();
  final txtPass = TextEditingController();

  void _value1Changed(bool value) => setState(() => _value1 = value);

  /* authen() async {
   //MyNet network = MyNet('$loginURL');
    //var loginResponse = await network.getData();
   // print(loginResponse);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: Text("JAM"),
            content: new Text("hello"),
            actions: <Widget>[
              new FlatButton(color: Colors.teal,
                child: new Text("OK"), onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> CollapsingList()));
                },),
            ],);
        });
  } */



  @override
  Widget build(BuildContext context) {


    Paint paint = Paint();

    paint.color= Colors.teal;
    return  new Material( key: _primeKey,

        child:  new Form(
          key: _formKey,
          autovalidate: _autoValidate,
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
                      controller: txtUser
                      ,
                       validator: (value){
                         if (value.isEmpty) {
                           return 'Please enter username!!';
                         }
                         return validateEmail(value);
                       },

                       obscureText: false,
                       decoration: InputDecoration( suffixIcon: Icon(Icons.face),
                      border: OutlineInputBorder(),
                      labelText: 'Email or Username',
                    ),

                  ),
                       SizedBox(height: 20),
                     new TextFormField(
                       controller: txtPass,
                       validator: (value){
                         if (value.isEmpty) {
                           return 'Please enter password!!';
                         }
                         return null;
                       },

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
                  new  RaisedButton(
                    color: Colors.teal,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(150,10,150,10),
                     //invokes _authUser function which validate data entered as well does the api call
                    child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20)
                    ),
                    onPressed: () {

                      _validateInputs();

                    /*  if (txtUser.text.isEmpty || txtPass.text.isEmpty) {
                        showDialog(
                            context: context, builder: (BuildContext context) {
                          return AlertDialog(content: new Text(
                              "Please fill in the given feilds"),
                            actions: <Widget>[
                              new FlatButton(color: Colors.teal,
                                child: new Text("OK"), onPressed: () {
                                  Navigator.of(context).pop();
                                },),
                            ],);
                        });
                      }
                      else {
                        authen();
                      } */
                    }
















                  ),



















                  Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Create an account?"),

                      FlatButton( onPressed:(){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> SignUp()));},
                        child:
                        Text("Sign Up", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),)
                      // FlatButton(textColor: Colors.cyan, child:  Text('Forget Password?'),),
                    ],
                  ),),
                  SizedBox(height: 30,),
                  Text('Skip for Now',
                    textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),



             ]
            ),
          ),

              ));


  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then do API call
      _formKey.currentState.save();
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> Home()));
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}