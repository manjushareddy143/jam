import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:jam/models/provider.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/models/user.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';

class InquiryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: InquiryPage(),
    );
  }
}

class InquiryPage extends StatefulWidget {

  final Service service;
  InquiryPage({Key key, @required this.service}) : super(key: key);
  @override
  _InquiryPageState createState() => _InquiryPageState(service: this.service);
}
class _InquiryPageState extends State<InquiryPage> {

  final Service service;
  _InquiryPageState({Key key, @required this.service});

  TextEditingController dateCtl = TextEditingController();
  final txtName = TextEditingController();
  final txtContact = TextEditingController();
  final txtEmail = TextEditingController();
  String firstName = "";
  String phoneNumber = "";
  String email = "";
  String user_id;

  DateTime _currentDt = new DateTime.now();

  bool isAC = false;
  String selectedService;
  List<DropdownMenuItem<String>> _dropDownService;
  List<Service> _lstServices = new List<Service>();
  List<SubCategory> _lstSubCategory = new List<SubCategory>();

  bool isAC1 = false;
  String selectedSubCategory;
  List<DropdownMenuItem<String>> _dropDownSubCategory;



  @override
  void initState() {
    super.initState();
    _lstServices.add(this.service);
    _lstSubCategory.addAll(this.service.categories);
    _dropDownService = buildServicesMenuItems(_lstServices);
    selectedService = _dropDownService[0].value;
    _dropDownSubCategory = buildSubCategoryDropDownMenuItems(_lstSubCategory);
    selectedSubCategory = _dropDownSubCategory[0].value;
    setProfile();
    print(this.service.name);
  }

  void setProfile() async  {
    await Preferences.readObject("user").then((onValue) async {
      var userdata = json.decode(onValue);
      printLog('userdata');
      printLog(userdata);
      User user = User.fromJson(userdata);
      user_id = user.id.toString();
      setState(() {
        firstName = user.first_name;
        phoneNumber = user.contact;
        email = user.email;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(leading: BackButton(color:Colors.black),title: Text("Inquiry Form", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),), backgroundColor: Colors.white,

        ),
      body: SingleChildScrollView(
        child: new Form(
          child: inquiryScreenUI(),
        ),
      ),
    );
  }

  Widget inquiryScreenUI() {
    return Container(margin: EdgeInsets.all(20),
    child:
    Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      setDropDown(),
      SizedBox(height: 10,),
      setDropDown1(),
      SizedBox(height: 10,),
      Material(elevation: 5.0,shadowColor: Colors.grey,
        child: TextFormField(
          decoration: InputDecoration( suffixIcon: Icon(Icons.person),

            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ),),
            labelText: 'First Name',),
          controller: (txtName == "") ? txtName : txtName..text = firstName,
          //txtName,//..text = 'KAR-MT30',
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter name!!';
            }
            return null;
          },
        ),
      ),


      SizedBox(height: 10,),
      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(
          decoration: InputDecoration( suffixIcon: Icon(Icons.email),
            contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: 'Email',),
          controller: (txtEmail == "") ? txtEmail : txtEmail..text = email,
          //txtEmail,//..text = 'KAR-MT30',
          keyboardType: TextInputType.emailAddress,
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter email!!';
            }
            return validateEmail(value);
          },
          onSaved: (String val) {
//            _account = val;
          },
        ),
      ),
      SizedBox(height: 10,),
      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(

          decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: 'Phone',),
          controller: (txtContact == "") ? txtContact : txtContact..text = phoneNumber,
          //txtContact,//..text = 'KAR-MT30',
          keyboardType: TextInputType.phone,
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter contact number!!';
            }
            return null;
          },
        ),
      ),


      SizedBox(height: 10,),
      setDate(),
      SizedBox(height: 10,),
      setTime(),
      SizedBox(height: 10,),

      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextField(
            maxLines: 7,
          decoration: InputDecoration(

            hintText: 'Remark', contentPadding: EdgeInsets.only(left:10,top: 5) ),
      ),),
      SizedBox(height: 30,),

      RaisedButton(

        color: Colors.teal,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(160,15,160,15),
//          color: MyColors.turquoise,
        onPressed: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
//                        fullscreenDialog: false,
          ));

        },
        child: const Text('Submit', style: TextStyle(fontSize: 15,color: Colors.white)),
      ),]
    ),
    );
  }
  Widget setDropDown() {
    return Material(elevation: 5.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,0,0,0),
        child: Row(
          children:[
            Text("Primary Service" , style: TextStyle(fontSize: 15 , color: Colors.black45)),
            SizedBox(width: 20,),
            Expanded(child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                value: selectedService,
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal,),
                items: _dropDownService,
                onChanged: changedDropDownItem),
            ),

          ],
        ),
      ),
    );
  }
  List<DropdownMenuItem<String>> buildServicesMenuItems(List<Service> serviceList) {
    List<DropdownMenuItem<String>> items = List();
    serviceList.forEach((val) {
      items.add(DropdownMenuItem(value: val.id.toString(), child: Text(val.name)));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      selectedService = selectedItem;
      print(selectedService);
      if(selectedItem == "") {
        isAC = true;
      } else {
        isAC = false;
      }
    });
  }


  Widget setDropDown1() {
    return Material(elevation: 5.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,0,0,0),
        child: Row(
          children:[
            Text("Secondary Service" , style: TextStyle(fontSize: 15 , color: Colors.black45)),
            SizedBox(width: 20,),
            Expanded(child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                value: selectedSubCategory.toLowerCase(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal,),
                items: _dropDownSubCategory,
                onChanged: changedDropDownItem1),
            ),

          ],
        ),
      ),
    );
  }
  List<DropdownMenuItem<String>> buildSubCategoryDropDownMenuItems(List<SubCategory> listSubCategory) {
    List<DropdownMenuItem<String>> items = List();
    listSubCategory.forEach((val) {
      items.add(DropdownMenuItem(value: val.id.toString(), child: Text(val.name)));
    });
    return items;
  }

  void changedDropDownItem1(String selectedItem) {
    setState(() {
      selectedSubCategory = selectedItem;
      print(selectedSubCategory);
      if(selectedItem == "") {
        isAC1 = true;
      } else {
        isAC1 = false;
      }
    });
  }



final format = DateFormat("dd-MM-yyyy");
final formatt= DateFormat("HH:mm");

  Widget setDate(){
    return Material(elevation: 10.0,shadowColor: Colors.grey,
        child: Container(

        padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: DateTimeField(
            initialValue: _currentDt,
            format: format,
            decoration: InputDecoration( suffixIcon: Icon(Icons.calendar_today),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
              labelText: 'Date',),
                 onShowPicker: (context, currentValue) {
                 return showDatePicker(
                  context: context,
                 firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
               lastDate: DateTime(2021));}
          ),
    ),);
  }
  Widget setTime(){
    return Container(padding: const EdgeInsets.fromLTRB(0,0,0,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          Flexible(
            flex: 5,
            child: Material(elevation: 10.0,shadowColor: Colors.grey,
              child: DateTimeField(
                initialValue: _currentDt,
                  format: formatt,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.timer),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                    ),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.convert(time);
                },
                onChanged: (val) => {
                  print(TimeOfDay.fromDateTime(val ?? DateTime.now()))
                },
              ),
            ),
          ),
          Flexible(flex: 2,child: Text("To")),
          Flexible(flex: 5,
            child: Material(elevation: 10.0,shadowColor: Colors.grey,
              child: DateTimeField(
                initialValue: _currentDt.add(Duration(hours: 1)),
                format: formatt,
                decoration: InputDecoration( suffixIcon: Icon(Icons.timer),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                ),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.convert(time);
                },
                onChanged: (val) => {
                  print(TimeOfDay.fromDateTime(val ?? DateTime.now()))
                },
              ),
            ),
          ),
       ]),
    );

  }
}

