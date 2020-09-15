import 'package:SDRV2_APP/constants.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_bloc.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_web_bloc.dart';
import 'package:SDRV2_APP/src/models/dispositivos_model.dart';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:SDRV2_APP/src/provider/device_data_wrapper.dart';
import 'package:SDRV2_APP/src/provider/mqttClientWrapper.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class FechaPage extends StatefulWidget {
  @override
  _FechaPageState createState() => _FechaPageState();
}

class _FechaPageState extends State<FechaPage> {
  final dispBloc = DispositivosWebBloc();
  final prefs = new PreferenciasUsuario();
  int _selectedIndex = 2;
  ScrollController _scrollController = new ScrollController();
  int _seleccion = 3;
  String _cantidadDeHorarios = '8',
      _hora = '12:00',
      _fecha = '25/08/2020',
      _cual = "",
      _cualBoton = '';
  bool _toggleBoton = false;
  Color _color = Colors.white, _textColor = Colors.black;
  List<String> _inputFieldDateController = [
    '',
    '',
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
  String _topicIn = 'NoSeleccionado';
  String _topicOut = 'NoSeleccionado';
  String _dispositivoSeleccionado = '';
  MQTTClientWrapper mqttClientWrapper;
  
  MqttProtocol sdrData = new MqttProtocol();
  @override
  void initState() {
    
    super.initState();
    dispBloc.obtenerDispositivos();
     if(prefs.dispositivoSeleccionado!=null)
     {
     _topicIn='SDR/${prefs.dispositivoSeleccionado}/out';
     _topicOut='SDR/${prefs.dispositivoSeleccionado}/in';}
    String _enviarDatos = '{"enviar_datos_completos":1}';
    setup(_enviarDatos, 0);
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
          if (sdrData.fecha!=null) 
          {_inputFieldDateController[1]=sdrData.fecha;
           
            print(sdrData.fecha);
          }
          if (sdrData.hora!=null) 
          {_inputFieldDateController[0]=sdrData.hora;
            print(sdrData.hora);
            
          }
        }
      });
    });
    mqttClientWrapper.prepareMqttClient(_topicIn);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                      'assets/auto.png',
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
                    StreamBuilder(
                      stream: dispBloc.DispositivosStream,
                      //initialData: initialData ,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Dispositivo>> snapshot) {
                        if (!snapshot.hasData) {
                          return Text('No hay información...');
                        }

                        final _dispositivos = snapshot.data;

                        if (_dispositivos.length == 0) {
                          return Center(
                            child: Text('No hay información'),
                          );
                        }

                        _dispositivos.forEach((dispositivo) {
                          if(prefs.dispositivoSeleccionado!=null){
                          if (dispositivo.chipId ==
                              prefs.dispositivoSeleccionado) {
                            _dispositivoSeleccionado =
                                dispositivo.nombreDispositivo;
                                _topicOut='SDR/${dispositivo.chipId}/in';
                                _topicIn='SDR/${dispositivo.chipId}/out';
                          }}
                        });
                        return Text(_dispositivoSeleccionado,
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.start);
                      },
                    ),
                    Text(
                      'HOME',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            Text(
              'Modificar fecha y hora en dispositivo',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            _fechaFormulario(),
          ],
        ),
      ),
    );
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

        _inputFieldDateController[int.parse(cual)-1] = _hora;
        print(_inputFieldDateController[int.parse(cual)-1]);

        _cual = cual;
        print(_cual);
      });
    }
  }

  void _selectDate(BuildContext context, String cual) async {
    DateTime picked = await showDatePicker(
      context: context,
      helpText: '',
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2022),
      confirmText: 'Seleccionar',
      cancelText: 'Cancelar',
    );
    if (picked != null) {
      setState(() {
        _fecha =
            picked.toString(); //.substring(10, picked.toString().length - 1);

        _inputFieldDateController[int.parse(cual)-1] = _fecha;
        print(_inputFieldDateController[int.parse(cual)-1]);

        _cual = cual;
        print(_cual);
      });
    }
  }

  Widget cajaHorario(BuildContext context, String cual) {
    return Container(
      width: 142.0,
      height: 22.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,

        //borderRadius: BorderRadius.circular(4.0),
        boxShadow: <BoxShadow>[
          boxShadow1
        ],
      ),
      child: GestureDetector(
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
      ),
    );
  }

  Widget cajaFecha(BuildContext context, String cual) {
    return Container(
      width: 142.0,
      height: 22.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,

        //borderRadius: BorderRadius.circular(4.0),
        boxShadow: <BoxShadow>[
          boxShadow1
        ],
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());

          _selectDate(context, cual);
        },
        child: Text(
          _inputFieldDateController[1],
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontFamily: 'Archivo'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _botonGuardar(String texto, Color color, textColor) {
    _color = color;
    _textColor = textColor;

    return GestureDetector(
      onTap: () {
        // print('$texto');
        if ((_inputFieldDateController[0]!='')&&(_inputFieldDateController[1]!='')) 
        {String data='{"FechaYHora":[${_inputFieldDateController[0]},${_inputFieldDateController[1]}]}';
        mqttClientWrapper.publishData(data, _topicOut);}
        setState(() {
          print('Guardar');
        });
      },
      child: Container(
        //color: colorResaltadoBoton,
        //height: 50.0,
        width: double.infinity,
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

  Widget _fechaFormulario() {
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
      child: Column(
        children: [
          Text('Asignar hora',
              style: TextStyle(
                  color: Colors.black, fontSize: 18.0, fontFamily: 'Archivo')),
          cajaHorario(context, "1"),
          Text('Asignar fecha',
              style: TextStyle(
                  color: Colors.black, fontSize: 18.0, fontFamily: 'Archivo')),
          cajaFecha(context, '2'),
          _botonGuardar('Guardar', colorOrbittas, Colors.white)
        ],
      ),
    );
  }
}
