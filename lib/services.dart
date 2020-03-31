
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:jam/api/detail.dart';
import 'package:jam/swiper.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({



    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  }); //configuration for the slivers layout
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
    return new SizedBox.expand(child: child); //box with a specified size
  }
  @override //called to check if the present delegate is different from old delegate, if yes it rebuilds
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
class CollapsingList extends StatelessWidget {



  SliverPersistentHeader makeHeader(String headerText) {
    //a layout that SliverAppBar uses for its shrinking/growing effect
    return SliverPersistentHeader(
      //pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: Container(
            color: Colors.lightBlue, child: Center(child:
        Text(headerText))),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body:
      CustomScrollView( //view that contains an expanding app bar followed by a list & grid
        slivers: <Widget>[
          makeHeader('Various Services',),
          //calling appbar method by passing the Text as argument.
          //Padding: const EdgeInsets.all(8.0),

          SliverGrid.count(
            crossAxisCount: 3, // how many grid needed in a row
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: <Widget>[


              Container(alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[600]),
                ),

                child: new GestureDetector( //tapping to go the corresponding view linked with it using navigator
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HelloWorldApp()));
                  },
                  child:
                  Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Container(

                          width: 80.00,
                          height: 80.00,
                          decoration: new BoxDecoration( //immutable description of how to paint box(i.e. border, color, shadow etc.)
                            image: new DecorationImage( //image is painted using paintImage for BoxDecoration
                              image: ExactAssetImage('assets/images/6745.jpg'),
                              //fetches image from an AssetBundle
                              fit: BoxFit.fill,

                            ),
                          )), //new Icon(Icons.face),

                      Padding(padding: EdgeInsets.all(1.0)),

                      Text('salon for women', style: TextStyle(fontSize: 10)),

                    ],
                  ),
                ),
              ),
            ],

          ),

          SliverFixedExtentList(
            itemExtent: 200.0,
            delegate: SliverChildListDelegate(
              [

               Container( child: CarouselDemo()),
              ],
            ),
          ),




        ],


      ),





    );

  }


}



