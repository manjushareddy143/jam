

//import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:jam/globals.dart' as globals;

class CropPhotoRoute extends StatefulWidget {
  final File img;
  CropPhotoRoute({Key key, @required this.img}) : super(key: key);

  @override
  _CropPhotoRouteState createState() => _CropPhotoRouteState(img: this.img);
}

class _CropPhotoRouteState extends State<CropPhotoRoute> {
  final cropKey = GlobalKey<ImgCropState>();
  final File img;

  _CropPhotoRouteState({Key key, @required this.img});

//  Future<Null> showImage(BuildContext context, File file) async {
//    new FileImage(file)
//        .resolve(new ImageConfiguration())
//        .addListener(ImageStreamListener((ImageInfo info, bool _) {
//      print('-------------------------------------------$info');
////      Navigator.of(context).;
//    }));
//    return showDialog<Null>(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//              title: Text(
//                'Current screenshot：',
//                style: TextStyle(
//                    fontFamily: 'Roboto',
//                    fontWeight: FontWeight.w300,
//                    color: Theme.of(context).primaryColor,
//                    letterSpacing: 1.1),
//              ),
//              content: Image.file(file));
//        });
//  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Zoom and Crop',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon:
            new Icon(Icons.navigate_before, color: Colors.black, size: 40),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ImgCrop(
            key: cropKey,
            // chipRadius: 100,
            // chipShape: 'rect',
            maximumScale: 3,
            image: FileImage(this.img),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final crop = cropKey.currentState;
            final croppedFile =
            await crop.cropCompleted(img, pictureQuality: 600);
            globals.proImg = croppedFile;
            Navigator.pop(context, croppedFile);
          },
          tooltip: 'Increment',
          child: Text('Crop'),
        ));
  }
}