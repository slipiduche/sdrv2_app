import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del Genero
  get genero {
    return _prefs.getInt('genero') ?? 1;
  }

  set genero( int value ) {
    _prefs.setInt('genero', value);
  }

  // GET y SET del _colorSecundario
  get colorSecundario {
    return _prefs.getBool('colorSecundario') ?? false;
  }

  set colorSecundario( bool value ) {
    _prefs.setBool('colorSecundario', value);
  }


  // GET y SET del nombreUsuario
  get dispositivoSeleccionado {
    return _prefs.getString('dispositivoSeleccionado') ?? null;
  }

  set dispositivoSeleccionado( String value ) {
    _prefs.setString('dispositivoSeleccionado', value);
  }

    // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

  // GET y SET del token
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }
  // GET y SET del nombre
  get nombre {
    return _prefs.getString('nombre') ?? '';
  }

  set nombre( String value ) {
    _prefs.setString('nombre', value);
  }
  // GET y SET del email
  get email {
    return _prefs.getString('email') ?? '';
  }

  set email( String value ) {
    _prefs.setString('email', value);
  }
  // GET y SET del userId
  get userId {
    return _prefs.getInt('userId') ?? '';
  }

  set userId( int value ) {
    _prefs.setInt('userId', value);
  }

  }


