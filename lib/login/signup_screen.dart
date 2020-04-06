

import 'package:flutter/material.dart';
import 'package:jam/components/back_button_appbar.dart';
import 'package:jam/widget/widget_helper.dart';

enum GenderEnum {  Male, Female  }

class SignupScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SignupPage(title: "Sign up"),
    );
  }
}

class SignupPage extends StatefulWidget {

  SignupPage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isISP = false;
  String _type;
  List<DropdownMenuItem<String>> _dropDownTypes;
  Map<String, dynamic> _lstType = {"CSP" : "Corporate Service Provider", "ISP" : "Individual Service Provider"};


  String _gender = "Male";

  bool arabic = false;
  bool english = false;

  @override
  void initState() {
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    _type = _dropDownTypes[0].value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BackButtonAppBar(title: widget.title,),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        margin: const EdgeInsets.all(10.0),
        child: Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.grey)),
              child: new Form(
                key: _formKey,
                autovalidate: false,
                child: signupScreenUI(),
              ),
            )),
      ),
    );
  }


  Widget signupScreenUI() {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        // NORMAL
        Visibility(
          visible: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: "Name"),
                controller: TextEditingController(),//..text = 'KAR-MT30',
                validator: null,
                onSaved: (String val) {
//            _account = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "E-mail"),
                controller: TextEditingController(),//..text = 'KAR-MT30',
                validator: null,
                onSaved: (String val) {
//            _account = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Password"),
                controller: TextEditingController(),//..text = 'KAR-MT30',
                validator: null,
                onSaved: (String val) {
//            _account = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Confirm Password"),
                controller: TextEditingController(),//..text = 'KAR-MT30',
                validator: null,
                onSaved: (String val) {
//            _account = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Contact"),
                controller: TextEditingController(),//..text = 'KAR-MT30',
                validator: null,
                onSaved: (String val) {
//            _account = val;
                },
              ),
             // dropdown setup
              setDropDown(),

            ],
          ),
        ),

        // DETAILS
        Visibility(
        visible: isISP,
          child: Column(
            children: <Widget>[
              setRadio(),
              Text("data"),
              checkBox(arabic, "Arabic"),
              checkBox(english, "English"),

            ],
          )
        ),

        SizedBox(height: 10),

        RaisedButton(
          color: Colors.teal,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(100,10,100,10),
//          color: MyColors.turquoise,
          onPressed: () {
//            _validateInputs();
          },
          child: const Text('Signu Up', style: TextStyle(fontSize: 20,color: Colors.white)),
        ),
      ],
    );
  }

  Widget setDropDown() {
    return Container(
//      padding: const EdgeInsets.all(10),
      child: Row(
        children:[
          Text("Type" , style: TextStyle(fontSize: 17 , color: Colors.black45)),
          SizedBox(width: 50,),
          Expanded(child: DropdownButton(
              isExpanded: true,
              value: _type,
              items: _dropDownTypes,
              onChanged: changedDropDownItem),
          ),

        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(Map<String, dynamic> reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key, val) {
      items.add(DropdownMenuItem(value: key, child: Text(val)));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      _type = selectedItem;
      print(_type);
      if(selectedItem == "ISP") {
        isISP = true;
      } else {
        isISP = false;
      }
    });
  }


  Widget checkBox(bool val, String title) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
            Text(title),
              Checkbox(
                value: val,
                onChanged: (bool value) {
                  setState(() {
                    if(value == "Arabic") {
                      arabic = value;
                    }
                    if (value == "English") {
                      english = value;
                    }
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  GenderEnum _character = GenderEnum.Male;

  Widget setRadio() {
    return Container(
      child: Column(
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(value: GenderEnum.Male, groupValue: _character,
                  activeColor: Colors.tealAccent ,onChanged: (GenderEnum value) {
                setState(() {
                  _character = value;
                  print(value);
                  _gender = _character.toString().substring(11);
                });
              }),
              new Text("Male"),

              new Radio(value: GenderEnum.Female , groupValue: _character, activeColor: Colors.tealAccent , onChanged: (GenderEnum value) {
                setState(() {
                  _character = value;
                  print(value);
                  _gender = _character.toString().substring(11);
                });
              }),
              new Text("Female"),
            ],
          ),
        ],
      ),
    );
  }

}