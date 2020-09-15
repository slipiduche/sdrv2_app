import 'package:SDRV2_APP/src/pages/iniciando_page.dart';
import 'package:SDRV2_APP/src/pages/login_page.dart';
import 'package:flutter/material.dart';

import 'package:SDRV2_APP/src/share_prefs/preferencias_usuario.dart';
import 'package:SDRV2_APP/src/routes/routes.dart';


void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
 

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'iniciandoPage',
      routes: getAppRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        print('ruta llamada ${settings.name}');
        //Navigator.pop(context);
        return MaterialPageRoute(builder: (BuildContext context) => LoginPage());
      },
    );
  }
}
