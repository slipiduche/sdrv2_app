
import 'dart:async';

import 'package:SDRV2_APP/src/models/dispositivos_model.dart';


class Validators {

  final validarId = StreamTransformer<List<Dispositivo>, List<Dispositivo>>.fromHandlers(
    handleData: ( dispositivos, sink ) {

      final idDispositivo = dispositivos.where( (s) => s.chipId.length == 12 ).toList();
      sink.add(idDispositivo);
    }
  );

  



}
