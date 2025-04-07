// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:guardian_angel/provider/geofence_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

// class MapScreen extends StatefulWidget {
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   bool isMapInitialized = false;
//   StreamSubscription<Position>? locationSubscription;
//   GoogleMapController? mapController;
//   Set<Marker> markers = const <Marker>{};
//   Set<Circle> circles = const <Circle>{};

//   @override
//   Widget build(BuildContext context) {
//     LocationProvider locationProvider = Provider.of<LocationProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Geofence Integration'),
//       ),
//       body: GoogleMap(
//         onMapCreated: (controller) {
//           markers = Set<Marker>.from([
//             Marker(
//               markerId: MarkerId('currentLocation'),
//               position: LatLng(
//                 locationProvider.currentPosition?.latitude ?? 0.0,
//                 locationProvider.currentPosition?.longitude ?? 0.0,
//               ),
//               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//               infoWindow: InfoWindow(
//                 title: 'Current Location',
//               ),
//             ),
//           ]);
//           circles = Set<Circle>.from([
//             Circle(
//               circleId: CircleId('geofence'),
//               center: LatLng(
//                 locationProvider.currentPosition?.latitude ?? 0.0,
//                 locationProvider.currentPosition?.longitude ?? 0.0,
//               ),
//               radius: 50.0,
//               fillColor: Colors.blue.withOpacity(0.5),
//               strokeColor: Colors.blue,
//               strokeWidth: 2,
//             ),
//           ]);
//           if (!isMapInitialized) {
//             setState(() {
//               mapController = controller;
//               isMapInitialized = true;
//             });
//           }
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//             locationProvider.currentPosition?.latitude ?? 0.0,
//             locationProvider.currentPosition?.longitude ?? 0.0,
//           ),
//           zoom: 18.0,
//         ),
//         markers: markers,
//         circles: circles,
//       ),
//     );
//   }
// }
