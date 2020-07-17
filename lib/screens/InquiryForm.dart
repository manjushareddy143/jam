import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:jam/models/provider.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/models/user.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/screens/home_screen.dart';
import 'package:jam/utils/httpclient.dart';
import 'package:jam/utils/preferences.dart';
import 'package:jam/utils/utils.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/app_localizations.dart';

//class InquiryScreen extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      body: InquiryPage(),
//    );
//  }
//}

class InquiryPage extends StatefulWidget {

  final Service service;
  final User provider;
  final SubCategory category;
  InquiryPage({Key key, @required this.service, @required this.provider,
    @required this.category}) : super(key: key);
  @override
  _InquiryPageState createState() => _InquiryPageState(service: this.service,
      provider: this.provider, category: this.category);
}

class _InquiryPageState extends State<InquiryPage> {

  final Service service;
  final User provider;
  final SubCategory category;
  _InquiryPageState({Key key, @required this.service, @required this.provider,
    @required this.category});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
//   bool subCategory ;
  final txtName = TextEditingController();
  final txtContact = TextEditingController();
  final txtEmail = TextEditingController();
  final txtRemark = TextEditingController();
  String firstName = "";
  String phoneNumber = "";
  String email = "";
  String user_id;
  DateTime selecteDate;
  DateTime start_time;
  DateTime end_time;

  DateTime _currentDt = new DateTime.now();

  String selectedService;
  List<DropdownMenuItem<String>> _dropDownService;
  List<Service> _lstServices = new List<Service>();

  List<SubCategory> _lstSubCategory = new List<SubCategory>();

  String selectedSubCategory = "";
  List<DropdownMenuItem<String>> _dropDownSubCategory;
  FocusNode focus_name,focus_mail,focus_no,  focus_remark;



  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focus_name.dispose();
    focus_mail.dispose();
    focus_no.dispose();

    focus_remark.dispose();

    super.dispose();
  }



  @override
  void initState() {

    print("DATA === ${this.category}");

    super.initState();
    globals.context = context;
    focus_name = FocusNode();
    focus_mail = FocusNode();
    focus_no = FocusNode();
    print("DATA === ${this.service}");
    focus_remark = FocusNode();
    _lstServices.add(this.service);
    if(this.category != null){
      _lstSubCategory.add(this.category);
    }
//    print("DATA === ${_lstSubCategory}");
    _dropDownService = buildServicesMenuItems(_lstServices);
    selectedService = _dropDownService[0].value;
    if(_lstSubCategory.length > 0){
      _dropDownSubCategory = buildSubCategoryDropDownMenuItems(_lstSubCategory);
      selectedSubCategory = _dropDownSubCategory[0].value;
    }

    setProfile();
    print(this.service.name);
    selecteDate = _currentDt;//format.format(_currentDt);
    start_time = _currentDt; //formatt.format(_currentDt); //TimeOfDay.fromDateTime(val ?? DateTime.now()).toString()
    end_time =_currentDt.add(Duration(hours: 1)); //formatt.format(_currentDt.add(Duration(hours: 1)));//TimeOfDay.fromDateTime(val ?? DateTime.now()).toString()
  }

  void setProfile() async  {
    setState(() {
      firstName = globals.currentUser.first_name;
      phoneNumber = globals.currentUser.contact;
      email = globals.currentUser.email;
      user_id = globals.currentUser.id.toString();
    });
//    await Preferences.readObject("user").then((onValue) async {
//      var userdata = json.decode(onValue);
//      printLog('userdata');
//      printLog(userdata);
//      User user = User.fromJson(userdata);
//      user_id = user.id.toString();
//      setState(() {
//        firstName = user.first_name;
//        phoneNumber = user.contact;
//        email = user.email;
//      });
//    });
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
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },

      child: Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.black),title: Text("Inquiry Form", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),), backgroundColor: Colors.white,

          ),
        body: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            child: inquiryScreenUI(),
            autovalidate: _autoValidate,
          ),
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

      Visibility(visible: (this.category != null),
          child: setDropDown1()),
      SizedBox(height: 10,),

      Material(elevation: 5.0,shadowColor: Colors.grey,
        child: TextFormField(
          focusNode: focus_name,
          decoration: InputDecoration( suffixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ),),
            labelText: AppLocalizations.of(context).translate('inquiry_txt_firstname')),
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

      Material(elevation: 5.0,shadowColor: Colors.grey,
        child: TextFormField(
          focusNode: focus_mail,
          decoration: InputDecoration( suffixIcon: Icon(Icons.email),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: AppLocalizations.of(context).translate('inquiry_txt_email')),
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

      Material(elevation: 5.0,shadowColor: Colors.grey,
        child: TextFormField(
          focusNode: focus_no,

          decoration: InputDecoration( suffixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: AppLocalizations.of(context).translate('inquiry_txt_phone')),
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

      Material(elevation: 5.0,shadowColor: Colors.grey,
        child: TextField(
          focusNode: focus_remark,
          controller: txtRemark,
            maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('inquiry_txt_remark'),
              contentPadding: EdgeInsets.only(left:10,top: 15, right: 10) ),
      ),),
      SizedBox(height: 30,),

      ButtonTheme(
        minWidth: 400.0,
        child:  RaisedButton(
            color: Configurations.themColor,
            textColor: Colors.white,
            child:  Text(
                AppLocalizations.of(context).translate('inquiry_btn_booking'),
                style: TextStyle(fontSize: 16.5)
            ),
            onPressed: () {
              validateForm();
            }
        ),
      ),
    ]
    ),
    );
  }

  void validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _autoValidate = false;
      print(provider);
      setState(() {
        Map<String, String> data = new Map();
        data["user_id"] = user_id;
        data["service_id"] = selectedService;
        data["category_id"] = selectedSubCategory;
        data["orderer_name"] = txtName.text;
        data["email"] = txtEmail.text;
        data["booking_date"] = format.format(selecteDate);
        data["contact"] = txtContact.text;
        data["start_time"] = formatt.format(start_time);
        data["end_time"] = formatt.format(end_time);
        data["provider_id"] = provider.id.toString();
        data["remark"] = txtRemark.text;
        print(data);
        apiCall(data);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void apiCall(Map<String, String> data) async {
    try {
      HttpClient httpClient = new HttpClient();
      print('api call start signup');
      var syncOrderResponse =
          await httpClient.postRequest(context, Configurations.BOOKING_URL, data, true);
      processOrderResponse(syncOrderResponse);
    } on Exception catch (e) {
      if (e is Exception) {
        printExceptionLog(e);
      }
    }
  }

  void processOrderResponse(Response res) {
    print("come for response");
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print(data);
        Navigator.pop(context);
      } else {
        printLog("login response code is not 200");
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }

  Widget setDropDown() {
    return Material(elevation: 5.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,0,0,0),
        child: Row(
          children:[
            Text(AppLocalizations.of(context).translate('inquiry_txt_primary') , style: TextStyle(fontSize: 15 , color: Colors.black45)),
            SizedBox(width: 20,),
            Expanded(child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                value: selectedService,
                icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
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
    });
  }


  Widget setDropDown1() {
    print(selectedSubCategory);
    return Material(elevation: 5.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,0,0,0),
        child: Row(
          children:[
            Text(AppLocalizations.of(context).translate('inquiry_txt_secondary') , style: TextStyle(fontSize: 15 , color: Colors.black45)),
            SizedBox(width: 20,),
            Expanded(child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                value: (selectedSubCategory != null) ? selectedSubCategory.toUpperCase() : "",
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
    });
  }

final format = DateFormat("dd-MM-yyyy");
final formatt= DateFormat("h:mm a");



  Widget setDate(){
    return Material(elevation: 5.0,shadowColor: Colors.grey,
        child: Container(
        padding: EdgeInsets.fromLTRB(0,0,0,0),
          height: 50,
          child: DateTimeField(

            initialValue: _currentDt,
            format: format,
            decoration: InputDecoration( suffixIcon: Icon(Icons.calendar_today),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
              labelText: AppLocalizations.of(context).translate('inquiry_txt_date')),
                 onShowPicker: (context, currentValue) {
                 return showDatePicker(
                  context: context,
                 firstDate: _currentDt.add(Duration(days: -365)),
              initialDate: currentValue ?? DateTime.now(),
               lastDate: DateTime(2021)
                 );
            },
            onChanged: (val) => {
              selecteDate = val
            },

          ),
    ),);
  }

  Widget setTime(){
    return Container(padding:
    EdgeInsets.fromLTRB(0,0,0,0),
      child: Container(
//        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Material(elevation: 5.0,shadowColor: Colors.grey,
                child: DateTimeField(

                  initialValue: _currentDt,
                  format: formatt,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.timer),
                    hasFloatingPlaceholder: false,
//                    errorStyle: TextStyle(
//                      color: Colors.red,
//                      wordSpacing: 5.0,
//                    ),
//                    labelStyle: TextStyle(
//                        color: Colors.green,
//                        letterSpacing: 1.3
//                    ),
//                    hintStyle: TextStyle(
//                        letterSpacing: 1.3
//                    ),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                     // initialTime: TimeOfDay(hour: 12, minute: 00),
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),

                    );
                    return DateTimeField.convert(time);



                  },

                  onChanged: (val) => {
                    printLog(val),
                    start_time = val// TimeOfDay.fromDateTime(val ?? DateTime.now()).toString(),
                  },
                  validator:  (value){
                    if (value.isAfter(end_time)) {
                      return AppLocalizations.of(context).translate('inquiry_time');
                    }
                    return null;
                  },

                ),
              ),
            ),
            Flexible(flex: 1,child: Text("To")),
            Flexible(flex: 4,
              child: Material(elevation: 5.0,shadowColor: Colors.grey,
                child: DateTimeField(
                  initialValue: _currentDt.add(Duration(hours: 1)),
                  format: formatt,
                  decoration: InputDecoration( suffixIcon: Icon(Icons.timer),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
                  ),
                  onShowPicker: (context, currentValue) async {

                    final time = await showTimePicker(
                      context: context,
                      //initialTime: TimeOfDay(hour: 12, minute: 00),
                     initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);

                      //DateTimeField.convert(time);
                  },
                  onChanged: (val) => {
                    end_time = val //TimeOfDay.fromDateTime(val ?? DateTime.now()).toString()
//                    print(TimeOfDay.fromDateTime(val ?? DateTime.now()))
                  },
                  validator:  (value){
                    if (value.isBefore(start_time)) {
                      return 'Invalid time!!';
                    }
                    return null;
                  },
                ),
              ),
            ),

          ],
        ),
      )
    );

  }
}

