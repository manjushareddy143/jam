import 'package:flutter/material.dart';
import 'package:jam/slider_model.dart';
class SliderLayout extends StatelessWidget{
  final int index;
  SliderLayout(this.index);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Column(
      children: [




        SizedBox(height: 10,),
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(slideList[index].img),
                  fit: BoxFit.cover
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(26,40,26,1),
          child: Text(slideList[index].header, textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 27.0,color: Colors.deepOrange)),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(slideList[index].text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0,color: Colors.black)),
        ),
        SizedBox(height: 20,)



      ],
    );

  }
}