import 'package:SDRV2_APP/constants.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_bloc.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_web_bloc.dart';
import 'package:SDRV2_APP/src/models/dispositivos_model.dart';
import 'package:SDRV2_APP/src/models/mqtt_models.dart';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:SDRV2_APP/src/provider/device_data_wrapper.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:SDRV2_APP/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:SDRV2_APP/src/provider/mqttClientWrapper.dart';
import 'package:mqtt_client/mqtt_client.dart';

class ManualPage extends StatefulWidget {
  @override
  _ManualPageState createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  final dispBloc = DispositivosWebBloc();
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  MQTTClientWrapper mqttClientWrapper;
  Color _color = Colors.white, _salidaColor = colorOrbittas;
  MqttProtocol sdrData = new MqttProtocol();
  int _seleccion = 2;
  String _topicIn = 'NoSeleccionado';
  String _topicOut = 'NoSeleccionado';
  String _dispositivoSeleccionado = '';

  @override
  void initState() {
    if (sdrData.estadoValvulas == null) {
      sdrData.estadoValvulas = [0, 0, 0, 0];
    }
    super.initState();
    dispBloc.obtenerDispositivos();
    if(prefs.dispositivoSeleccionado!=null)
    {_topicIn = 'SDR/${prefs.dispositivoSeleccionado}/out';
    _topicOut = 'SDR/${prefs.dispositivoSeleccionado}/in';}
    String _enviarDatos = '{"modo_activo":0}';
    setup(_enviarDatos, 0);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      sdrData = ModalRoute.of(context).settings.arguments;
    }
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                        'assets/manual.png',
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
                          'MANUAL',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        StreamBuilder(
                          stream: dispBloc.DispositivosStream,
                          //initialData: initialData ,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Dispositivo>> snapshot) {
                            if (!snapshot.hasData) {
                              return Text('No hay información...',style: TextStyle(fontSize: 18.0),);
                            }

                            final _dispositivos = snapshot.data;

                            if (_dispositivos.length == 0) {
                              return Center(
                                child: Text('No hay información',style: TextStyle(fontSize: 18.0),),
                              );
                            }

                            _dispositivos.forEach((dispositivo) {
                              if(prefs.dispositivoSeleccionado!=null){if (dispositivo.chipId ==
                                  prefs.dispositivoSeleccionado) {
                                _dispositivoSeleccionado =
                                    dispositivo.nombreDispositivo;
                                _topicOut = 'SDR/${dispositivo.chipId}/in';
                                _topicIn = 'SDR/${dispositivo.chipId}/out';
                              }}
                            });
                            return Text(_dispositivoSeleccionado,
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.start);
                          },
                        ),
                        
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 90.0, vertical: 10.0),
                  child: Text(
                    'Presione para encender',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
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
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomBar(_seleccion, sdrData),
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
          onTap: () {
            //{"estado_valvula":[4,0]}
            if ((sdrData.estadoValvulas[int.parse(salida) - 1]) != null) {
              String _dataOut =
                  '{"estado_valvula":[${int.parse(salida)},${sdrData.estadoValvulas[int.parse(salida) - 1]}]}';
              if (mqttClientWrapper.connectionState ==
                  MqttCurrentConnectionState.DISCONNECTED) {
                setup(_dataOut, 1);
              }

              if (mqttClientWrapper.connectionState ==
                  MqttCurrentConnectionState.CONNECTED) {
                mqttClientWrapper.subscribeToTopic(_topicIn);
                mqttClientWrapper.publishData(_dataOut, _topicOut);
              }
            }
          },
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
