import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class Orders extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: OrderUIPage());
  }
}
class OrderUIPage extends StatefulWidget {
  @override
  _OrderUIPageState createState() => _OrderUIPageState();
}
class _OrderUIPageState extends State<OrderUIPage> {
  int oIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title: Text("My Orders", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),), backgroundColor: Colors.white,),
      body: myOrderUI()
    );
  }






  Widget myOrderUI(){
    return CustomScrollView(
      slivers: <Widget>[
        SliverFixedExtentList(
          itemExtent: 180.0,
          delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int oIndex) {
                return  Container(
                  child: Wrap(alignment: WrapAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(margin: EdgeInsets.all(20),
                        alignment: Alignment.center,padding: EdgeInsets.only(top: 10),
                        width: 100,
                        height: 100,
                        decoration: new BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.fill, image: new AssetImage("assets/images/vicky.jpg")) ),
                      ),

                      Container(width: 240,margin: EdgeInsets.all(10),
                        height: 120,
                        child:
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Afrar Sheikh",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w600),
                            ),
                            new Text(
                              "Plumbing",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0,),
                            ),
                            new Text(
                              "Order#:990245",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0,),
                            ),
                            Wrap(
                                children:<Widget> [
                                  Row(
                                      children:<Widget>[
                                        new Text(
                                          "01-April-2020, 1:00 PM",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.0, ),
                                        ),
                                        SizedBox(width: 10,),
                                        new SmoothStarRating(
                                            allowHalfRating: false,

                                            starCount: 5,
                                            rating: 3.0,
                                            size: 15.0,
                                            filledIconData: Icons.star,
                                            halfFilledIconData: Icons.star,
                                            color: Colors.amber,
                                            borderColor: Colors.amber,
                                            //unfilledStar: Icon(Icons., color: Colors.grey),
                                            spacing:0.0
                                        )
                                      ]
                                  ),
                                ]
                            ),
                            SizedBox(height: 20,),
                            Container(
                              child:
                              Row(//crossAxisAlignment: WrapCrossAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Text(
                                      "Order Completed",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,

                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0, color: Colors.teal, ),

                                    ),

                                    Icon(Icons.check_box, size: 12,color: Colors.teal,)]
                              ),


                            )




                          ],
                        ),
                      ),
                    ],),
                );
              }
          ),
        )
      ],
    );
  }
}