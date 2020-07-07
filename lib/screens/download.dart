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
  Future<void> downloadFile(StateSetter setState) async {
    print("donwload method call == " + invoiceURL);
    var dirToSave = await getExternalStorageDirectory();
    print("donwload method call == ${dirToSave.path}" );
    Dio dio = Dio();

    await dio.download(invoiceURL, "${dirToSave.path}/files/invoice.pdf",
        onReceiveProgress: (rec, total){
          setState(() {
            downloading = true;
            progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
            print(progress);
          });
        }
    );
    try {

    } catch (e) {
      throw e;
    }
    setState(() {
      downloading = false;
      progress = "Complete" ;
      print(progress);
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


