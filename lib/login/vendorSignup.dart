import 'package:flutter/material.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/login/login.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/resources/configurations.dart';
class vendor extends StatelessWidget {

  Widget build(BuildContext context) {
    // TODO: implement build
    return VendorSignup();
  }
}
class VendorSignup extends StatefulWidget {
  //SignupPage({Key key, this.title}) : super(key: key);

  @override
  _vendorSignup createState() => _vendorSignup();
}
class _vendorSignup extends State<VendorSignup>{
  List<DropdownMenuItem<String>> _dropDownTypes;
  List _lstType = ["",
    "India"
    ,"Qatar"];
  String dropdownvalue;
  bool _value1 = false;
  void _value1Changed(bool value) => setState(() => _value1 = value);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    dropdownvalue = _dropDownTypes[0].value;
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key) {

      items.add(DropdownMenuItem(value:key , child: Text(key)
      ));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      dropdownvalue = selectedItem;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }




  final txtCompanyName=TextEditingController();
  final txtAdminName=TextEditingController();
  final txtContact=TextEditingController();
  final txtEmail=TextEditingController();
  final txtPass=TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      child: vendorScreenUI(),
    );
  }
  Widget vendorScreenUI(){
    return Container(margin: EdgeInsets.all(20),
    child: Column(children: <Widget>[
      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(


          decoration: InputDecoration( suffixIcon: Icon(Icons.place),
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
              labelText: "Company Name"
          ),
          controller: txtCompanyName,//..text = 'KAR-MT30',
          validator: (value){
            if (value.isEmpty) {
              return "Please enter the company name";
            }
            return null;
          },
          //..text = 'KAR-MT30',

        ),
      ),
      SizedBox(height: 10,),
      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(


          decoration: InputDecoration( suffixIcon: Icon(Icons.person),
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
              labelText: "Admin Name"
          ),
          controller: txtAdminName,//..text = 'KAR-MT30',
          validator: (value){
            if (value.isEmpty) {
              return "Please enter the admin name";
            }
            return null;
          },
          //..text = 'KAR-MT30',

        ),
      ),
      SizedBox(height: 10,),
      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(


          decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
              labelText: "Phone"),

          keyboardType: TextInputType.phone,
          controller: txtContact,//..text = 'KAR-MT30',

          validator: (value){
            if (value.isEmpty) {
              return "Please the enter phone number";
            }
            return null;
          },

        ),
      ),
      SizedBox(height: 10,),
    Material(elevation: 10.0,shadowColor: Colors.grey,
    child: TextFormField(


    decoration: InputDecoration( suffixIcon: Icon(Icons.email),
    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
    labelText: "Email Address"),

    controller: txtEmail,//..text = 'KAR-MT30',

    validator: (value){
    if (value.isEmpty) {
    return "Please the enter email address";
    }
    return validateEmail(value);
    },

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
    controller: txtPass,//..text = 'KAR-MT30',
    validator: (value){
    if (value.isEmpty) {
    return "Please enter your password";
    }
    return null;
    },
    ),
    ),
      SizedBox(height: 10,),
      setCountry(),
      SizedBox(height: 10,),
      Row(
          children: <Widget>[
            Checkbox(value: _value1, onChanged: _value1Changed),
            Text("Agree With ", style: TextStyle(color: Colors.grey),),
            InkWell(
              child: Text(
                AppLocalizations.of(context).translate('signin_txt_terms'),
                style: TextStyle(decoration: TextDecoration.underline, color: Colors.orangeAccent,)

              ),
              //onTap: _launchURL,
            ),
          ]
      ),
      //SizedBox(height: 10,),
            ButtonTheme(
              minWidth: 300.0,
              child:  RaisedButton(
                  color: Colors.teal,


                  textColor: Colors.white,
                  child:  Text(

                      AppLocalizations.of(context).translate('signin_btn_signup'),
                      style: TextStyle(fontSize: 16.5)
                  ),
                  onPressed: () {
                  //  _validateInputs();
                  }


              ),
            ),
      Container(child:  Row( mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Already have an account?"),

          FlatButton( onPressed:() {
            Navigator.push(
                context, new MaterialPageRoute(
              builder: (BuildContext context) => UserLogin(),
            )
            );
          },
            child: Text(
                AppLocalizations.of(context).translate('btn_login'),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent)
            ),
          )
        ],
      ),),






    ],),);
  }
  Widget setCountry(){
    return Material(elevation: 5.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,5,10,5),
        child: Row(
          children:[
            Text("Select Country", style:TextStyle(color: Colors.grey) ,),


            SizedBox(width: 20,),
            Expanded(child: DropdownButton(
              hint: Text('Select Country'),


                underline: SizedBox(),
                isExpanded: true,
                value: dropdownvalue,
                icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
                items: _dropDownTypes,
                onChanged: changedDropDownItem),
            ),

          ],
        ),
      ),
    );
  }
}