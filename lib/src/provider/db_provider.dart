import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:SDRV2_APP/src/models/dispositivos_model.dart';
export 'package:SDRV2_APP/src/models/dispositivos_model.dart';



class DBProvider {

  static Database _database; 
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }


  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'DispositivosDB.db' );

    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Dispositivos ('
          ' id INTEGER PRIMARY KEY,'
          ' nombreDispositivo TEXT,'
          ' chipId TEXT'
          ')'
        );
      }
    
    );

  }

  // CREAR Registros
  nuevoScanRaw( Dispositivo nuevoDispositivo ) async {

    final db  = await database;

    final res = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES ( ${ nuevoDispositivo.id }, '${ nuevoDispositivo.nombreDispositivo }', '${ nuevoDispositivo.chipId }' )"
    );
    return res;

  }

  nuevoDispositivo( Dispositivo nuevoDispositivo) async {

    final db  = await database;
    final res = await db.insert('Dispositivos',  nuevoDispositivo.toJson() );
    print('se almacenó $res');
    return res;
  }


  // SELECT - Obtener información
  Future<Dispositivo> getDispositivoId( int id ) async {

    final db  = await database;
    final res = await db.query('Dispositivos', where: 'id = ?', whereArgs: [id]  );
    return res.isNotEmpty ? Dispositivo.fromJson( res.first ) : null;

  }

  Future<List<Dispositivo>> getTodosDispositivos() async {

    final db  = await database;
    final res = await db.query('Dispositivos');

    List<Dispositivo> list = res.isNotEmpty 
                              ? res.map( (c) => Dispositivo.fromJson(c) ).toList()
                              : [];
    return list;
  }

  Future<List<Dispositivo>> getDispositivoPorTipo( String tipo ) async {

    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM Dispositivos WHERE tipo='$tipo'");

    List<Dispositivo> list = res.isNotEmpty 
                              ? res.map( (c) => Dispositivo.fromJson(c) ).toList()
                              : [];
    return list;
  }

  // Actualizar Registros
  Future<int> updateDispositivo( Dispositivo nuevoDispositivo ) async {

    final db  = await database;
    final res = await db.update('Dispositivos', nuevoDispositivo.toJson(), where: 'id = ?', whereArgs: [nuevoDispositivo.id] );
    return res;

  }

  // Eliminar registros
  Future<int> deleteDispositivo( int id ) async {

    final db  = await database;
    final res = await db.delete('Dispositivos', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {

    final db  = await database;
    final res = await db.rawDelete('DELETE FROM Dispositivos');
    return res;
  }

}

