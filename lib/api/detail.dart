import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jam/api/empDetails.dart';
import 'dart:math' as math;
import 'package:smooth_star_rating/smooth_star_rating.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
class DetailPage extends StatelessWidget {
  int acIndex = 0;
  List<String> acImage = [
    'assets/images/vicky.jpg',
    'assets/images/ayu.jpg',
    'assets/images/shah.jpg',
    'assets/images/sal.jpg',

  ];
  List<String> acName = [
    'Himanshu Malik',
    'Afrar Sheikh',
    'Abdur Rahman',
    'Osama',
  ];
  List<String> acExp = [
    '1','3','3.5','4'
  ];
  List<String> acRev = [
    '3','3','5','2'
  ];

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      //pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 140.0,
        child: Image.asset("assets/images/actop.jpg", fit: BoxFit.contain
          ,),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:CustomScrollView(
      slivers: <Widget>[


        makeHeader(''),
        SliverFixedExtentList(
          itemExtent: 210.0,
          delegate: new SliverChildBuilderDelegate(

                (BuildContext context, int acIndex) {
                  return  Container(

                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EmpDetails()));
                      },
                      child: Wrap(alignment: WrapAlignment.spaceEvenly,
                        children: <Widget>[
                          Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              decoration: new BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.fill, image: new AssetImage(acImage[acIndex])) ),
                            ),
                            SizedBox(width:20),
                            Container(width: 240,padding: EdgeInsets.all(10.0),
                              height: 120,
                              child:
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    acName[acIndex],
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle( fontSize: 20.0,fontWeight: FontWeight.w600),
                                  ),
                                  new Text(
                                    "Experience:" + acExp[acIndex] + "Year",
                                    textAlign: TextAlign.left,
                                     overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0,),
                                  ),
                                  new SizedBox(height: 10,),
                                  Row(children: <Widget>[
                                    new SmoothStarRating(

                                        allowHalfRating: false,

                                        starCount: 5,
                                        rating: 3.0,
                                        size: 20.0,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star,
                                        color: Colors.amber,
                                        borderColor: Colors.amber,
                                        //unfilledStar: Icon(Icons., color: Colors.grey),
                                        spacing:0.0
                                    ),Text(acRev[acIndex]+"Reviews",textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0,color: Colors.blueGrey),),
                                  ])
                                ],
                              ),
                            )

                          ],
                        ),
                        Wrap( alignment: WrapAlignment.center,
                          children: <Widget>[

                              Container(decoration:  BoxDecoration(border: Border.all(width: 0.2, color: Colors.grey)),
                              width: 260,
                              height: 60,
                                child:Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 20,),
                                    Icon(Icons.assignment, color: Colors.teal,),
                                    Text('Get Quotes',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400 , color: Colors.teal),)
                                  ],
                                )
                              ),


                              Container( //padding: EdgeInsets.all(10.0),
                              width: 140,
                              height: 60,
                              decoration:  BoxDecoration(border: Border.all(width: 0.2, color: Colors.grey)),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.phone, color: Colors.teal,),
                                    Text('Call',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300 , color: Colors.black),)
                                  ],
                                ),
                            ),

                          ],),
                      ],),
                    )

                );

          },
            childCount : 4,
          ),
        ),




      ],),
    );


  }
}