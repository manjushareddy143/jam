import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:jam/screens/home_screen.dart';
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




  @override
  _InquiryPageState createState() => _InquiryPageState();
}
class _InquiryPageState extends State<InquiryPage> {
  TextEditingController dateCtl = TextEditingController();
  final txtName = TextEditingController();
  final txtContact = TextEditingController();
  final txtEmail = TextEditingController();



  DateTime _currentDt = new DateTime.now();



  bool isAC = false;
  String dropdownvalue;
  List<DropdownMenuItem<String>> _dropDownTypes;
  Map<String, dynamic> _lstType = {"N":"","A":"AC installation ","B": "Painting & Decor","C":"Electrical Works"};








  bool isAC1 = false;
  String dropdownvalue1;
  List<DropdownMenuItem<String>> _dropDownTypes1;
  Map<String, dynamic> _lstType1 = {"N":"","A":"AC installation ","B": "Painting & Decor","C":"Electrical Works"};

  @override
  void initState() {
    super.initState();
    _dropDownTypes = buildAndGetDropDownMenuItems(_lstType);
    dropdownvalue = _dropDownTypes[0].value;
    _dropDownTypes1 = buildAndGetDropDownMenuItems1(_lstType1);
    dropdownvalue1 = _dropDownTypes1[0].value;
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
      Material(elevation: 10.0,shadowColor: Colors.grey,
        child: TextFormField(

          decoration: InputDecoration( suffixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
            labelText: 'First Name',),
          controller: txtName,//..text = 'KAR-MT30',
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
          controller: txtEmail,//..text = 'KAR-MT30',
          keyboardType: TextInputType.emailAddress,
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter username!!';
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
          controller: txtContact,//..text = 'KAR-MT30',
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
    return Material(elevation: 10.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,5,0,5),
        child: Row(
          children:[
            Text("Primary Service" , style: TextStyle(fontSize: 17 , color: Colors.black45)),
            SizedBox(width: 50,),
            Expanded(child: DropdownButton(
                isExpanded: true,
                value: dropdownvalue,
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal,),
                items: _dropDownTypes,
                onChanged: changedDropDownItem),
            ),

          ],
        ),
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
      dropdownvalue = selectedItem;
      print(dropdownvalue);
      if(selectedItem == "") {
        isAC = true;
      } else {
        isAC = false;
      }
    });
  }








  Widget setDropDown1() {
    return Material(elevation: 10.0,shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,5,0,5),
        child: Row(
          children:[
            Text("Secondary Service" , style: TextStyle(fontSize: 17 , color: Colors.black45)),
            SizedBox(width: 50,),
            Expanded(child: DropdownButton(
                isExpanded: true,
                value: dropdownvalue1,
                icon: Icon(Icons.arrow_drop_down, color: Colors.teal,),
                items: _dropDownTypes1,
                onChanged: changedDropDownItem1),
            ),

          ],
        ),
      ),
    );
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems1(Map<String, dynamic> reportForlist) {
    List<DropdownMenuItem<String>> items = List();
    reportForlist.forEach((key, val) {
      items.add(DropdownMenuItem(value: key, child: Text(val)));
    });
    return items;
  }

  void changedDropDownItem1(String selectedItem) {
    setState(() {
      dropdownvalue1 = selectedItem;
      print(dropdownvalue1);
      if(selectedItem == "") {
        isAC1 = true;
      } else {
        isAC1 = false;
      }
    });
  }



final format = DateFormat("yyyy-MM-dd");
final formatt= DateFormat("HH:mm");

  Widget setDate(){
    return Material(elevation: 10.0,shadowColor: Colors.grey,
        child: Container(

        padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: DateTimeField(
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
              ),
            ),
          ),
          Flexible(flex: 2,child: Text("To")),
          Flexible(flex: 5,
            child: Material(elevation: 10.0,shadowColor: Colors.grey,
              child: DateTimeField(
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
              ),
            ),
          ),
       ]),
    );

  }
}

