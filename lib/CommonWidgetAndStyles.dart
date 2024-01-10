import 'package:flutter/material.dart';

var buttonStyle=TextButton.styleFrom(
  primary: Colors.white, // Text color
  backgroundColor: Colors.black, // Button background color
  padding: EdgeInsets.all(16), // Button padding
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8), // Button border radius
  ),
);
var textStyle=TextStyle(color: Colors.white,fontSize: 20);
    TextButton textButton(String text,Function function){
  return TextButton(onPressed: (){function();}, child: Text(text),style:  buttonStyle);
}