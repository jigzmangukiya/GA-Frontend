// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationProvider with ChangeNotifier {
//   // Position? _currentPosition;

//   LocationProvider() {
//     // _getCurrentLocation();
//     _startGeofencing();
//   }

//   // Position? get currentPosition => _currentPosition;

//   // void _getCurrentLocation() async {
//   //   // _currentPosition = await Geolocator.getCurrentPosition();
//   //   notifyListeners();
//   // }

//   void _startGeofencing(Position position) async {
//     await bg.BackgroundGeolocation.ready(bg.Config(
//       desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//       distanceFilter: 50.0,
//       stopOnTerminate: false,
//       startOnBoot: true,
//     ));

//     bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
//       if (event.action == 'ENTER') {
//         print('Entered geofence: ${event.identifier}');
//       } else if (event.action == 'EXIT') {
//         print('Exited geofence: ${event.identifier}');
//       }
//     });

//     await bg.BackgroundGeolocation.addGeofence(bg.Geofence(
//       identifier: '1',
//       radius: 50.0,
//       latitude: _currentPosition?.latitude,
//       longitude: _currentPosition?.longitude,
//       notifyOnEntry: true,
//       notifyOnExit: true,
//       notifyOnDwell: false,
//       extras: {"key": "value"},
//     ));

//     bg.BackgroundGeolocation.start();
//   }

//   // LatLng? get currentLatLng {
//   //   return LatLng(
//   //     _currentPosition?.latitude ?? 0.0,
//   //     _currentPosition?.longitude ?? 0.0,
//   //   );
//   // }
// }
