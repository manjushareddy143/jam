import 'package:flutter/material.dart';
import 'package:jam/app_localizations.dart';
import 'package:jam/globals.dart' as globals;

class Slide {
  final String img;
  final String header;
  final String text;
  Slide({

    @required this.img,
    @required this.header,
    @required this.text,

});
}
 final slideList =[
   Slide(img: 'assets/images/slider1.png',
           header: 'intro_title',
           text: 'intro_detail'),
   Slide(img: 'assets/images/slider2.png',
       header: 'intro_title',
       text: 'intro_detail'),
   Slide(img: 'assets/images/slider3.png',
       header: 'intro_title',
       text: 'intro_detail')];