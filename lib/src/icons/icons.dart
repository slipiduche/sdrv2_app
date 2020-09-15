import 'package:flutter/material.dart';

Widget homeIcon(double size) {
  return Container(
    // height: size,
    // width: size,
    // margin: EdgeInsets.only(left: 1.0),
    child: Image(image: AssetImage('assets/home.png'), fit: BoxFit.contain,),
  );
}

Widget autoIcon(double size) {
  return Container(
    // height: size,
    // width: size,
    // padding: EdgeInsets.only(right:20.0,bottom: 4.0,),
    //margin: EdgeInsets.only(bottom: 10.0,right:30.0),
    child: Image(image: AssetImage('assets/auto.png'), fit: BoxFit.contain,),
  );
}
Widget manualIcon(double size) {
  return Container(
    // height: size,
    // width: size,
    // margin: EdgeInsets.only(right: 30.0,),
    // padding: EdgeInsets.only(top: 5.0),
    child: Image(image: AssetImage('assets/manual.png'), fit: BoxFit.contain,),
  );
}

Widget wifiIcon(double size) {
  return Container(
     height: size,
     width: size,
    //margin: EdgeInsets.only(top: 2.0,right: 30.0),
    child: Image(image: AssetImage('assets/wifi.png'), fit: BoxFit.contain,),
  );
}
Widget fechaIcon(double size) {
  return Container(
    //margin: EdgeInsets.only(top: 10.0,right: 15.0),
    // height: size,
    // width: size,
    child: Image(image: AssetImage('assets/fecha.png'), fit: BoxFit.contain,),
  );
}
Widget progIcon(double size) {
  return Container(
    // margin: EdgeInsets.only(top: 14.0,),
    // height: size,
    // width: size,
    child: Image(image: AssetImage('assets/prog.png'), fit: BoxFit.contain,),
  );
}
Widget orbittasIcon(double size) {
  return Container(
    // margin: EdgeInsets.only(top: 14.0,),
    // height: size,
    // width: size,
    child: Image(image: AssetImage('assets/orbittas.png'), fit: BoxFit.contain,),
  );
}

