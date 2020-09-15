import 'package:SDRV2_APP/constants.dart';
import 'package:SDRV2_APP/src/models/mqtt_protocol_models.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  int seleccion;
  MqttProtocol _sdrData;
  BottomBar( this.seleccion ,this._sdrData);
  @override
  _BottomBarState createState() => _BottomBarState(seleccion,_sdrData);
}


class _BottomBarState extends State<BottomBar> {
  int seleccion;
  MqttProtocol _sdrData;
  _BottomBarState( this.seleccion ,this._sdrData);
  Color _color = Colors.transparent,_colorShadow=colorShadow;
  
  double _borderwidth=0.0;
  @override
  Widget build(BuildContext context) {
    return botomBar(context);
  }
  Widget botomBar(BuildContext context){
    return BottomNavigationBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png'),size: 40.0, ),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/manual.png'),size: 40.0, ),
            title: Text('Manual'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/auto.png'),size: 40.0, ),
            title: Text('Auto'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/perfil.png'),size: 40.0, ),
            title: Text('Cuenta'),
          ),
          
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: seleccion-1,
        selectedItemColor: colorOrbittas,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor:colorBordeBotton
        );
  }
  void _onItemTapped(int indice) async{
    
     //seleccion = index;
     print(indice);
          if (indice==2) {
            await Navigator.pushReplacementNamed(context, 'autoPage',arguments:_sdrData);
            
          }
          if (indice==1) {
            await Navigator.pushReplacementNamed(context, 'manualPage',arguments:_sdrData);
            
          }
          if (indice==0) {
           await  Navigator.pushReplacementNamed(context, 'homePage',arguments:_sdrData);
            
          }
          if (indice==3) {
           await  Navigator.pushReplacementNamed(context, 'perfilPage',arguments:_sdrData);
            
          }
          setState(() {
    });
  }

  Widget _botomBar(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    int _selected = 0;
    return Container(
      height: _screenSize.height * 0.08,
      width: double.infinity,
      color: colorBordeBotton,
      //margin: EdgeInsets.symmetric(horizontal:30.0),
      child: Center(
        child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal:5.0),
                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                            _iconoSeleccionado(1),
                            _iconoSeleccionado(2),
                            _iconoSeleccionado(3),
                            // _iconoSeleccionado(4),
                            //_iconoSeleccionado(5),
                            _iconoSeleccionado(6),]
                      ),
                    ),
                    Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _botonDeBar(ImageIcon(AssetImage('assets/home.png'),size: 30.0, color: Colors.white,), 'Home', 1),
              _botonDeBar(ImageIcon(AssetImage('assets/manual.png'),size: 30.0, color: Colors.white,), 'Manual', 2,),
              _botonDeBar(ImageIcon(AssetImage('assets/auto.png'),size: 30.0, color: Colors.white,), 'Auto', 3),
              // _botonDeBar(ImageIcon(AssetImage('assets/wifi.png'),size: 30.0, color: Colors.white,), 'Wifi', 4),
              // _botonDeBar(ImageIcon(AssetImage('assets/fecha.png'),size:30.0, color: Colors.white,), 'Fecha', 5),
              //_botonDeBar(Icon(Icons.code), 'Avanzado', 4),
              _botonDeBar(ImageIcon(AssetImage('assets/perfil.png'),size: 30.0, color: Colors.white,), 'Perfil', 6)
            ],
          ),
          ]
        ),
      ),
    );
  }

  Widget _botonDeBar(Widget icon, String texto, int indice) {
    if(seleccion==indice)
    {
      _color=colorOrbittas;
      _borderwidth=1.0;
      _colorShadow=colorShadow;
    }
    else{
      _color=Colors.transparent;
      _borderwidth=0.0;
      _colorShadow=Colors.transparent;
    }
    return GestureDetector(
      onTap: () {
        print(seleccion);
        
          
          print(indice);
          if (indice==3) {
            Navigator.pushNamed(context, 'autoPage');
            
          }
          if (indice==2) {
            Navigator.pushNamed(context, 'manualPage');
            
          }
          if (indice==1) {
            Navigator.pushNamed(context, 'homePage');
            
          }
          if (indice==6) {
            Navigator.pushNamed(context, 'perfilPage');
            
          }
          

        
      },
      child: Stack(
        children: [
        
        Container(
          //margin: EdgeInsets.symmetric(horizontal:5.0),
          width: 47,
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              Text(
                texto,
                style: TextStyle(color: Colors.white),textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _iconoSeleccionado(int indice) {
    if(seleccion==indice)
    {
      _color=colorOrbittas;
      _borderwidth=1.0;
      _colorShadow=colorShadow;
    }
    else{
      _color=Colors.transparent;
      _borderwidth=0.0;
      _colorShadow=Colors.transparent;
    }
    //_color = colorOrbittas;
    //_textColor=textColor;

    return Container(
      //color: _color,
      height: 70.0,
      width: 60.0,
      // duration: Duration(milliseconds: 150),
      // curve: Curves.fastOutSlowIn,
      //margin: EdgeInsets.only(top: 3.0,left: 1.0,right: 1.0),
      //padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: _color,
        border: Border.all(          color: colorBordeBotton,
          width: _borderwidth,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: _colorShadow,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(0.0, 2.0))//0,2.0
        ],
      ),
    );
  }
}


