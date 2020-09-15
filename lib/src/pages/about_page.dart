import 'package:SDRV2_APP/constants.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(children: [
            Expanded(child: Container()),
            Text(
              'ACERCA DE',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  decoration: TextDecoration.none),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              padding: EdgeInsets.symmetric(vertical:30.0, horizontal:60.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: <BoxShadow>[
                  boxShadow1
                ],
                border: Border.all(
                  color: colorBordeBotton,
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  Image(
                      image: AssetImage('assets/ORBITTAScompleto.png'),
                      fit: BoxFit.contain),
                  SizedBox(height: 10.0,),
                  Text('Version 2.0',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,
                          decoration: TextDecoration.none))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              padding: EdgeInsets.only(top:8.0,bottom:8.0, right:10.0, left: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: <BoxShadow>[
                  boxShadow1
                ],
                border: Border.all(
                  color: colorBordeBotton,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Text('Actualizar a la versión actual', style: TextStyle(fontSize: 14.0),),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward_ios,size: 15.0,),
                ],
              ),
            ),
            SizedBox(height: 50.0,),
            Text('www.orbittas.com',style: TextStyle(fontSize: 14.0),),
            Expanded(child: Container())
          ]),
        ),
      ),
    );
  }
}
