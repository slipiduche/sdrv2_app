import 'package:SDRV2_APP/constants.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            ImageIcon(
              AssetImage(
                'assets/orbittas.png',
              ),
              color: colorOrbittas,
              size: 40.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'PREGUNTAS FRECUENTES',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            _botonFaq(context, '¿No me conecto?'),
            _botonFaq(context, '¿No encienden las salidas?'),
            _botonFaq(context, '¿No titila el led?'),
            //_botonFaq('¿No me conecto?'),
            //Expanded(child: Container()),
          ]),
        ),
      ),
    );
  }

  Widget _botonFaq(BuildContext context, String texto) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                //title: Container(),
                content: _faqDialog(texto, 'Verifica tu conexión a internet'),
              );
            });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: <BoxShadow>[boxShadow1],
        ),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 25.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _faqDialog(String titulo, texto) {
    return SingleChildScrollView(
      child: Column(children: [
        Text(
          titulo,
          style: TextStyle(fontSize: 25.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(texto),
      ]),
    );
  }
}
