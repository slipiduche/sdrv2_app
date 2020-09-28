import 'dart:convert';


import 'package:SDRV2_APP/src/bloc/error_bloc.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final _errorBloc=ErrorBloc();

  final _prefs = new PreferenciasUsuario();


  Future<Map<String, dynamic>> login( String email, String password) async {

    final authData = {
      "email"    : email,
      "password" : password,
      
    };
    print(json.encode( authData ));
    final resp = await http.post(
      'http://orbittas.ddns.net:8081/api/deviceLogin',
      body: authData 
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('token') ) {
      
      _prefs.token = decodedResp['token'];
      _prefs.email=decodedResp['user'];
      if (_prefs.nombre=='')
      {_prefs.nombre=decodedResp['firstName'];}
      _prefs.userId=decodedResp['userId'];

      return { 'ok': true, 'token': decodedResp['token'] };
    } else {
      _errorBloc.errorStreamSink(decodedResp);
      return { 'ok': false, 'mensaje': decodedResp['message'] 
      };
      
    }

  }
  Future<Map<String, dynamic>> resetPaswword( String email) async {

    final authData = {
      "email"    : email
      
      
    };
    print(json.encode( authData ));
    final resp = await http.post(
      'http://orbittas.ddns.net:8081/api/device/password/reset/email',
      body: authData 
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp['Error'] ==false) {
      
      _errorBloc.errorStreamSink(decodedResp);
      return { 'ok': true, 'mensaje': decodedResp['message'] };
    } else {
      _errorBloc.errorStreamSink(decodedResp);
      return { 'ok': false, 'mensaje': decodedResp['message'] };
    }

  }


  Future<Map<String, dynamic>> nuevoUsuario( String email, String password ,String nombre, String apellido) async {

    final authData = {
      "email"    : email,
      "firstName": nombre,
      "lastName": apellido,
      "password" : password,
      
    };
    print(authData);

    final resp = await http.post(
      'http://orbittas.ddns.net:8081/api/deviceSignup',
      body: authData 
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp['Error'] ==false) {
      
      _errorBloc.errorStreamSink(decodedResp);
      return { 'ok': true, 'mensaje': decodedResp['message'] };
    } else {
      _errorBloc.errorStreamSink(decodedResp);
      return { 'ok': false, 'mensaje': decodedResp['message'] };
    }


  }
  Future<Map<String, dynamic>> editarUsuario( String email, String password ,String nombre, String apellido) async {

    final authData = {
      "email"    : email,
      "password" : password,
      "firstName": nombre,
     
      
    };

    final resp = await http.post(
      'http://orbittas.ddns.net:3333/api/signup',
      body: authData 
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp['Error'] ==false) {
      
      _errorBloc.errorStreamSink(decodedResp);
      return { 'ok': true, 'mensaje': decodedResp['message'] };
    } else {
      _errorBloc.errorStreamSink(decodedResp);
      return { 'ok': false, 'mensaje': decodedResp['message'] };
    }


  }


}