import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';


MqttProtocol gestionDeDatos(MqttProtocol dataAnterior,MqttProtocol _data){

  if (_data.proximoCiclo != null) {
          dataAnterior.proximoCiclo = _data.proximoCiclo;
          print(dataAnterior.proximoCiclo);
        }
        if (_data.estadoValvulas != null) {
          dataAnterior.estadoValvulas = _data.estadoValvulas;
          print(dataAnterior.estadoValvulas);
        }
        
        if (_data.horarios != null) {
          dataAnterior.horarios = _data.horarios;
          print(dataAnterior.horarios);
        }
        if (_data.modoActivo != null) {
          dataAnterior.modoActivo = _data.modoActivo;
          print(dataAnterior.modoActivo);
        }
        if (_data.hora != null) {
          dataAnterior.hora= _data.hora;
          print(dataAnterior.hora);
        }
        if (_data.fecha != null) {
          dataAnterior.fecha= _data.fecha;
          print(dataAnterior.fecha);
        }

     


  return dataAnterior;



  

}