import 'package:SDRV2_APP/src/pages/fecha_page.dart';
import 'package:SDRV2_APP/src/pages/resetPassword_page.dart';
import 'package:flutter/material.dart';
import 'package:SDRV2_APP/src/pages/iniciando_page.dart';
import 'package:SDRV2_APP/src/pages/login_page.dart';
import 'package:SDRV2_APP/src/pages/createAcount_page.dart';
import 'package:SDRV2_APP/src/pages/programacion_page.dart';
import 'package:SDRV2_APP/src/pages/manual_page.dart';
import 'package:SDRV2_APP/src/pages/auto_page.dart';
import 'package:SDRV2_APP/src/pages/home_page.dart';
import 'package:SDRV2_APP/src/pages/about_page.dart';
import 'package:SDRV2_APP/src/pages/perfil_page.dart';
import 'package:SDRV2_APP/src/pages/faq_page.dart';
import 'package:SDRV2_APP/src/pages/programado_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return <String, WidgetBuilder>{
    'iniciandoPage': (BuildContext context) => IniciandoPage(),
    'login': (BuildContext context) => LoginPage(),
    'createUser': (BuildContext context) => CreateAcountPage(),
    'progPage': (BuildContext context) => ProgramPage(),
    'manualPage': (BuildContext context) => ManualPage(),
    'autoPage': (BuildContext context) => AutoPage(),
    'homePage': (BuildContext context) => HomePage(),
    'perfilPage': (BuildContext context) => PerfilPage(),
    'aboutPage': (BuildContext context) => AboutPage(),
    'faqPage': (BuildContext context) => FaqPage(),
    'programadoPage': (BuildContext context) => ProgramadoPage(),
    'fechaPage': (BuildContext context) => FechaPage(),
    'resetPasswordPage': (BuildContext context) => ResetPasswordPage()
  };
}
