import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Downloadd extends StatefulWidget {
  @override
  _downLoad createState() => _downLoad();
}

class _downLoad extends State<Downloadd>{
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _download();
  }
  var progress = "";
  final invoiceURL ="/api/v1/invoice?id=1";
  bool downloading = false;
  Future<void> _download() async {
    Dio dio = Dio();
    var dirToSave = await getExternalStorageDirectory();
    await dio.download(invoiceURL, "${dirToSave.path}/downloads",
        onReceiveProgress: (rec, total){
          setState(() {
            downloading = true;
            progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
            print(progress);
          });
        }
    );
    try {} catch (e) {
      throw e;
    }
    setState(() {
      downloading = false;
      progress = "Complete" ;
      print(progress);
    });

  }
}


