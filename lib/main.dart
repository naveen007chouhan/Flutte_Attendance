import 'package:AYT_Attendence/Screens/Splash/splashscreen.dart';
import 'package:AYT_Attendence/Screens/notification/NotificationScreen.dart';
import 'package:AYT_Attendence/pages/GeneralLeaves.dart';
import 'package:AYT_Attendence/pages/trackattendance.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Splash/animation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*title: 'Raindrop App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),*/
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  SharedPreferences sharedPreferences;

  Position _currentPosition;
  String _currentAddress;

  Future<void> getPermission() async{
    sharedPreferences=await SharedPreferences.getInstance();
    PermissionStatus permission=await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if(permission==PermissionStatus.denied)
    {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator=Geolocator();

    GeolocationStatus geolocationStatus=await geolocator.checkGeolocationPermissionStatus();

    switch(geolocationStatus)
    {
      case GeolocationStatus.disabled:
        print('Disabled');
        break;
      case GeolocationStatus.restricted:
        print('Restricted');
        break;
      case GeolocationStatus.denied:
        print('Denid');
        break;
      case GeolocationStatus.unknown:
        print('Unknown');
        break;
      case GeolocationStatus.granted:
        print('Granded');
        _getCurrentLocation();
        break;
    }



  }

  @override
  void initState() {
    // TODO: implement initState
    getPermission();
    _getAddressFromLatLng();
    _getCurrentLocation();
    getCurrentDate();
    super.initState();
  }

  getCurrentDate()async{
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day );
    print("Today Date : "+date.toString());
    setState(() {
      //sharedPreferences.setString("date", date.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
            children: <Widget>[
              Scaffold(
                  /*appBar: AppBar(
                    title: Text('Raindrop App'),
                  ),*/
                  body: SplashScreenPage()
              ),
              IgnorePointer(
                  child: AnimationScreen(
                      color: Colors.blue[1000]
                  )
              )
            ]
        )
    );
  }
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print("Position : "+_currentPosition.toString());
        sharedPreferences.setString("lat", _currentPosition.latitude.toString());
        sharedPreferences.setString("long", _currentPosition.longitude.toString());
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        print("Address : "+_currentAddress);
        sharedPreferences.setString("address", _currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }
}