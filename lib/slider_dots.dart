import 'package:flutter/material.dart';
class SliderDots extends StatelessWidget{
  bool isSelected;
  SliderDots(this.isSelected);
  @override
  Widget build(BuildContext context){
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: isSelected ? 8 : 4,
      width:  isSelected ? 18 : 8,
      decoration: BoxDecoration(color: isSelected ? Colors.deepOrange : Colors.grey,
      borderRadius: BorderRadius.circular(10)),
    );
  }
}