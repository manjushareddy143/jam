import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/models/order.dart';
import 'package:jam/resources/configurations.dart';
import 'package:jam/utils/utils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class OrderDetail extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: DetailUIPage());
  }
}
class DetailUIPage extends StatefulWidget {
  final Order order;
  DetailUIPage({Key key, @required this.order}) : super(key: key);
  @override
  _DetailUIPageState createState() => _DetailUIPageState(order: this.order);
}
class _DetailUIPageState extends State<DetailUIPage> {
  final Order order;
  _DetailUIPageState({Key key, @required this.order});
 // DateTime selecteDate;
 // DateTime start_time;
 // DateTime end_time;

  // DateTime _currentDt = new DateTime.now();




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.black),
    backgroundColor: Colors.white,
    title: Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),),
      body: detailUI(),

    );
  }
  Widget detailUI(){
     return SingleChildScrollView(
         child: Column(mainAxisSize: MainAxisSize.min,
         //crossAxisAlignment: CrossAxisAlignment.end,
         children: <Widget>[
//           Container(
//             child: setOrderInfo(),
//           ),
           setOrderInfo(),
           setServiceInfo(),
           detailInfo(),


           ButtonTheme(
             minWidth: 270.0,
             child:  RaisedButton(
                 color: Colors.teal,
                 textColor: Colors.white,
                 child: const Text(
                     'Download Invoice',
                     style: TextStyle(fontSize: 16.5)
                 ),
                 onPressed: () {
//                   validateForm();
                 }
             ),
           ),



         ]),
     );

  }


 Widget setOrderInfo(){
    return new Card(
        margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Order: ",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
                  Text("#" + this.order.id.toString(),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 20)),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(child: Icon(Octicons.calendar, color: Configurations.themColor,),
                  flex: 4,),
                SizedBox(width: 10,),

                Flexible(child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Date", style: TextStyle(fontSize: 12, color: Colors.grey),),
                    Text(order.booking_date)

                  ],
                ),
                  flex: 8,),
                SizedBox(width: 10,),

                Flexible(child: Icon(MaterialIcons.access_time, color: Configurations.themColor,),
                  flex: 4,),
                SizedBox(width: 10,),

                Flexible(child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Date", style: TextStyle(fontSize: 12, color: Colors.grey),),
                    Text(order.end_time)

                  ],
                ),
                  flex: 8,),
              ],
            ),),
          ],
        )
    );
 }

 Widget setServiceInfo() {
    return new Card(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Octicons.person, color: Configurations.themColor,),
                Text("Vendor: ",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
                Text(this.order.provider_first_name,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 20)),
              ],
            ),
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(70, 5, 10,10),
                child:
                SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: (order.rating == null)? 0.0 : order.rating.floorToDouble(),
                  size: 20.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  spacing:0.0,
                  onRatingChanged: (v) {
                    setState(() {
                      printLog("RATE :: $v");
                    });
                  },
                ),
              ),
              Text((order.rating == null) ? "" : order.rating.toString(),textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0,color: Colors.blueGrey),),
            ],
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 10,10),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Service", style: TextStyle(fontSize: 12, color: Colors.grey),),
              SizedBox(height: 5,),
              Text(order.service)
            ],
          ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(30, 0, 30,0),
          child: Divider(
            color: Colors.black,
          ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(40, 10, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Category", style: TextStyle(fontSize: 12, color: Colors.grey),),
                SizedBox(height: 5,),
                Text(order.category)
              ],
            ),
          ),

        ],
      )
    );
 }

 Widget detailInfo() {
    return Card(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
      elevation: 5,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Octicons.location
                Icon(MaterialIcons.location_on, color: Configurations.themColor,),
                SizedBox(width: 20,),
                Text("Address",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 10,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("61 Khodiyarnagar, near k k mill Mahuva 364290", )
              ],
            ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(30, 0, 30,0),
            child: Divider(
              color: Colors.black,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Octicons.location
                Icon(MaterialIcons.email, color: Configurations.themColor,),
                SizedBox(width: 20,),
                Text("Email",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 10,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(order.email)
              ],
            ),
          ),


          Padding(padding: EdgeInsets.fromLTRB(30, 0, 30,0),
            child: Divider(
              color: Colors.black,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Octicons.location
                Icon(MaterialIcons.phone, color: Configurations.themColor,),
                SizedBox(width: 20,),
                Text("Number",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20)),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 10,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(order.contact)
              ],
            ),
          ),



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