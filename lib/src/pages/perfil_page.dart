import 'package:SDRV2_APP/constants.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_bloc.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_web_bloc.dart';
import 'package:SDRV2_APP/src/models/dispositivos_model.dart';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:SDRV2_APP/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  TextEditingController _nuevoDispositivo;
  final dispBloc = DispositivosWebBloc();
  String _nombreNuevo, _macNueva;
  List<Dispositivo> listaDispositivos;
  List<int> _agregados = [];
  int conteo = 0;
  bool noAgregar = false;

  final prefs = new PreferenciasUsuario();
  int seleccion = 4;
  String _nombre = 'Orbittas', _email = 'alejandro@orbittas.com';
  dynamic _opcionSeleccionada;
  MqttProtocol sdrData;
  @override
  void initState() {
    super.initState();

    dispBloc.obtenerDispositivos();

    _opcionSeleccionada = prefs.dispositivoSeleccionado;
    _nombre = prefs.nombre;
    _email = prefs.email;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Center(
                child: ImageIcon(
                  AssetImage(
                    'assets/orbittas.png',
                  ),
                  color: colorOrbittas,
                  size: 40.0,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 23.0, horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ImageIcon(
                      AssetImage(
                        'assets/perfil.png',
                      ),
                      color: colorOrbittas,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      _nombre,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(child: Container()),
                    // Container(
                    //   height: 25.0,
                    //   width: 150.0,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(2.0),
                    //     color: colorOrbittas,
                    //     boxShadow: <BoxShadow>[boxShadow1],
                    //   ),
                    //   child: Text(
                    //     'Cuenta XXX',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: Colors.white, fontSize: 20.0),
                    //   ),
                    // )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre',
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    _tarjetaNombre(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Email',
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    _tarjetaEmail(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Dispositivos',
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    _agregarNuevoDispositivo(context),
                    _crearDropdownStream(context), //_crearDropdown(),
                    SizedBox(
                      height: 40.0,
                    ),
                    _botoAyudaApp('Ayuda', 'Preguntas frecuentes'),
                    _botoAyudaApp('APP   ', 'Acerca de'),
                    _botonLogout(context),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomBar(seleccion, sdrData),
      ),
    );
  }

  Widget _tarjetaNombre() {
    return Container(
      height: 33.0,
      width: 260.0,
      padding: EdgeInsets.only(top: 1.0, left: 18.0, right: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: <BoxShadow>[boxShadow1],
      ),
      child: TextField(
        //autofocus: true,
        //textCapitalization: TextCapitalization.sentences,

        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _nombre,
          //labelText: 'Email',
          suffixIcon: ImageIcon(AssetImage('assets/edit.png')),
          //icon: Icon(Icons.email)
        ),
        onChanged: (valor) {
          setState(() {});
          _nombre = valor;
        },
        onSubmitted: (valor) {
          prefs.nombre = valor;
        },
      ),
    );
  }

  Widget _tarjetaEmail() {
    return Container(
      height: 33.0,
      width: 260.0,
      padding: EdgeInsets.only(top: 1.0, left: 18.0, right: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: <BoxShadow>[boxShadow1],
      ),
      child: TextField(
        //autofocus: true,
        //textCapitalization: TextCapitalization.sentences,
        enabled: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _email,
          //labelText: 'Email',
          //suffixIcon: ImageIcon(AssetImage('assets/edit.png')),
          //icon: Icon(Icons.email)
        ),
        onChanged: null,
        // onChanged: (valor) {
        //   setState(() {});
        //   _nombre = valor;
        // },
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = new List();
    //List<Dispositivo> _dispositivos=dispositivos;
    // _dispositivos.forEach((dispositivo) {
    //   lista.add(DropdownMenuItem(
    //     child: Text('${dispositivo.nombreDispositivo} ...${dispositivo.chipId.substring(0,4)}'),
    //     value: dispositivo.chipId,
    //   ));
    // });

    return lista;
  }

  List<DropdownMenuItem<String>> getOpcionesDropdownStream(
      List<Dispositivo> dispositivos) {
    List<DropdownMenuItem<String>> lista = new List();

    dispositivos.forEach((dispositivo) {
      _agregados.forEach((element) {
        if (element == dispositivo.id) {
          return noAgregar = true;
        } else {
          noAgregar = false;
        }
      });
      if ((dispositivo.chipId != null)) {
        lista.add(DropdownMenuItem(
          child: Text(
              '${dispositivo.nombreDispositivo} ...${dispositivo.chipId.substring(0, 4)}'),
          value: dispositivo.chipId,
        ));
        _agregados.insert(_agregados.length, dispositivo.id); //
        conteo++;
      }
    });

    return lista;
  }

  Widget _crearDropdownStream(BuildContext context) {
    return StreamBuilder(
      stream: dispBloc.DispositivosStream,
      builder: (context, AsyncSnapshot<List<Dispositivo>> snapshot) {
        if (!snapshot.hasData) {
          return Text('No hay información...');
        }

        final _dispositivos = snapshot.data;

        if (_dispositivos.length == 0) {
          return Center(
            child: Text('No hay información'),
          );
        }
        //_opcionSeleccionada=prefs.dispositivoSeleccionado;
        return Container(
          child: Row(
            children: [
              _crearDropdown(_dispositivos),
              //Expanded(child: Container()),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    print('edit');
                    Dispositivo _seleccionado;
                    _dispositivos.forEach((element) {
                      if (element.chipId == _opcionSeleccionada) {
                        return _seleccionado = element;
                      }
                    });
                    if (_seleccionado.id != null) {
                      _opcionSeleccionada = null;
                      prefs.dispositivoSeleccionado = null;
                      _mostrarEdit(context, _seleccionado);
                    }
                  }),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Dispositivo _seleccionado;
                    _dispositivos.forEach((element) {
                      if (element.chipId == _opcionSeleccionada) {
                        return _seleccionado = element;
                      }
                    });
                    print('delete');
                    if (_seleccionado.id != null) {
                      prefs.dispositivoSeleccionado = null;
                      _opcionSeleccionada = null;
                      _mostrarDelete(context, _seleccionado);
                    }
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _crearDropdown(List<Dispositivo> dispositivo) {
    return Expanded(
      child: Container(
        //width: double.infinity,
        margin: EdgeInsets.only(right: 15.0),
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[boxShadow1],
        ),
        child: DropdownButton(
            isExpanded: true,
            underline: DropdownButtonHideUnderline(
                child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: colorShadow,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0, 2.0))
                ],
              ),
            )),
            value: _opcionSeleccionada,
            items: getOpcionesDropdownStream(dispositivo),
            onChanged: (opt) {
              print(opt);
              setState(() {
                _opcionSeleccionada = opt;
                prefs.dispositivoSeleccionado = _opcionSeleccionada;
              });
            }),

        // SizedBox(width: 15.0),
        //Icon(Icons.select_all),
      ),
    );
  }

  Widget _agregarNuevoDispositivo(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Agregar uno nuevo',
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(
            width: 5.0,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  _mostrarFormulario(context);
                  print('mostrar formulario');
                });
              },
              child: Icon(Icons.add_circle_outline))
        ],
      ),
    );
  }

  Widget _mostrarFormulario(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //title: Container(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start,

                              // mainAxisSize: MainAxisSize.min,
                              children: [
                            Text('Nombre del Dispositivo'),
                            _deviceInput('Dispositivo1', 'Dispositivo1'),
                            Text('ChipId'),
                            _deviceInput('MAC', 'ChipId'),
                          ]),
                    ),
                    SizedBox(width: 20.0),
                    Icon(Icons.add_circle_outline)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancelar',
                            style: TextStyle(color: Colors.white))),
                    SizedBox(width: 10.0),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () async {
                          Dispositivo _nuevoDispositivo = Dispositivo(
                              chipId: _macNueva,
                              nombreDispositivo: _nombreNuevo);
                          _esperando(context);

                          final resp = await dispBloc
                              .agregarDispositivo(_nuevoDispositivo);
                          Navigator.pop(context);
                          if (resp["Error"] == false) {
                            prefs.dispositivoSeleccionado = null;
                            _opcionSeleccionada = null;
                            setState(() {});
                            Navigator.of(context).pop();
                            _agregado(context);
                          } else {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  elevation: 5.0,
                                  title: Center(child: Text('Error')),
                                  content: Container(
                                    child: Text(
                                      resp["message"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ));
                          }
                        },
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _mostrarDelete(BuildContext context, Dispositivo seleccionado) {
    final _screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //title: Container(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start,

                              // mainAxisSize: MainAxisSize.min,
                              children: [
                            Text('Nombre del Dispositivo'),
                            _deviceText(seleccionado.nombreDispositivo),
                            Text('MAC'),
                            _deviceText(seleccionado.chipId),
                          ]),
                    ),
                    SizedBox(width: 20.0),
                    Icon(Icons.delete)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () {
                          prefs.dispositivoSeleccionado = null;
                          _opcionSeleccionada = null;
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar',
                            style: TextStyle(color: Colors.white))),
                    SizedBox(width: 10.0),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () async {
                          _esperando(context);

                          final resp =
                              await dispBloc.borrarDispositivo(seleccionado);
                          Navigator.pop(context);
                          if (resp["Error"] == false) {
                            prefs.dispositivoSeleccionado = null;
                            _opcionSeleccionada = null;
                            _agregados.clear();

                            Navigator.of(context).pop();
                            setState(() {});
                            _eliminado(context);
                          } else {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  elevation: 5.0,
                                  title: Center(child: Text('Error')),
                                  content: Container(
                                    child: Text(
                                      resp["message"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ));
                          }
                        },
                        child: Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _mostrarEdit(BuildContext context, Dispositivo seleccionado) {
    final _screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //title: Container(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start,

                              // mainAxisSize: MainAxisSize.min,
                              children: [
                            Text('Nombre del Dispositivo'),
                            _deviceInput(
                                'Nombre', seleccionado.nombreDispositivo),
                            Text('MAC'),
                            _deviceInput('MAC', seleccionado.chipId),
                          ]),
                    ),
                    SizedBox(width: 20.0),
                    ImageIcon(AssetImage('assets/edit.png'))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () {
                          prefs.dispositivoSeleccionado = null;
                          _opcionSeleccionada = null;
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar',
                            style: TextStyle(color: Colors.white))),
                    SizedBox(width: 10.0),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () async {
                          Dispositivo _nuevoDispositivo = Dispositivo(
                              id: seleccionado.id,
                              chipId: _macNueva,
                              nombreDispositivo: _nombreNuevo);
                          _esperando(context);
                          final resp = await dispBloc
                              .editarDispositivo(_nuevoDispositivo);
                          Navigator.pop(context);
                          if (resp["Error"] == false) {
                            _agregados.clear();
                            prefs.dispositivoSeleccionado = null;
                            _opcionSeleccionada = null;
                            setState(() {});
                            Navigator.of(context).pop();
                            _agregado(context);
                          } else {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  elevation: 5.0,
                                  title: Center(child: Text('Error')),
                                  content: Container(
                                    child: Text(
                                      resp["message"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ));
                          }
                        },
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _esperando(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //title: Container(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Container(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator()),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          );
        });
  }

  Widget _agregado(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //title: Container(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Se agregó el dispositivo'),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Aceptar',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _deviceText(String hintText) {
    return Container(
        // width: _screenSize.width -48.0,
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorBordeBotton,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Text(
          hintText,
          textAlign: TextAlign.left,
        ));
  }

  Widget _deviceInput(String hintText, String textValue) {
    _nuevoDispositivo = new TextEditingController(text: textValue);
    if (hintText == 'MAC') {
      _macNueva = textValue;
    } else {
      _nombreNuevo = textValue;
    }

    return Container(
        // width: _screenSize.width -48.0,
        //padding: EdgeInsets.all(25.0),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorBordeBotton,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: TextField(
          //autofocus: true,
          //textCapitalization: TextCapitalization.sentences,
          controller: _nuevoDispositivo,
          scrollPadding: EdgeInsets.all(5.0),

          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          ),
          onChanged: (valor) {
            _opcionSeleccionada = null;
            prefs.dispositivoSeleccionado = null;
            if (hintText == 'MAC') {
              _macNueva = valor;
            } else {
              _nombreNuevo = valor;
            }
            setState(() {});
          },
        ));
  }

  Widget _botoAyudaApp(String texto1, texto2) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            texto1,
            textAlign: TextAlign.start,
          ),
          SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              if (texto1.contains('APP')) {
                Navigator.pushNamed(context, 'aboutPage');
              }
              if (texto1.contains('Ayuda')) {
                Navigator.pushNamed(context, 'faqPage');
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              height: 33.0,
              width: 185.0,
              child: Text(
                texto2,
                textAlign: TextAlign.start,
              ),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[boxShadow1],
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _eliminado(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //title: Container(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Se eliminó el dispositivo'),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        color: colorOrbittas,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Aceptar',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _botonLogout(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50.0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => _cerrarSesion(context),
              child: Icon(
                Icons.exit_to_app,
                color: colorOrbittas,
                size: 40.0,
              )),
          Text('Salir'),
        ],
      ),
    );
  }

  void _cerrarSesion(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          content: Text('¿Seguro que desea salir?'),
          actions: [
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                color: colorOrbittas,
                onPressed: () => Navigator.of(context).pop(),
                child: Text('No', style: TextStyle(color: Colors.white))),
            SizedBox(width: 10.0),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                color: colorOrbittas,
                onPressed: () {
                  Dispositivo _nuevoDispositivo = Dispositivo(
                      chipId: _macNueva, nombreDispositivo: _nombreNuevo);

                  prefs.token = '';
                  prefs.dispositivoSeleccionado = null;
                  _opcionSeleccionada = null;
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: Text(
                  'Si',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ));
  }
}
