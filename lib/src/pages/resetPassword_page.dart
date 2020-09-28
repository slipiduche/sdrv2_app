import 'dart:ui';

import 'package:SDRV2_APP/src/provider/usuario_provider.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:SDRV2_APP/constants.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final prefs = new PreferenciasUsuario();
  final usuarioProvider = new UsuarioProvider();
  String _email = '', _password = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // width: double.infinity,
            // height: double.infinity,
            //margin: EdgeInsets.symmetric(vertical: 40.0),
            color: Color.fromRGBO(255, 255, 255, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.0,),
                
                ImageIcon(
                  AssetImage(
                    'assets/orbittas.png',
                  ),
                  color: colorOrbittas,
                  size: 40.0,
                ),
                SizedBox(
                  height: 60.0,
                  width: double.infinity,
                ),
                //Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                        GestureDetector(
                          onTap: () {
                           // Navigator.pushNamed(context, 'createUser');
                          },
                          child: _botonSuperior(
                              '¿Olvidó su contraseña?', colorOrbittas, Colors.white),
                        ),
                      
                     
                      //_bontonLogin()
                    ],
                  ),
                ),
                _formulario(),
                //Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonSuperior(String texto, Color color, textColor) {
    return Container(
      //color: colorResaltadoBoton,
      //height: 50.0,
      width: 134.0,
      //margin: EdgeInsets.symmetric(horizontal: 31.0),
      padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: colorBordeBotton,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: <BoxShadow>[boxShadow1],
      ),

      child: Text(texto,
          style: TextStyle(
              color: textColor, fontSize: 20.0, fontFamily: 'Archivo'),
          textAlign: TextAlign.center),
    );
  }

  Widget _botonPlano(String texto, Color color, textColor) {
    return Container(
      //color: colorResaltadoBoton,
      //height: 50.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
      padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: colorBordeBotton,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),

      child: Text(texto,
          style: TextStyle(
              color: textColor, fontSize: 20.0, fontFamily: 'Archivo'),
          textAlign: TextAlign.center),
    );
  }

  Widget _formulario() {
    return Container(
      //color: colorResaltadoBoton,
      //height: 50.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: colorBordeBotton,
          width: 1.0,
        ),
        //borderRadius: BorderRadius.circular(6.0),
        boxShadow: <BoxShadow>[boxShadow1],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _crearEmail(),
          SizedBox(
            height: 30.0,
          ),
          GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      elevation: 5.0,
                      content: Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 100),
                          child: Container(
                              margin: EdgeInsets.all(5),
                              height: 10.0,
                              width: 10.0,
                              color: Colors.white,
                              child: CircularProgressIndicator())),
                    ));
                final login = await usuarioProvider.resetPaswword(_email);
                if (login['ok']) {
                  // print(login);
                  // if (prefs.dispositivoSeleccionado != null) {
                  //   Navigator.pop(context);
                  //   Navigator.pushReplacementNamed(context, 'homePage');
                  // } else {
                  //   Navigator.pop(context);
                  //   Navigator.pushReplacementNamed(context, 'perfilPage');
                  // }
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        elevation: 5.0,
                        title: Center(child: Text('Exito')),
                        content: Container(
                          child: Text(
                            login["mensaje"],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        actions: [

                        ],
                      ));
                  print(login);
                } else {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        elevation: 5.0,
                        title: Center(child: Text('Error')),
                        content: Container(
                          child: Text(
                            login["mensaje"],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ));
                  print(login);
                }
              },
              child: Center(child: _botonPlano('Resetear contraseña', colorOrbittas, Colors.white))),
        ],
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 18.0, right: 18.0),
      child: TextField(
        //autofocus: true,
        //textCapitalization: TextCapitalization.sentences,

        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          hintText: 'Correo',
          labelText: 'Correo',
          suffixIcon: Icon(Icons.alternate_email),
          //icon: Icon(Icons.email)
        ),
        onChanged: (valor) {
          setState(() {});
          _email = valor;
        },
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 18.0, right: 18.0),
      child: TextField(
        //autofocus: true,
        //textCapitalization: TextCapitalization.sentences,
        //keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          hintText: 'Contraseña',
          labelText: 'Contraseña',
          suffixIcon: Icon(Icons.lock_open),
          // icon: Icon(Icons.lock)
        ),
        onChanged: (valor) {
          setState(() {});
          _password = valor;
        },
      ),
    );
  }
}
