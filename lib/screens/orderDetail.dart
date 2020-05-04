import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class OrderDetail extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: DetailUIPage());
  }
}
class DetailUIPage extends StatefulWidget {
  @override
  _DetailUIPageState createState() => _DetailUIPageState();
}
class _DetailUIPageState extends State<DetailUIPage> {

 // DateTime selecteDate;
 // DateTime start_time;
 // DateTime end_time;

  // DateTime _currentDt = new DateTime.now();




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.black),
    title: Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),),
      body: detailUI(),

    );
  }
  Widget detailUI(){
     return SingleChildScrollView(
         child: Column(mainAxisSize: MainAxisSize.min,
         //crossAxisAlignment: CrossAxisAlignment.end,
         children: <Widget>[
           Container(
             child: setFirst(),
           ),
           Material(elevation: 5.0,shadowColor: Colors.grey,
               child: Container(child: Text("hello"),)),
           Material(elevation: 5.0,shadowColor: Colors.grey,
               child: Container(child: Text("hello"),)),
         ]),
     );

  }
   Widget setFirst(){
    return new Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      elevation: 5,
      child: Column(
        children: <Widget>[
          Text("Order Number : #A5990245"),

          Row(
            children: <Widget>[

              //setDate(),
              //setTime(),

            ],
          )
        ],
      ),
    );
   }
  final format = DateFormat("dd-MM-yyyy");
  final formatt= DateFormat("HH:mm");

 /* Widget setDate(){
    return DateTimeField(
      initialValue: _currentDt,
      format: format,
      decoration: InputDecoration( prefixIcon: Icon(Icons.calendar_today, color: Colors.teal,),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
        labelText: 'Date',),
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

    );
  }
   Widget setTime(){
    return  DateTimeField(
      initialValue: _currentDt,
      format: formatt,
      decoration: InputDecoration( prefixIcon: Icon(Icons.timer, color: Colors.teal),
        hasFloatingPlaceholder: false,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1,  ), ),
      ),
      onShowPicker: (context, currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.convert(time);
      },


    );

   } */
}