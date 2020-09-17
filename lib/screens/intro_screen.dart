import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jam/login/login.dart';
import 'package:jam/login/masterSignupScreen.dart';
import 'package:jam/slider_layout.dart';
import 'package:jam/slider_model.dart';
import 'package:jam/slider_dots.dart';
import 'package:jam/globals.dart' as globals;
import 'package:jam/app_localizations.dart';
import 'package:jam/screens/home_screen.dart';

class SliderScreen extends StatefulWidget {
  _sliderScreen createState() => new _sliderScreen();
}
class _sliderScreen extends State<SliderScreen>{
  int current= 0;
  _onPageChanged(int index){
    setState(() {
      current = index;
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.23,
              //170,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/topLogin.jpg'),
                      fit: BoxFit.cover
                  )
              ),
            ),
           Container(
             height: MediaQuery.of(context).size.height * 0.57,
             color: Colors.white,
             child: Stack(alignment: AlignmentDirectional.bottomCenter,
               children:[PageView.builder(
                   scrollDirection: Axis.horizontal,
                   controller: _pageController,
                   onPageChanged: _onPageChanged,
                   itemCount: slideList.length,
                   itemBuilder:(ctx, i)=> SliderLayout(i)
               ),
               Stack(
                 alignment: AlignmentDirectional.topStart,
                 children: [
                   Container( margin: const EdgeInsets.only(bottom: 15),
                   child:  Row(mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       for( int i1 = 0; i1 < slideList.length; i1 ++)
                         if(i1 == current)
                           SliderDots(true)
                         else
                           SliderDots(false)
                     ],
                   ),)


                 ],
               )]
             ),
           ),


            Container(
              color: Colors.white,
              child: Column( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton( onPressed: (){
                    globals.guest = true;
                    globals.isVendor = false;
                    globals.isCustomer=false;
                    print("I am a guest :)");


                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                  },
                    child: Text(AppLocalizations.of(context).translate('txt_skip'),
                      textAlign: TextAlign.center,style: TextStyle( color: Colors.grey,),),
                  ),


                  FlatButton(
                    child: Text("Create an Account",style: TextStyle(color: Colors.white),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.deepOrangeAccent,
                    onPressed: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => masterSignup()));
                    },


                  ),
                  SizedBox(height: 10,),

                  SizedBox(height: 20,
                    child: Text("------------------------ OR ------------------------", style: TextStyle(color: Colors.grey),),
                  ),
                  SizedBox(height: 10,),
                  FlatButton( onPressed: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => UserLogin()));
                  },
                    child: Text("LOGIN NOW",
                      textAlign: TextAlign.center,style: TextStyle( color: Colors.blueGrey,fontWeight: FontWeight.w700),),
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}