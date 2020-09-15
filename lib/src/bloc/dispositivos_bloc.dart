import 'dart:async';

import 'package:SDRV2_APP/src/bloc/validator.dart';
import 'package:SDRV2_APP/src/provider/db_provider.dart';


class DispositivosBloc with Validators {

  static final DispositivosBloc _singleton = new DispositivosBloc._internal();

  factory DispositivosBloc() {
    return _singleton;
  }

  DispositivosBloc._internal() {
    obtenerDispositivos();
  }

  final _DispositivosController = StreamController<List<Dispositivo>>.broadcast();

  Stream<List<Dispositivo>> get DispositivosStreamIdcorrecto     => _DispositivosController.stream.transform(validarId);
  Stream<List<Dispositivo>> get DispositivosStream => _DispositivosController.stream;


  dispose() {
    _DispositivosController?.close();
  }

  obtenerDispositivos() async {
    _DispositivosController.sink.add( await DBProvider.db.getTodosDispositivos()  );
  }

  agregarDispositivo( Dispositivo dispositivo ) async{
    await DBProvider.db.nuevoDispositivo(dispositivo);
    obtenerDispositivos();
  }
  editarDispositivo( Dispositivo dispositivo ) async{
    await DBProvider.db.updateDispositivo(dispositivo);
    obtenerDispositivos();
  }

  borrarDispositivo( int id ) async {
    await DBProvider.db.deleteDispositivo(id);
    obtenerDispositivos();
  }

  borrarDispositivoTODOS() async {
    
    await DBProvider.db.deleteAll();
    obtenerDispositivos();
  }


}
