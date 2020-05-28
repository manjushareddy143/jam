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

class _vendorSignup extends State<VendorSignup> {
  List<DropdownMenuItem<String>> _dropDownTypes;
  List _lstType = ["", "India", "Qatar"];
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

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(
      List reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key) {
      items.add(DropdownMenuItem(value: key, child: Text(key)));
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

  final txtLname=TextEditingController();
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPass = TextEditingController();
  final txtConfPass = TextEditingController();
  final txtContact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      child: vendorScreenUI(),
    );
  }

  Widget vendorScreenUI() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 20, 5, 10),
      child: Column(
        children: <Widget>[
          Material(elevation: 10.0,shadowColor: Colors.grey,
            child: TextFormField(


              decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                  labelText: AppLocalizations.of(context).translate('signin_firstname_placeholder')
              ),
              controller: txtName,//..text = 'KAR-MT30',
              validator: (value){
                if (value.isEmpty) {
                  return AppLocalizations.of(context).translate('signup_txt_enteruser');
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
                  labelText: AppLocalizations.of(context).translate('signin_lastname_placeholder')),
              controller: txtLname,//..text = 'KAR-MT30',
              validator: (value){
                if (value.isEmpty) {
                  return AppLocalizations.of(context).translate('signup_txt_enterlast');
                }
                return null;
              },

            ),
          ),
          SizedBox(height: 10,),

          Material(elevation: 10.0,shadowColor: Colors.grey,
            child: TextFormField(


              decoration: InputDecoration( suffixIcon: Icon(Icons.person),
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                  labelText: AppLocalizations.of(context).translate('profile_email_placeholder')
              ),
              controller: txtEmail,//..text = 'KAR-MT30',
              validator: (value){
                if (value.isEmpty) {
                  return AppLocalizations.of(context).translate('profile_txt_enteremail');
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10,),

          Material(elevation: 10.0,shadowColor: Colors.grey,
            child: TextFormField(


              decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                  labelText: AppLocalizations.of(context).translate('signin_phone_placeholder')),

              keyboardType: TextInputType.phone,
              controller: txtContact,//..text = 'KAR-MT30',

              validator: (value){
                if (value.isEmpty) {
                  return AppLocalizations.of(context).translate('signup_txt_enterno');
                }
                return null;
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
                  labelText: AppLocalizations.of(context).translate('signin_pwd_placeholder')),
              controller: txtPass,//..text = 'KAR-MT30',
              validator: (value){
                if (value.isEmpty) {
                  return AppLocalizations.of(context).translate('signup_txt_enterpwd');
                }
                return null;
              },


            ),
          ),
          SizedBox(height: 10,),

          setCountry(),
          SizedBox(
            height: 10,
          ),
          Row(children: <Widget>[
            Checkbox(value: _value1, onChanged: _value1Changed),
            Text(
              "Agree With ",
              style: TextStyle(color: Colors.grey),
            ),
            InkWell(
              child: Text(
                  AppLocalizations.of(context).translate('signin_txt_terms'),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.orangeAccent,
                  )),
              //onTap: _launchURL,
            ),
          ]),
          //SizedBox(height: 10,),
          ButtonTheme(
            minWidth: 300.0,
            child: RaisedButton(
                color: Configurations.themColor,
                textColor: Colors.white,
                child: Text(
                    AppLocalizations.of(context).translate('signin_btn_signup'),
                    style: TextStyle(fontSize: 16.5)),
                onPressed: () {
                  //  _validateInputs();
                }),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Already have an account?"),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => UserLogin(),
                        ));
                  },
                  child: Text(
                      AppLocalizations.of(context).translate('btn_login'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget setCountry() {
    return Material(
      elevation: 5.0,
      shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: [
            Text(
              "Select Country",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: DropdownButton(
                  hint: Text('Select Country'),
                  underline: SizedBox(),
                  isExpanded: true,
                  value: dropdownvalue,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Configurations.themColor,
                  ),
                  items: _dropDownTypes,
                  onChanged: changedDropDownItem),
            ),
          ],
        ),
      ),
    );
  }
}
