import 'package:SDRV2_APP/src/bloc/dispositivos_bloc.dart';
import 'package:SDRV2_APP/src/bloc/dispositivos_web_bloc.dart';
import 'package:SDRV2_APP/src/models/dispositivos_model.dart';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:SDRV2_APP/src/provider/device_data_wrapper.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:SDRV2_APP/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:SDRV2_APP/constants.dart';

class AutoPage extends StatefulWidget {
  @override
  _AutoPageState createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  final dispBloc = DispositivosWebBloc();
  final prefs = new PreferenciasUsuario();
   String _topicIn = 'NoSeleccionado';
  String _topicOut = 'NoSeleccionado';
  String _dispositivoSeleccionado = '';
  MqttProtocol sdrData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dispBloc.obtenerDispositivos();
    if(prefs.dispositivoSeleccionado!=null)
    {_topicIn = 'SDR/${prefs.dispositivoSeleccionado}/out';
    _topicOut = 'SDR/${prefs.dispositivoSeleccionado}/in';}
  }
  @override
  Widget build(BuildContext context) {
    if( ModalRoute.of(context).settings.arguments!=null)
    {sdrData = ModalRoute.of(context).settings.arguments; }
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
                        Text(
                          'AUTOMATICO',
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
                              if(prefs.dispositivoSeleccionado!=null)
                              {if (dispositivo.chipId ==
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
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'progPage',arguments: sdrData);
                  },
                  child: Container(
                    height: 62.0,
                    width: 254.0,
                    margin: EdgeInsets.only(left: 40.0, right: 20.0),
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
                        margin: EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          'Programar',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'progPage',arguments: sdrData);
                  },
                  child: Container(
                    height: 50.0,
                    width: 60,
                    decoration: BoxDecoration(
                      color: colorOrbittas,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ImageIcon(AssetImage('assets/auto.png'),
                        color: Colors.white, size: 10.0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
              width: double.infinity,
            ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'programadoPage',arguments: sdrData);
                  },
                  child: Container(
                    height: 62.0,
                    width: 254.0,
                    margin: EdgeInsets.only(left: 40.0, right: 20.0),
                    //padding: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: <BoxShadow>[boxShadow1],
                    ),
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          'Horarios programados',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (sdrData.horarios!=null) {
                      Navigator.pushNamed(context, 'programadoPage',arguments: sdrData);
                    }
                    
                  },
                  child: Container(
                    height: 50.0,
                    width: 60,
                    decoration: BoxDecoration(
                      color: colorOrbittas,
                      // border: Border.all(
                      //   color: colorBordeBotton,
                      //   width: 1.0,
                      // ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ImageIcon(AssetImage('assets/prog.png'),
                        color: Colors.white, size: 10.0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
              width: double.infinity,
            ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'fechaPage',arguments: sdrData);
                  },
                  child: Container(
                    height: 62.0,
                    width: 254.0,
                    margin: EdgeInsets.only(left: 40.0, right: 20.0),
                    //padding: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: <BoxShadow>[boxShadow1],
                    ),
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        margin: EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          'Fecha y hora del dispositivo',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'fechaPage',arguments: sdrData);
                  },
                  child: Container(
                    height: 50.0,
                    width: 60,
                    decoration: BoxDecoration(
                      color: colorOrbittas,
                      // border: Border.all(
                      //   color: colorBordeBotton,
                      //   width: 1.0,
                      // ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ImageIcon(AssetImage('assets/fecha.png'),
                        color: Colors.white, size: 10.0),
                  ),
                )
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(3,sdrData),
      ),
    );
  }
}
