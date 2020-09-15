import 'dart:async';


import 'package:SDRV2_APP/src/bloc/validator.dart';



class ErrorBloc with Validators {
  
  static final ErrorBloc _singleton = new ErrorBloc._internal();

  factory ErrorBloc() {
    return _singleton;
  }

  ErrorBloc._internal ()  {
    
  }
  

  final _ErrorController = StreamController<Map<String,dynamic>>.broadcast();

  
  Stream<Map<String,dynamic>> get ErrorStream => _ErrorController.stream;
  
  Function (Map<String,dynamic>) get errorStreamSink => _ErrorController.sink.add;
  Function (Map<String,dynamic>) get errorStreamAddError => _ErrorController.sink.addError;

  dispose() {
    _ErrorController?.close();
  }
}