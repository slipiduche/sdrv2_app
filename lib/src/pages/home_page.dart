import 'package:SDRV2_APP/constants.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_bloc.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_web_bloc.dart';
import 'package:SDRV2_APP/src/models/dispositivos_model.dart';
import 'package:SDRV2_APP/src/models/mqtt_models.dart';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:SDRV2_APP/src/provider/device_data_wrapper.dart';
import 'package:SDRV2_APP/src/provider/mqttClientWrapper.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:SDRV2_APP/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dispBloc = DispositivosWebBloc();
  final prefs = new PreferenciasUsuario();
  Color _color = Colors.white, _salidaColor = colorOrbittas;
  MqttProtocol sdrData = new MqttProtocol();
  MQTTClientWrapper mqttClientWrapper;
  int seleccion = 1, _modo;
  String _modoActivo = '', _proximoCiclo = '', _dispositivoSeleccionado = '';
  String _topicOut = 'NoSeleccionado';
  String _topicIn = 'NoSeleccionado';
  @override
  void initState() {
    if (sdrData.estadoValvulas == null) {
      sdrData.estadoValvulas = [0, 0, 0, 0];
    }
    super.initState();
    dispBloc.obtenerDispositivos();
    if (prefs.dispositivoSeleccionado != null) {
      _topicIn = 'SDR/${prefs.dispositivoSeleccionado}/out';
      _topicOut = 'SDR/${prefs.dispositivoSeleccionado}/in';
    }
    String _enviarDatos = '{"enviar_datos_completos":1}';
    setup(_enviarDatos, 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      sdrData = ModalRoute.of(context).settings.arguments;
    }
    if (sdrData.modoActivo == 1) {
      _modoActivo = 'AUTOMATICO';
    } else if (sdrData.modoActivo == 0) {
      _modoActivo = 'MANUAL';
    }
    if (sdrData.proximoCiclo != null) {
      _proximoCiclo = sdrData.proximoCiclo;
    }
    if (_modoActivo == '' &&
        (mqttClientWrapper.connectionState ==
            MqttCurrentConnectionState.CONNECTED)) {
      mqttClientWrapper.subscribeToTopic(_topicIn);
      mqttClientWrapper.publishData('{"enviar_datos_completos":1}', _topicOut);
    }
    // dispositivos.forEach((element) {
    //   if(prefs.dispositivoSeleccionado==Dispositivo.fromJson(element).chipId)
    //   {
    //   _dispositivoSeleccionado=Dispositivo.fromJson(element).nombreDispositivo;
    //   print(_dispositivoSeleccionado);
    //   }
    // });
    // _dispositivoSeleccionado=dispositivos['${prefs.dispositivoSeleccionado}'];
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ImageIcon(
                  AssetImage(
                    'assets/home.png',
                  ),
                  color: colorOrbittas,
                  size: 40.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOME',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.start,
                    ),
                    StreamBuilder(
                      stream: dispBloc.DispositivosStream,
                      //initialData: initialData ,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Dispositivo>> snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            'No hay información...',
                            style: TextStyle(fontSize: 18.0),
                          );
                        }

                        final _dispositivos = snapshot.data;

                        if (_dispositivos.length == 0) {
                          return Center(
                            child: Text(
                              'No hay información',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          );
                        }

                        _dispositivos.forEach((dispositivo) {
                          if (prefs.dispositivoSeleccionado != null) {
                            if (dispositivo.chipId ==
                                prefs.dispositivoSeleccionado) {
                              _dispositivoSeleccionado =
                                  dispositivo.nombreDispositivo;
                              _topicOut = 'SDR/${dispositivo.chipId}/in';
                              _topicIn = 'SDR/${dispositivo.chipId}/out';
                            }
                          }
                        });
                        return Text(_dispositivoSeleccionado,
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.start);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  _modoActivo,
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ),
          Container(
            height: 62.0,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            //padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: colorBordeBotton,
              //   width: 1.0,
              // ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: <BoxShadow>[boxShadow1],
            ),
            child: Container(
                //margin: EdgeInsets.symmetric(vertical: 2.0),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Próximo encendido',
                            style: TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _proximoCiclo,
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Table(
              children: [
                TableRow(children: [
                  _botonSalida('1', sdrData.estadoValvulas[0]),
                  _botonSalida('2', sdrData.estadoValvulas[1]),
                ]),
                TableRow(children: [
                  _botonSalida('3', sdrData.estadoValvulas[2]),
                  _botonSalida('4', sdrData.estadoValvulas[3]),
                ]),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: BottomBar(seleccion, sdrData),
      ),
    );
  }

  Widget _botonSalida(String salida, int estadoSalida) {
    if (estadoSalida == 1) {
      _color = colorOrbittas;
      _salidaColor = Colors.white;
    } else {
      _color = Colors.white;
      _salidaColor = colorOrbittas;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 120,
            width: 200,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: <BoxShadow>[boxShadow1],
              border: Border.all(
                color: colorBordeBotton,
                width: 1.0,
              ),
            ),
            child: Icon(
              Icons.power_settings_new,
              size: 100.0,
              color: _salidaColor,
            ),
          ),
        ),
        Text(
          'Salida $salida',
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }

  void setup(String dataOut, int ini) {
    if (sdrData.estadoValvulas == null) {
      sdrData.estadoValvulas = [0, 0, 0, 0];
    }
    // locationWrapper = LocationWrapper((newLocation) => mqttClientWrapper.publishLocation(newLocation));
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
