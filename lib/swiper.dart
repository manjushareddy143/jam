import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CarouselDemo extends StatefulWidget {


  @override
  CarouselDemoState createState() => CarouselDemoState();
}

class CarouselDemoState extends State<CarouselDemo> {
  int photoIndex = 0;
  List<String> photos = [
    'assets/images/ac-repair.jpeg',
    'assets/images/salon.jpg',
    'assets/images/ac-repair.jpeg',
    'assets/images/ac-repair.jpeg',
  ];
  List<String> phrase = [
    'Home Cleaning Services',
    'Exclusive Offers',
    '50% off',
    'Home Repair & Maintenance',
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: 600.0,
        itemBuilder: (BuildContext context, int photoIndex) {
      return Stack(
             children:<Widget>[
                 Center(child: Image.asset(photos[photoIndex],
                 fit: BoxFit.fill,
                   width: double.infinity,height: 250,),
                 ),
                  Center(
                    child: Container(
          //width: 90,
          //height: 90,
          //color: Colors.white,
                          child: Text(phrase[photoIndex],
                         style: TextStyle( fontWeight: FontWeight.bold,
          color: Colors.white,
          )),),)]



      );
    },

          //autoplay: true,
          itemCount: 3 ,
         // pagination: new SwiperPagination(),
          control: new SwiperControl(), )
    );
  }
}