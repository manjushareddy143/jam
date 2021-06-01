import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:jam/models/address.dart';
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
  final txtService =TextEditingController();
  final txtSubCategory =TextEditingController();
  final txtPrice = TextEditingController();
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
  String selectedAddress;
  List<DropdownMenuItem<String>> _dropDownService;

  List<Service> _lstServices = new List<Service>();
  List<Address> _lstAddress = new List<Address>();
  List<DropdownMenuItem<String>> _dropDownAddress;

  List<SubCategory> _lstSubCategory = new List<SubCategory>();

  String selectedSubCategory = "";
  List<DropdownMenuItem<String>> _dropDownSubCategory;
  FocusNode focus_name,focus_mail,focus_no,  focus_remark, focus_service;



  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focus_name.dispose();
    focus_mail.dispose();
    focus_no.dispose();
    focus_service.dispose();

    focus_remark.dispose();

    super.dispose();
  }



  @override
  void initState() {
    super.initState();
    focus_name = FocusNode();
    focus_mail = FocusNode();
    focus_no = FocusNode();
    focus_remark = FocusNode();
    focus_service = FocusNode();
    _lstServices.add(this.service);

    if(this.category != null){
      _lstSubCategory.add(this.category);
    }
    print("DATA === ${globals.guest}");
   // print("Price====${provider.price}");

    if(globals.guest == false) {

      if(globals.currentUser.address != null)
        if(globals.currentUser.address.length > 0) {
          _lstAddress= globals.currentUser.address;
          _dropDownAddress = buildAddressMenuItems(_lstAddress);
          selectedAddress =_dropDownAddress[0].value;
        } else {
          selectedAddress = "Please Add Address";
        }

    } else{

    }


    _dropDownService = buildServicesMenuItems(_lstServices);
    selectedService = _dropDownService[0].value;
    if(_lstSubCategory.length > 0){

      _dropDownSubCategory = buildSubCategoryDropDownMenuItems(_lstSubCategory);
      // printLog("msg -- ${_dropDownSubCategory[0]}");
      selectedSubCategory = _dropDownSubCategory[0].value;

    }

    setProfile();
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
      return AppLocalizations.of(context).translate('login_txt_validuser');
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    globals.context = context;
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },

      child: Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.white),title: Text(AppLocalizations.of(context).translate('bookcaps'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),), backgroundColor: Configurations.themColor,

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
  AssetImage setImgPlaceholder() {
    return AssetImage("assets/images/BG-1x.jpg");
  }

  Widget inquiryScreenUI() {
    String img = "";
    if( (this.provider.image != null && this.provider.image.contains("http"))) {
      img = this.provider.image;
    } else if(this.provider.image == null) {
      img = null;
    } else {
      img =  Configurations.BASE_URL + this.provider.image;
    }
    if(this.provider.organisation != null) {
      img = (this.provider.organisation.logo != null && this.provider.organisation.logo.contains("http"))
          ? this.provider.organisation.logo : Configurations.BASE_URL +this.provider.organisation.logo;
    }
    String name = "";
    if(this.provider.organisation != null) {
      name = this.provider.organisation.name;
    } else {
      name = this.provider.first_name + " " + this.provider.last_name;
    }

    String prime_service = "";
    String prime_category = "";
    // printLog("this.service ${this.category}");
    if(globals.localization == 'ar_SA') {
      prime_service = this.service.arabic_name;
      if(this.category != null) {
        prime_category = this.category.arabic_name;
      }

    } else {
      prime_service = this.service.name;
      if(this.category != null) {
        prime_category = this.category.name;
      }

    }


    
    
    // printLog("service=  ${this.category}");
    if(phoneNumber == null || phoneNumber == "") {
      phoneNumber = '+974';
    }



    return Container(margin: EdgeInsets.all(20),
    child:
    Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Center(
        child: Container(
          width: 75,
          height: 67,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8.0),),

                //  border: Border.all(width: 0.9,color: Configurations.themColor),

              image: new DecorationImage(
                image: (img != null)?
                NetworkImage(img) : setImgPlaceholder(),
                fit: BoxFit.cover,
              )),
        ),
      ),
      SizedBox(height: 10,),
      Center(
        child: Text(name,
          textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
          style: TextStyle( fontSize: 17.0,fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
      ),
      SizedBox(height: 15,),

//      setDropDown(),
//      SizedBox(height: 10,),
      TextFormField(
        readOnly: true,
        focusNode: focus_service,
        decoration: InputDecoration( suffixIcon: Icon(Icons.work, color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor,
            width: 1,  ),),
          labelText: AppLocalizations.of(context).translate('primary'), labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Configurations.themColor),
          ),),cursorColor: Configurations.themColor,
        controller: txtService..text = prime_service,
        enabled: false,


        //txtName,//..text = 'KAR-MT30',
//        validator: (value){
//          if (value.isEmpty) {
//            return AppLocalizations.of(context).translate('signup_txt_enteruser');
//          }
//          return null;
//        },
      ),
//      Text(AppLocalizations.of(context).translate('inquiry_txt_primary') ,
//          style: TextStyle(fontSize: 15 , color: Colors.black45)),
//      Text(selectedService ,
//          style: TextStyle(fontSize: 15 , color: Colors.black45)),

      SizedBox(height: 10,),

      Visibility(visible: (this.category != null),
          child: setDropDown1()),

      SizedBox(height: 10,),
      TextFormField(
        readOnly: true,
        //focusNode: focus_service,
        decoration: InputDecoration( suffixIcon: Icon(Icons.work, color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor,
            width: 1,  ),),
          labelText: AppLocalizations.of(context).translate('price_txt'), labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Configurations.themColor),
          ),),cursorColor: Configurations.themColor,
        controller: txtPrice..text = provider.price,
        enabled: false,



      ),
      SizedBox(height: 10,),

      TextFormField(
        focusNode: focus_name,
        decoration: InputDecoration( suffixIcon: Icon(Icons.person, color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor, width: 1,  ),),
          labelText: AppLocalizations.of(context).translate('inquiry_txt_firstname'), labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Configurations.themColor),
          ),),cursorColor: Configurations.themColor,
        controller: (txtName == "") ? txtName : txtName..text = firstName,
        //txtName,//..text = 'KAR-MT30',
        validator: (value){
          if (value.isEmpty) {
            return AppLocalizations.of(context).translate('signup_txt_enteruser');
          }
          return null;
        },
        onChanged: (value){
          printLog("change value ::: $value");
            firstName = value;
        },
      ),
      SizedBox(height: 10,),

      TextFormField(
        focusNode: focus_mail,
        decoration: InputDecoration( suffixIcon: Icon(Icons.email, color:Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor, width: 1,  ), ),
          labelText: AppLocalizations.of(context).translate('inquiry_txt_email'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Configurations.themColor),
          ),),cursorColor: Configurations.themColor,
        controller: (txtEmail == "") ? txtEmail : txtEmail..text = email,
        //txtEmail,//..text = 'KAR-MT30',
        keyboardType: TextInputType.emailAddress,
        validator: (value){
          if (value.isEmpty) {
            return AppLocalizations.of(context).translate('signup_txt_enteremail');
          }
          return validateEmail(value);
        },
        onSaved: (String val) {
//            _account = val;
        },
      ),
      SizedBox(height: 10,),

      TextFormField(
        focusNode: focus_no,

        decoration: InputDecoration( suffixIcon: Icon(Icons.phone, color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor, width: 1,  ), ),
          labelText: AppLocalizations.of(context).translate('inquiry_txt_phone'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Configurations.themColor),
          ),),cursorColor: Configurations.themColor,
        controller: (txtContact == "") ? txtContact : txtContact..text = phoneNumber,
        //txtContact,//..text = 'KAR-MT30',
        keyboardType: TextInputType.phone,
        validator: (value){
          if (value.isEmpty) {
            return AppLocalizations.of(context).translate('signup_txt_enterno');
          }
          return null;
        },
      ),
      SizedBox(height: 10,),
     setDefaultAddress(),
      SizedBox(height: 20,),

      setDate(),
      SizedBox(height: 20,),

      setTime(),
      SizedBox(height: 10,),

      TextField(
        focusNode: focus_remark,
        controller: txtRemark,
          maxLines: 5,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor, width: 1,  ), ),
          hintText: AppLocalizations.of(context).translate('inquiry_txt_remark'),
            contentPadding: EdgeInsets.only(left:10,top: 15, right: 10), labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Configurations.themColor),
          ), ),cursorColor: Configurations.themColor,
      ),
      SizedBox(height: 30,),

      ButtonTheme(
        minWidth: 400.0,
        child:  RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),),
            color: Configurations.themColor,
            textColor: Colors.white,
            child:  Text(AppLocalizations.of(context).translate('bookappointment'),
                //AppLocalizations.of(context).translate('inquiry_btn_booking'),
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
    if(_lstAddress.length <= 0) {
      showInfoAlert(context, AppLocalizations.of(context).translate('add_address'));
    } else if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _autoValidate = false;
      setState(() {
        Map<String, String> data = new Map();
        data["user_id"] = user_id;
        data["service_id"] = selectedService;

        if(selectedSubCategory != null && selectedSubCategory != "") {
          data["category_id"] = selectedSubCategory;
        }
        data["orderer_name"] = txtName.text;
        printLog("orderer name when the api call :: ${txtName.text}");
        data["email"] = txtEmail.text;
        data["address_id"] = selectedAddress;
        data["booking_date"] = format.format(selecteDate);
        data["contact"] = txtContact.text;
        data["start_time"] = formatt.format(start_time);
        data["end_time"] = formatt.format(end_time);
        data["provider_id"] = provider.id.toString();
        data["remark"] = txtRemark.text;
        print("API CALLL DATA === ${data}");
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
    if (res != null) {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
//        Navigator.pop(context);
        printLog("bl");
//        showInfoAlert(context, AppLocalizations.of(context).translate('booking_order'));
        pushInfoAlert(globals.context, "JAM", AppLocalizations.of(context).translate('booking_order'));
      } else {
        var data = json.decode(res.body);
        showInfoAlert(context, "ERROR");
      }
    }
  }
  Widget setDefaultAddress(){
    return Container(
          decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
          border: Border.all(width: 0.9,color: Configurations.themColor)),
          padding: const EdgeInsets.fromLTRB(10,0,0,10),
      child: Row(
        children: [
          Text(AppLocalizations.of(context).translate('default_add') ,
              style: TextStyle(fontSize: 15 , color: Colors.black45)),
          SizedBox(width: 20,),
          Expanded(child: DropdownButton(
            underline: SizedBox(),
            isExpanded: true,
            value: selectedAddress,
            icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
            items: _dropDownAddress,
            onChanged: changedAddress,


          ),)

        ],
      )
    );
  }

  Widget setDropDown() {
    return Container(
      decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
          border: Border.all(width: 0.9,color: Configurations.themColor)),
      padding: const EdgeInsets.fromLTRB(10,0,0,0),
      child: Row(
        children:[
          Text(AppLocalizations.of(context).translate('inquiry_txt_primary') ,
              style: TextStyle(fontSize: 15 , color: Colors.black45)),
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
    );
  }
  void changedAddress(String selectedItem){
    setState(() {
      selectedAddress = selectedItem;
    });
  }
  List<DropdownMenuItem<String>> buildAddressMenuItems(List<Address> addressList){
    List<DropdownMenuItem<String>> items = List();
    addressList.forEach((val) {
      items.add(DropdownMenuItem(
        value: val.id.toString(), child: ListTile(
        title: Text(val.name),
        subtitle: Text(addressString(val), maxLines: 2,),
      ),));
      //
    });
    return items;
  }

  String addressString(Address address) {
    String addressString = "";
    if(address != null) {

      if(address.address_line1 != "" && address.address_line1 != null) {
        addressString += address.address_line1;
      }

      if(address.address_line2 != "" && address.address_line2 != null) {
        addressString += ", " + address.address_line2;
      }

      if(address.landmark != "" && address.landmark != null) {
        addressString += ", " + address.landmark;
      }
      if(address.district != "" && address.district != null) {
        addressString += ", " + address.district;
      }
      if(address.city != "" && address.city != null) {
        addressString += ", " + address.city;
      }
      if(address.postal_code != "" && address.postal_code != null) {
        addressString += ", " + address.postal_code;
      }
      addressString += ".";
    }
    return addressString;
  }

  List<DropdownMenuItem<String>> buildServicesMenuItems(List<Service> serviceList) {
    List<DropdownMenuItem<String>> items = List();
    serviceList.forEach((val) {
      items.add(DropdownMenuItem(value: val.id.toString(), child: Text((globals.localization == 'ar_SA') ? val.arabic_name : val.name)));
    });
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      selectedService = selectedItem;
    });
  }


  Widget setDropDown1() {

    String prime_category = "";
    if(this.category != null) {
      if(globals.localization == 'ar_SA') {
        prime_category = this.category.arabic_name;
      } else {
        prime_category = this.category.name;
      }
    }


    return
      TextFormField(
      readOnly: true,
      focusNode: focus_service,
      decoration: InputDecoration( suffixIcon: Icon(Icons.work, color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor,
          width: 1,  ),),
        labelText: AppLocalizations.of(context).translate('inquiry_txt_secondary'), labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Configurations.themColor),
        ),),cursorColor: Configurations.themColor,
      controller: txtSubCategory..text = prime_category,
      enabled: false,


      //txtName,//..text = 'KAR-MT30',
//        validator: (value){
//          if (value.isEmpty) {
//            return AppLocalizations.of(context).translate('signup_txt_enteruser');
//          }
//          return null;
//        },
    );

    //   Container(
    //   decoration: BoxDecoration(borderRadius:  BorderRadius.circular(9.0),
    //       border: Border.all(width: 0.9,color: Configurations.themColor)),
    //   padding: const EdgeInsets.fromLTRB(10,0,0,0),
    //   child: Row(
    //     children:[
    //       Text(AppLocalizations.of(context).translate('inquiry_txt_secondary') , style: TextStyle(fontSize: 15 , color: Colors.black45)),
    //       SizedBox(width: 20,),
    //       Expanded(child: DropdownButton(
    //           underline: SizedBox(),
    //           isExpanded: true,
    //           value: (selectedSubCategory != null) ? selectedSubCategory.toUpperCase() : "",
    //           icon: Icon(Icons.arrow_drop_down, color: Configurations.themColor,),
    //           items: _dropDownSubCategory,
    //           onChanged: changedDropDownItem1,
    //       ),
    //       ),
    //
    //     ],
    //   ),
    // );
  }

  List<DropdownMenuItem<String>> buildSubCategoryDropDownMenuItems(List<SubCategory> listSubCategory) {
    List<DropdownMenuItem<String>> items = List();
    listSubCategory.forEach((val) {
      items.add(DropdownMenuItem(value: val.id.toString(), child: Text((globals.localization == 'ar_SA') ? val.arabic_name : val.name)));
    });
    return items;
  }

  void changedDropDownItem1(String selectedItem) {
    setState(() {
      selectedSubCategory = selectedItem;
    });
  }

final format = DateFormat("dd-MM-yyyy");
final formatt= DateFormat("hh:mm a");



  Widget setDate() {

    var currDt = DateTime.now();

    // printLog("test == ${currDt.year}");
    // printLog("test == ${currDt.year+1}");

    return Container(
    padding: EdgeInsets.fromLTRB(0,0,0,0),
      height: 50,
      child: DateTimeField(
        initialValue: _currentDt,
        format: format,
        decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_today),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor, width: 1,  ), ),
            labelText: AppLocalizations.of(context).translate('inquiry_txt_date')),
        onShowPicker: (context, currentValue) async {
          return await showDatePicker(
              context: context,
              firstDate: _currentDt,
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(currDt.year+1),
           );
        },

        onChanged: (val) => {
          selecteDate = val
        },

      ),
    );
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
              child: DateTimeField(
                initialValue: _currentDt,
                format: formatt,
                decoration: InputDecoration( suffixIcon: Icon(Icons.timer),
                  hasFloatingPlaceholder: false,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor, width: 1,  ), ),
                ),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                   // initialTime: TimeOfDay(hour: 12, minute: 00),
                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    // builder: (context, child) => MediaQuery(
                    //     data: MediaQuery.of(context)
                    //         .copyWith(alwaysUse24HourFormat: true),
                    //     child: child),


                  );
                  return DateTimeField.convert(time);
                },

                onChanged: (val) => {
                  // printLog(val),
                  // printLog(DateTime.now()),
                  start_time = val// TimeOfDay.fromDateTime(val ?? DateTime.now()).toString(),
                },
                validator:  (value){
                  String formattedTime = DateFormat.Hms().format(value);
                  DateFormat formatter = DateFormat('yyyy-MM-dd');
                  String myDate = formatter.format(start_time);
                  var val = myDate + " " + formattedTime ;
                  DateTime checkTime = DateTime.parse(val);

                  if (value.isAfter(end_time)) {
                    return AppLocalizations.of(context).translate('inquiry_time');
                  } else if (value.isAfter(checkTime)) {
                    return AppLocalizations.of(context).translate('inquiry_time');
                  }
                  return null;
                },

              ),
            ),
            Flexible(flex: 1,child: Text(AppLocalizations.of(context).translate('to'))),
            Flexible(flex: 4,
              child: DateTimeField(
                initialValue: _currentDt.add(Duration(hours: 1)),
                format: formatt,
                decoration: InputDecoration( suffixIcon: Icon(Icons.timer),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Configurations.themColor, width: 1,  ), ),
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
                  printLog("end == ${value}");
                  // String formattedTime = DateFormat.Hms().format(value);
                  // DateFormat formatter = DateFormat('yyyy-MM-dd');
                  // String myDate = formatter.format(DateTime.now());
                  // var val = myDate + " " + formattedTime ;
                  // DateTime checkTime = DateTime.parse(val);
                  // printLog(checkTime);
                  printLog(start_time);

                  if (value.isBefore(start_time)) {
                    return AppLocalizations.of(context).translate('inquiry_time');
                  }
                  return null;
                },
              ),
            ),

          ],
        ),
      )
    );

  }
}

