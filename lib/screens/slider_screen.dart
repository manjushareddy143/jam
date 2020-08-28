import 'package:flutter/material.dart';
import 'package:jam/login/login.dart';
import 'package:jam/login/masterSignupScreen.dart';
import 'package:jam/slider_layout.dart';
import 'package:jam/slider_model.dart';

class SliderScreen extends StatefulWidget {
  _sliderScreen createState() => new _sliderScreen();
}
class _sliderScreen extends State<SliderScreen>{
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/slider1.jpg'),
                      fit: BoxFit.cover
                  )
              ),
            ),
           PageView.builder(
             scrollDirection: Axis.horizontal,
               controller: _pageController,
               itemCount: slideList.length,
               itemBuilder:(ctx, i)=> SliderLayout(i)),
            Column( mainAxisAlignment: MainAxisAlignment.center,
              children: [


               FlatButton(
                  child: Text("Create an Account",style: TextStyle(color: Colors.white),),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(7)),
                 color: Colors.deepOrangeAccent,
                 onPressed: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => masterSignup()));
                  },


                ),
               SizedBox(height: 10,),

               SizedBox(height: 20,
                 child: Text("------------------------ OR ------------------------"),
               ),
               SizedBox(height: 10,),
               FlatButton( onPressed: (){
     Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => UserLogin()));
               },
                 child: Text("LOGIN NOW",
                   textAlign: TextAlign.center,style: TextStyle( color: Colors.blueGrey,),),
                ),


              ],
            )
          ],
        ),
      ),
    );
  }

}