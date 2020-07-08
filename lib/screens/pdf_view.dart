import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jam/resources/configurations.dart';
//import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:open_file/open_file.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
//import 'package:image_picker/image_picker.dart';

class PDFView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: PDFViewUIPage());
  }
}
class PDFViewUIPage extends StatefulWidget {

  final String path;

  PDFViewUIPage({Key key, @required this.path}) : super(key: key);

  @override
  _PDFViewUIPageState createState() => _PDFViewUIPageState(path: this.path);
}
class _PDFViewUIPageState extends State<PDFViewUIPage> {

  final String path;
  _PDFViewUIPageState({Key key, @required this.path});
  static String localPath;
//  PdfController _pdfController;
  @override
  void initState(){
    super.initState();
    print("init = ${this.path}");
    localPath = this.path;
//    _pdfController = PdfController(
//      document: PdfDocument.openFile("/storage/emulated/0/Android/data/com.jamnew/files/invoice.pdf"),
//    );
    print("localPath = $localPath");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(leading: BackButton(color:Colors.black),
          title: Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),), backgroundColor: Colors.white,actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.mode_edit),
            onPressed: () {

            },
          ),
        ],
          iconTheme: IconThemeData(
            color: Configurations.themColor,
          ),),
        body: null //pdfView()
    );
  }




//  Widget pdfView() => PdfView(
//    documentLoader: Center(child: CircularProgressIndicator()),
//    pageLoader: Center(child: CircularProgressIndicator()),
//    controller: _pdfController,
//    onDocumentError: (error) {
//      setState(() {
//        print(error);
//      });
//    },
//    onDocumentLoaded: (document) {
//      setState(() {
////        _allPagesCount = document.pagesCount;
//      print(document.pagesCount);
//      });
//    },
//    onPageChanged: (page) {
//      setState(() {
////        _actualPageNumber = page;
//        print(page);
//      });
//    },
//  );




}