import 'package:http/http.dart';



class MyNet {
  final String url;

//Net class has a constructor that takes in the passed url.
  MyNet(this.url);

//here api call request and response happens in getData() method
  Future<dynamic> getData() async {
   var response = await get(url);

//checking if the data is fetched, if yes response is 200 else mentions the problem happened while fetching json file.
    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      print(response.statusCode);
    }
  }
}