import 'dart:async';
import 'dart:math';

import 'package:SDRV2_APP/constants.dart';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:SDRV2_APP/src/provider/device_data_wrapper.dart';
import 'package:SDRV2_APP/src/provider/mqttClientWrapper.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';

//String _inputFieldDateController1 = '',_inputFieldDateController2 = '';
class ProgramPage extends StatefulWidget {
  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  String _topicIn = 'NoSeleccionado';
  String _topicOut = 'NoSeleccionado';
  MqttProtocol sdrData;
  MQTTClientWrapper mqttClientWrapper;
  int _selectedIndex = 2;
  ScrollController _scrollController = new ScrollController();
  int _seleccion = 3;
  String _cantidadDeHorarios = '1',
      _hora = '12:00',
      _cual = "",
      _cualBoton = '';
  bool _toggleBoton = false;
  Color _color = Colors.white, _textColor = Colors.black;
  List<String> _inputFieldDateController = [
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00',
    '12:00'
  ];
  List<int> diasSemana = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<List<bool>> diasBoolSemana = [
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false],
    [false, false, false, false, false, false, false, false]
  ];
  List<int> valAct = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<List<bool>> valBoolAct = [
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false]
  ];
  int horaAux,
      minAux,
      horaFinAux,
      minFinAux,
      diasAux,
      valAux,
      restaAux = 0,
      _ini = 2;

  cargarData(MqttProtocol data) {
    if (data.horarios != null) {
      for (var i = 0; i < data.horarios[0]; i++) {
        horaAux = data.horarios[6 * i + 1];
        minAux = data.horarios[6 * i + 2];
        horaFinAux = data.horarios[6 * i + 3];
        minFinAux = data.horarios[6 * i + 4];
        diasAux = data.horarios[6 * i + 5];
        valAux = data.horarios[6 * i + 6];
        diasSemana[i + 1] = diasAux;
        valAct[i + 1] = valAux;
        if (horaAux < 10) {
          _inputFieldDateController[i + i + 1] = '0$horaAux:';
        } else {
          _inputFieldDateController[i + i + 1] = '$horaAux:';
        }
        if (minAux < 10) {
          _inputFieldDateController[i + i + 1] += '0$minAux';
        } else {
          _inputFieldDateController[i + i + 1] += '$minAux';
        }
        if (horaFinAux < 10) {
          _inputFieldDateController[i + i + 2] = '0$horaFinAux:';
        } else {
          _inputFieldDateController[i + i + 2] = '$horaFinAux:';
        }
        if (minFinAux < 10) {
          _inputFieldDateController[i + i + 2] += '0$minFinAux';
        } else {
          _inputFieldDateController[i + i + 2] += '$minFinAux';
        }
        String decimalAbinario = diasAux.toRadixString(2);
        print(decimalAbinario.length);
        for (var dia = decimalAbinario.length; dia > 0; dia--) {
          print(decimalAbinario.substring(
              decimalAbinario.length - dia, decimalAbinario.length - dia + 1));
          if (decimalAbinario.substring(decimalAbinario.length - dia,
                  decimalAbinario.length - dia + 1) ==
              '1') {
            diasBoolSemana[i + 1][dia] = true;
          } else {
            diasBoolSemana[i + 1][dia] = false;
          }
        }
        decimalAbinario = valAux.toRadixString(2);
        print(decimalAbinario.length);
        for (var val = decimalAbinario.length; val > 0; val--) {
          print(decimalAbinario.substring(
              decimalAbinario.length - val, decimalAbinario.length - val + 1));
          if (decimalAbinario.substring(decimalAbinario.length - val,
                  decimalAbinario.length - val + 1) ==
              '1') {
            valBoolAct[i + 1][val] = true;
          } else {
            valBoolAct[i + 1][val] = false;
          }
        }
      }
    }
    print(_inputFieldDateController);
    print(diasBoolSemana);
  }

  @override
  // void initState() {
  //   super.initState();
  //   // _agregar10();
  //   _scrollController.addListener(() {
  //     print('_scrolllll');
  //     if (_scrollController.position.pixels ==
  //         _scrollController.position.maxScrollExtent) {
  //       //_agregar10();
  //       //fetchData();
  //     }
  //   });
  // }
  void initState() {
    super.initState();
    if (prefs.dispositivoSeleccionado != null) {
      _topicIn = 'SDR/${prefs.dispositivoSeleccionado}/out';
      _topicOut = 'SDR/${prefs.dispositivoSeleccionado}/in';
    }
    String _enviarDatos = '{"enviar_datos_completos":1}';
    _setup(_enviarDatos, 0);
  }

  void _setup(String dataOut, int ini) {
    // locationWrapper = LocationWrapper((newLocation) => mqttClientWrapper.publishLocation(newLocation));
    if (ini == 2) {
      if (ModalRoute.of(context).settings.arguments != null) {
        print('habia data');
        sdrData = ModalRoute.of(context).settings.arguments;
        if (sdrData.horarios != null) {
          _cantidadDeHorarios = sdrData.horarios[0].toString();
          if (sdrData.horarios[0] > 0) {
            cargarData(sdrData);
            print('habia data');
          }
          _ini = 1;
        }
      }
    } else if (ini == 0) {
      mqttClientWrapper = MQTTClientWrapper(() {
        mqttClientWrapper.publishData(dataOut, _topicOut);
      }, (deviceData, topic) {
        setState(() {
          if (topic == _topicIn) {
            sdrData = gestionDeDatos(sdrData, deviceData);
          }
        });
      });
      mqttClientWrapper.prepareMqttClient(_topicIn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setup('nada', _ini);
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            height: 150.0,
            width: double.infinity,
          ),
          _crearLista(context),
        ]),
      ),
    );
  }

  Widget _crearLista(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: (int.parse(_cantidadDeHorarios) + 2),
        itemBuilder: (BuildContext context, int index) {
          print(index);
          if (index == 0) {
            return Column(
              children: <Widget>[
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
                  height: 15.0,
                ),
                Text('ELEGIR CANTIDAD DE HORARIOS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    )),
                Container(
                    //padding: EdgeInsets.symmetric(vertical: 10.0),
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    child: _rowHorarios()),
              ],
            );
          } else if ((int.parse(_cantidadDeHorarios) + 1) == index) {
            return _botonGuardar('Guardar', colorOrbittas, Colors.white);
          } else {
            return _tarjetaHorarios((index).toString(), context);
          }
        });
  }

  Future<Null> _refresh() async {
    final duration = new Duration(milliseconds: 10);
    new Timer(duration, () {
      // _listaNumeros.clear();
      // _ultimoItem++;
      // _agregar10();
    });
    return Future.delayed(duration);
  }

  Widget _rowHorarios() {
    return Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: colorBordeBotton,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: colorShadow,
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: Offset(0, 2.0))
          ],
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 60.0),
          child: Table(
            children: [
              TableRow(children: [
                _botonHorario('1', Colors.white, Colors.black),
                _botonHorario('2', Colors.white, Colors.black),
                _botonHorario('3', Colors.white, Colors.black),
                _botonHorario('4', Colors.white, Colors.black),
              ]),
              TableRow(children: [
                _botonHorario('5', Colors.white, Colors.black),
                _botonHorario('6', Colors.white, Colors.black),
                _botonHorario('7', Colors.white, Colors.black),
                _botonHorario('8', Colors.white, Colors.black),
              ]),
            ],
          ),
        ));
  }

  Widget _botonHorario(String texto, Color color, textColor) {
    if (_cantidadDeHorarios != texto) {
      _textColor = textColor;
      _color = color;
    } else {
      _color = colorOrbittas;
      _textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        // print('$texto');
        setState(() {
          if (_cantidadDeHorarios != texto) {
            _cantidadDeHorarios = texto;
            // _color=colorOrbittas;
            // _textColor=Colors.white;
            print('$texto');
          }
        });
      },
      child: Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        //width: 10.0,
        // duration: Duration(milliseconds: 150),
        // curve: Curves.fastOutSlowIn,
        margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: _color,
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
                color: _textColor, fontSize: 20.0, fontFamily: 'Archivo'),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget _botonGuardar(String texto, Color color, textColor) {
    _color = color;
    _textColor = textColor;

    return GestureDetector(
      onTap: () {
        // print('$texto');

        print('Guardar');
        _enviarHorarios();
        Navigator.pushNamed(context, 'homePage');
      },
      child: Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        //width: 10.0,
        // duration: Duration(milliseconds: 150),
        // curve: Curves.fastOutSlowIn,
        margin:
            EdgeInsets.only(left: 25.0, right: 25.0, top: 3.0, bottom: 15.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: _color,
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
                color: _textColor, fontSize: 20.0, fontFamily: 'Archivo'),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget _tarjetaHorarios(String ciclo, BuildContext context) {
    return Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: colorBordeBotton,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: <BoxShadow>[boxShadow1],
        ),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Programación del ciclo $ciclo',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        width: 134.0,
                        margin: EdgeInsets.symmetric(horizontal: 31.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 10.0),
                        child: Text(
                          'Inicio',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 134.0,
                        margin: EdgeInsets.symmetric(horizontal: 31.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 10.0),
                        child: Text(
                          'Fin',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      _horarios(
                          context,
                          (int.parse(ciclo) + (int.parse(ciclo) - 1))
                              .toString()),
                      _horarios(context,
                          (int.parse(ciclo) + int.parse(ciclo)).toString())
                    ])
                  ],
                ),
              ),
              Text(
                'Días de ejecución',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
              Table(
                children: [
                  TableRow(children: [
                    _botonDias('1', Colors.white, ciclo),
                    _botonDias('2', Colors.white, ciclo),
                    _botonDias('3', Colors.white, ciclo),
                    _botonDias('4', Colors.white, ciclo),
                    _botonDias('5', Colors.white, ciclo),
                    _botonDias('6', Colors.white, ciclo),
                    _botonDias('7', Colors.white, ciclo)
                  ]),
                  TableRow(children: [
                    _textoDias('D'),
                    _textoDias('L'),
                    _textoDias('M'),
                    _textoDias('M'),
                    _textoDias('J'),
                    _textoDias('V'),
                    _textoDias('S'),
                  ]),
                ],
              ),
              Text(
                'Salidas',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 150.0),
                child: Table(
                  children: [
                    TableRow(children: [
                      _botonVal('1', Colors.white, ciclo),
                      _botonVal('2', Colors.white, ciclo),
                      _botonVal('3', Colors.white, ciclo),
                      _botonVal('4', Colors.white, ciclo),
                    ]),
                    TableRow(children: [
                      _textoVal('1'),
                      _textoVal('2'),
                      _textoVal('3'),
                      _textoVal('4'),
                    ]),
                  ],
                ),
              ),
            ])));
  }

  Widget _textoVal(String texto) {
    return Container(
      width: 134.0,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _textoDias(String texto) {
    return Container(
      width: 134.0,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _horarios(BuildContext context, String cual) {
    _inputFieldDateController[0] = _inputFieldDateController[int.parse(cual)];
    _cual = '';

    return Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        width: 134.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,

          //borderRadius: BorderRadius.circular(4.0),
          boxShadow: <BoxShadow>[boxShadow1],
        ),
        child: cajaHorario(context, cual));
  }

  void _selectHour(BuildContext context, String cual) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      helpText: '',
      initialTime: TimeOfDay.now(),
      confirmText: 'Seleccionar',
      cancelText: 'Cancelar',
    );
    if (picked != null) {
      setState(() {
        _hora = picked.toString().substring(10, picked.toString().length - 1);

        _inputFieldDateController[int.parse(cual)] = _hora;
        print(_inputFieldDateController[int.parse(cual)]);

        _cual = cual;
        print(_cual);
      });
    }
  }

  Widget cajaHorario(BuildContext context, String cual) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());

        _selectHour(context, cual);
      },
      child: Text(
        _inputFieldDateController[0],
        style: TextStyle(
            color: Colors.black, fontSize: 14.0, fontFamily: 'Archivo'),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _botonDias(String cual, Color color, String ciclo) {
    if (diasBoolSemana[int.parse(ciclo)][int.parse(cual)] == true) {
      _color = colorOrbittas;
    } else {
      _color = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        // print('$texto');
        setState(() {
          _toggleBoton = !_toggleBoton;
          _cualBoton = cual;
          print(_cualBoton);
          print(int.parse(ciclo));
          if (diasBoolSemana[int.parse(ciclo)][int.parse(cual)] == false) {
            diasSemana[int.parse(ciclo)] =
                diasSemana[int.parse(ciclo)] + (pow(2, (int.parse(cual)) - 1));
            diasBoolSemana[int.parse(ciclo)][int.parse(cual)] = true;
            print(diasSemana);
            print(diasBoolSemana);
          } else if (diasBoolSemana[int.parse(ciclo)][int.parse(cual)] ==
              true) {
            diasSemana[int.parse(ciclo)] =
                diasSemana[int.parse(ciclo)] - (pow(2, (int.parse(cual)) - 1));
            diasBoolSemana[int.parse(ciclo)][int.parse(cual)] = false;
            print(diasSemana);
            print(diasBoolSemana);
          }
        });
      },
      child: Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        //width: 10.0,
        // duration: Duration(milliseconds: 150),
        // curve: Curves.fastOutSlowIn,
        margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: _color,
          border: Border.all(
            color: colorBordeBotton,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: <BoxShadow>[boxShadow1],
        ),

        // child: Container()
      ),
    );
  }

  Widget _botonVal(String cual, Color color, String ciclo) {
    if (valBoolAct[int.parse(ciclo)][int.parse(cual)] == true) {
      _color = colorOrbittas;
    } else {
      _color = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        // print('$texto');
        setState(() {
          _toggleBoton = !_toggleBoton;
          _cualBoton = cual;
          print(_cualBoton);
          print(int.parse(ciclo));
          if (valBoolAct[int.parse(ciclo)][int.parse(cual)] == false) {
            valAct[int.parse(ciclo)] =
                valAct[int.parse(ciclo)] + (pow(2, (int.parse(cual)) - 1));
            valBoolAct[int.parse(ciclo)][int.parse(cual)] = true;
            print(valAct);
            print(valBoolAct);
          } else if (valBoolAct[int.parse(ciclo)][int.parse(cual)] == true) {
            valAct[int.parse(ciclo)] =
                valAct[int.parse(ciclo)] - (pow(2, (int.parse(cual)) - 1));
            valBoolAct[int.parse(ciclo)][int.parse(cual)] = false;
            print(valAct);
            print(valBoolAct);
          }
        });
      },
      child: Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        //width: 10.0,
        // duration: Duration(milliseconds: 150),
        // curve: Curves.fastOutSlowIn,
        margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: _color,
          border: Border.all(
            color: colorBordeBotton,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: <BoxShadow>[boxShadow1],
        ),

        // child: Container()
      ),
    );
  }

  void _enviarHorarios() {
    String horarios = 'horarios,$_cantidadDeHorarios,';
    for (var i = 0; i < int.parse(_cantidadDeHorarios); i++) {
      horarios +=
          '${int.parse(_inputFieldDateController[i + i + 1].substring(0, 2))},${int.parse(_inputFieldDateController[i + i + 1].substring(3, 5))},${int.parse(_inputFieldDateController[i + i + 2].substring(0, 2))},${int.parse(_inputFieldDateController[i + i + 2].substring(3, 5))},${diasSemana[i + 1]},${valAct[i + 1]},';
    }
    mqttClientWrapper.publishData(horarios, _topicOut);
    print(
        horarios); //[2, 0, 0, 11, 0, 6, 9, 22, 0, 23, 0, 24, 9] //horarios,2,0,0,11,0,6,9,22,0,23,0,24,9,//horarios,2,0,0,11,0,6,9,22,0,23,0,24,9,
  }
}
