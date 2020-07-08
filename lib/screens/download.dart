import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jam/resources/configurations.dart';
import 'package:path_provider/path_provider.dart';


class DownLoadHelper {
//  @override
//  void initState(){
//    // TODO: implement initState
//    super.initState();
//    _download();
//  }

   var progress = "";
//   Future<Directory> downloadsDirectory = DownloadsPathProvider.downloadsDirectory;

   final invoiceURL = Configurations.INVOICE_GENERATE_URL +  "?id=1";
   bool downloading = false;
  Future<String> downloadFile(StateSetter setState) async {
    var dirToSave = await getExternalStorageDirectory();
    Dio dio = Dio();

    await dio.download(invoiceURL, "${dirToSave.path}/invoice.pdf",
        onReceiveProgress: (rec, total){
          setState(() {
            downloading = true;
            progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        }
    );
    try {
      downloading = false;
      progress = "Complete" ;

      return dirToSave.path +"/invoice.pdf";
    } catch (e) {
      throw e;
    }
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


