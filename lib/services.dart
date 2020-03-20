import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:jam/api/detail.dart';

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
  @override
  /*void initState(){
    super.initState();
    this.getServices();
    this.setState(() {
    });
  } */



  SliverPersistentHeader makeHeader(String headerText) { //a layout that SliverAppBar uses for its shrinking/growing effect
    return SliverPersistentHeader(
      pinned: true,
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
    return CustomScrollView( //view that contains an expanding app bar followed by a list & grid
      slivers: <Widget>[
        makeHeader('Various Services'), //calling appbar method by passing the Text as argument.
        //Padding: const EdgeInsets.all(8.0),

        SliverGrid.count(
          crossAxisCount: 3, // how many grid needed in a row
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: <Widget> [


            Container(        alignment: FractionalOffset.center,
                              decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[600]),
                              ),

                child:new GestureDetector( //tapping to go the corresponding view linked with it using navigator
                              onTap: () {
                               Navigator.push(context,MaterialPageRoute(builder: (context)=> HelloWorldApp()));
                                         },
                child:
                   new Column(

                      mainAxisAlignment:  MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[



                    new Container(

                        width: 130.00,
                        height: 60.00,
                        decoration: new BoxDecoration(  //immutable description of how to paint box(i.e. border, color, shadow etc.)
                        image: new DecorationImage( //image is painted using paintImage for BoxDecoration
                        image: ExactAssetImage('assets/images/6745.jpg'),//fetches image from an AssetBundle
                        fit: BoxFit.fitHeight,

                          ),
                       )),//new Icon(Icons.face),

                    new Padding(padding: EdgeInsets.all(10.0)),

                    new Text('salon for women'),
                  ],
                ),
              ),
            ),
          ],
        ),

       /* makeHeader('Header Section 2'),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.red),
              Container(color: Colors.purple),
              Container(color: Colors.green),
              Container(color: Colors.orange),
              Container(color: Colors.yellow),
            ],
          ),
        ), */
        /*makeHeader('Header Section 3'),
        SliverGrid(
          gridDelegate:
          new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return new Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: new Text('grid item $index'),
              );
            },
            childCount: 20,
          ),
        ), */
      ],
    );
  }
}



/*class Testi {

  String name;

  Testi({this.name, this.id});

  factory Testi.fromJson(Map<String, dynamic> json){
    return new Testi(name: json['name'] as String,

    );

  }
}



getMyData() async{
  String objText = '{"name": "a"}, {"name": "b"}, {"name": "c"}, {"name": "d"},';

  tempData = json.decode(objText);

  data=tempData.map<Testi>((m) => new Testi.fromJson(m)).toList();
  setState(() {

  });



  // return data;

}*/