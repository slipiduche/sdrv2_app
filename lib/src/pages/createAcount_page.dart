import 'dart:ui';

import 'package:SDRV2_APP/src/provider/usuario_provider.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:SDRV2_APP/constants.dart';

/*
Container(
              width: double.infinity,
              height: double.infinity,
              color: Color.fromRGBO(255, 255, 255, 1.0),
              child:
*/
class CreateAcountPage extends StatefulWidget {
  @override
  _CreateAcountPageState createState() => _CreateAcountPageState();
}

class _CreateAcountPageState extends State<CreateAcountPage> {
  final prefs = new PreferenciasUsuario();
  final usuarioProvider = new UsuarioProvider();
  String _email = '', _password = '', _firstName = '', _lastName = '';
  bool _bloquearCheck = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40.0,
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
                height: 40.0,
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    _botonSuperior('Crear Cuenta', colorOrbittas, Colors.white),
                    Expanded(child: Container()),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: _botonSuperior(
                            'Acceder', colorResaltadoBoton, Colors.black)),

                    //_bontonLogin()
                  ],
                ),
              ),
              _formulario(),
              SizedBox(
                height: 20.0,
              ),
              //Expanded(child: Container()),
            ],
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
      // margin: EdgeInsets.symmetric(horizontal: 31.0),
      padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: colorBordeBotton,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: colorShadow,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(0, 2.0))
        ],
      ),

      child: Text(texto,
          style: TextStyle(
              color: textColor, fontSize: 20.0, fontFamily: 'Archivo'),
          textAlign: TextAlign.center),
    );
  }

  Widget _botonPlano(
    BuildContext context,
    String texto,
    Color color,
    textColor,
  ) {
    if (_bloquearCheck == false) {
      color = colorOrbittas;
    } else {
      color = colorBordeBotton;
    }
    return GestureDetector(
      onTap: _bloquearCheck
          ? null
          : () async {
              _enviar(context);
            },
      child: Container(
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
      ),
    );
  }

  _enviar(BuildContext context) {
    _enviarParametros(context);
  }

  _enviarParametros(BuildContext context) async {
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
    final login = await usuarioProvider.nuevoUsuario(
        _email, _password, _firstName, _lastName);
    if (login['ok']) {
      print(login);
      Navigator.pop(context);
      showDialog(
          context: context,
          child: AlertDialog(
            elevation: 5.0,
            title: Center(child: Text('¡Ya casi!')),
            content: Container(
              child: Text(
                login["mensaje"],
                textAlign: TextAlign.center,
              ),
            ),
          ));
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
            height: 20.0,
          ),
          _crearNombre(),
          SizedBox(
            height: 20.0,
          ),
          _crearApellido(),
          SizedBox(
            height: 20.0,
          ),
          _crearPassword(),
          SizedBox(
            height: 20.0,
          ),
          _crearCheckbox(),
          _botonPlano(context, 'Aceptar', colorOrbittas, Colors.white),
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'login');
              },
              child: Text('Ya tengo una cuenta',
                  style: TextStyle(
                    color: colorOrbittas,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearCheckbox() {
    return CheckboxListTile(
        title: Text('Aceptar terminos'),
        value: !_bloquearCheck,
        onChanged: (valor) {
          setState(() {
            _bloquearCheck = !valor;
          });
        });
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

  Widget _crearNombre() {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 18.0, right: 18.0),
      child: TextField(
        //autofocus: true,
        textCapitalization: TextCapitalization.sentences,

        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          hintText: 'Nombre',
          labelText: 'Nombre',
          suffixIcon: Icon(Icons.person_outline),
          //icon: Icon(Icons.email)
        ),
        onChanged: (valor) {
          setState(() {});
          _firstName = valor;
        },
      ),
    );
  }

  Widget _crearApellido() {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 18.0, right: 18.0),
      child: TextField(
        //autofocus: true,
        textCapitalization: TextCapitalization.sentences,

        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          hintText: 'Apellido',
          labelText: 'Apellido',
          suffixIcon: Icon(Icons.security),
          //icon: Icon(Icons.email)
        ),
        onChanged: (valor) {
          setState(() {});
          _lastName = valor;
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
