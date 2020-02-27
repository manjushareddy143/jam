import 'package:http/http.dart'; //imports the http library

class Network {
  final String url;

  Network(this.url); //network class has constructor that takes the string url

  //it includes asynchronous function named getData
  Future getData() async {
    print('Calling uri: $url');
    // uses http get method with the given url and waits for the response
    Response response = await get(url);
    // checks the status code if 200 response is ok, if anything else its an error
    if (response.statusCode == 200) {
      // returns the result
      return response.body;
    } else {
      print(response.statusCode);
    }
  }
}