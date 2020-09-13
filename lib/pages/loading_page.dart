import 'package:flutter/material.dart';

// Lib
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Helpers
import 'package:maps_app/helpers/helpers.dart';

// Pages 
import 'package:maps_app/pages/acceso_gps_page.dart';
import 'package:maps_app/pages/mapa_page.dart';


class LoadingPage extends StatefulWidget {

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() { 
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if ( state == AppLifecycleState.resumed ){
      if  ( await isLocationServiceEnabled() ) {
        Navigator.pushReplacementNamed(context, 'mapa' );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkGpsLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if ( snapshot.hasData ) {
            return Center( 
              child: Text( snapshot.data )
            );
          } else {
            return CircularProgressIndicator(strokeWidth: 3 );
          }
        },
      ),
   );
  }

  Future checkGpsLocation( BuildContext context ) async {
    
    // PermisoGps
    final permisoGPS = await Permission.location.isGranted;

    // GPS esta activo
    final gpsActivo = await isLocationServiceEnabled();

    if ( permisoGPS & gpsActivo ){
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, MapaPage() ));
      return '';
    } else if ( !permisoGPS ) {
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, AccesoGpsPage() ));
      return 'Es necesario el permiso de GPS';
    } else  {
      return 'Active el gps';
    }
     

  }
}