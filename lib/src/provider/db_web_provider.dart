import 'dart:convert';
import 'dart:io';

import 'package:SDRV2_APP/src/bloc/error_bloc.dart';
import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';


import 'package:SDRV2_APP/src/models/dispositivos_model.dart';
export 'package:SDRV2_APP/src/models/dispositivos_model.dart';

import 'package:http/http.dart' as http;


class DBWebProvider {
  
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  static Map<String, dynamic> _database; 
  static final DBWebProvider db = DBWebProvider._();
  final _errorBloc=ErrorBloc();

  DBWebProvider._();

  Future<Map<String, dynamic>> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }


  initDB() async {

    

  }

  // CREAR Registros
  

  Future <Map<String, dynamic>> nuevoDispositivo( Dispositivo nuevoDispositivo) async {
    

    final _url='http://orbittas.ddns.net:8081/api/deviceStore?mac_address=${nuevoDispositivo.chipId}&description=${nuevoDispositivo.nombreDispositivo}&token=${prefs.token}&userId=${prefs.userId}';

    final resp = await http.post(
      _url,
      body: jsonEncode(null)
    );
    final res=jsonDecode(resp.body);
    //final res=null;
    print('se almacenó $res');
    _errorBloc.errorStreamSink(res);
    return res;
  }


  // SELECT - Obtener información
  Future<Dispositivo> getDispositivoId( int id ) async {

    final db  = await database;
    final res=null;
    return res.isNotEmpty ? Dispositivo.fromJson( res.first ) : null;

  }

  Future<List<Dispositivo>> getTodosDispositivos() async {

    //final db  = await database;
    // final authData = {
    //   'email'    : email,
    //   'password' : password,
    //   'returnSecureToken' : true
    // };
    final _url='http://orbittas.ddns.net:8081/api/confirmDevice?token=${prefs.token}';

    final resp = await http.post(
      _url,
      body: json.encode( null )
    );
    final res=jsonDecode(resp.body);

    List<Dispositivo> list=[];
    if( res.isNotEmpty )
    {
      final _disps=res["dispositivos"];
      if (_disps!=null) {
        _disps.forEach((value) {
       print(value);
      if(Dispositivo.fromJson(value)!=null)
      {
        list.add(Dispositivo.fromJson(value));
      }      
    });
        
      }
      else
      {
        if (res["Error"]==true)
        {
          list=[];
          
          
        }
      }
    
                                 
    }
    else
    {                            
     list=[];}
     _errorBloc.errorStreamSink(res);
    return list;
  }

  Future<List<Dispositivo>> getDispositivoPorTipo( String tipo ) async {

    final db  = await database;
    final res=null;
    List<Dispositivo> list = res.isNotEmpty 
                              ? res.map( (c) => Dispositivo.fromJson(c) ).toList()
                              : [];
    return list;
  }

  // Actualizar Registros
  Future<Map<String, dynamic>> updateDispositivo( Dispositivo nuevoDispositivo ) async {

    
    final _url='http://orbittas.ddns.net:8081/api/deviceUpdate?mac_address=${nuevoDispositivo.chipId}&description=${nuevoDispositivo.nombreDispositivo}&token=${prefs.token}&userId=${prefs.userId}&deviceId=${nuevoDispositivo.id}&_method=put';

    final resp = await http.post(
      _url,
      body: jsonEncode(null)
    );
    print(resp);
    final res=jsonDecode(resp.body);
    //final res=null;
    print('se actualizo');
    print(res);
    _errorBloc.errorStreamSink(res);
    return res;
  

  }

  // Eliminar registros
  Future<Map<String,dynamic>> deleteDispositivo( Dispositivo nuevoDispositivo ) async {

    
    final _url='http://orbittas.ddns.net:8081/api/deviceDestroy?mac_address=${nuevoDispositivo.chipId}&description=${nuevoDispositivo.nombreDispositivo}&token=${prefs.token}&userId=${prefs.userId}&_method=delete';

    final resp = await http.post(
      _url,
      body: jsonEncode(null)
    );
    print(resp);
    final res=jsonDecode(resp.body);
    //final res=null;
    print('se elimino');
    print(res);
    _errorBloc.errorStreamSink(res);
    return res;
  
  }

  Future<int> deleteAll() async {

    final db  = await database;
    final res=null;
    return res;
  }

}

