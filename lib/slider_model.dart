import 'package:flutter/material.dart';
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
   Slide(img: 'assets/images/ImageLogin.png',
           header: 'GET THINGS DONE FAST',
           text: 'NOW YOU CAN GET FAST SERVICE FOR VARIOUS THINGS THAT YOU NEED HELP FOR.'),
   Slide(img: 'assets/images/ImageLogin.png',
       header: 'GET THINGS DONE FAST',
       text: 'NOW YOU CAN GET FAST SERVICE FOR VARIOUS THINGS THAT YOU NEED HELP FOR.'),
   Slide(img: 'assets/images/ImageLogin.png',
       header: 'GET THINGS DONE FAST',
       text: 'NOW YOU CAN GET FAST SERVICE FOR VARIOUS THINGS THAT YOU NEED HELP FOR.')];