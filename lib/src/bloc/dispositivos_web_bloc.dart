import 'dart:async';

import 'package:SDRV2_APP/src/bloc/error_bloc.dart';
import 'package:SDRV2_APP/src/bloc/validator.dart';
import 'package:SDRV2_APP/src/provider/db_web_provider.dart';

class DispositivosWebBloc with Validators {
  static final DispositivosWebBloc _singleton =
      new DispositivosWebBloc._internal();

  factory DispositivosWebBloc() {
    return _singleton;
  }

  DispositivosWebBloc._internal() {
    obtenerDispositivos();
  }

  final _DispositivosController =
      StreamController<List<Dispositivo>>.broadcast();

  Stream<List<Dispositivo>> get DispositivosStreamIdcorrecto =>
      _DispositivosController.stream.transform(validarId);
  Stream<List<Dispositivo>> get DispositivosStream =>
      _DispositivosController.stream;

  dispose() {
    _DispositivosController?.close();
  }

  obtenerDispositivos() async {
    _DispositivosController.sink
        .add(await DBWebProvider.db.getTodosDispositivos());
  }

  Future<Map<String, dynamic>> agregarDispositivo(
      Dispositivo dispositivo) async {
    final _resp = await DBWebProvider.db.nuevoDispositivo(dispositivo);
    obtenerDispositivos();
    return _resp;
  }

  Future<Map<String, dynamic>> editarDispositivo(
      Dispositivo dispositivo) async {
    final _resp = await DBWebProvider.db.updateDispositivo(dispositivo);
    obtenerDispositivos();
    return _resp;
  }

  Future<Map<String, dynamic>> borrarDispositivo(
      Dispositivo dispositivo) async {
    final _resp = await DBWebProvider.db.deleteDispositivo(dispositivo);
    obtenerDispositivos();
    return _resp;
  }

  borrarDispositivoTODOS() async {
    await DBWebProvider.db.deleteAll();
    obtenerDispositivos();
  }
}
