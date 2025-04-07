import 'dart:async';

import 'package:guardian_angel/route/app_routes.dart';
import 'package:guardian_angel/utils.dart';
import 'package:guardian_angel/utils/location_utils.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  Position? currentPosition;
  LocationUtils locationUtils = LocationUtils();
  GoogleMapController? mapController;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  StreamSubscription<Position>? locationSubscription;
  bool isMapInitialized = false;
  PolylinePoints polylinePoints = PolylinePoints();

  final locations = const [
    LatLng(17.44631658531488, 78.34910627893628),
    LatLng(17.445472013390397, 78.3490346471775),
    LatLng(17.44624474428008, 78.35030381501088),
    LatLng(17.446295558674674, 78.34892077104769),
    LatLng(17.44594511433027, 78.34861220347025),
    LatLng(17.445808571465843, 78.35131165640506),
    LatLng(17.444856445531617, 78.35034793175284),
  ];

  final images = const [];

  late List<MarkerData> _customMarkers;

  @override
  void initState() {
    setCustomMarkers();
    _moveToCurrentLocation();
    locationSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) {
      _updateMap(position);
    });
    super.initState();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  setCustomMarkers() {
    _customMarkers = [
      MarkerData(
          marker: Marker(
              markerId: const MarkerId('id-1'),
              position: locations[0],
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.petDetails);
              }),
          child: _customMarker('A', Colors.blue, ImageConstants.alex)),
      MarkerData(
          marker: Marker(
              markerId: const MarkerId('id-2'),
              position: locations[1],
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.petDetails);
              }),
          child: _customMarker('B', Colors.red, ImageConstants.gopi)),
      MarkerData(
          marker: Marker(
              markerId: const MarkerId('id-3'),
              position: locations[2],
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.petDetails);
              }),
          child: _customMarker('C', Colors.green, ImageConstants.greyhound)),
      MarkerData(
          marker: Marker(
              markerId: const MarkerId('id-4'),
              position: locations[3],
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.petDetails);
              }),
          child: _customMarker('D', Colors.purple, ImageConstants.batman)),
      MarkerData(
          marker: Marker(
              markerId: const MarkerId('id-5'),
              position: locations[4],
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.petDetails);
              }),
          child: _customMarker('E', Colors.blue, ImageConstants.trunks)),
      MarkerData(
          marker: Marker(
              markerId: const MarkerId('id-6'),
              position: locations[5],
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.petDetails);
              }),
          child: _customMarker('F', Colors.purple, ImageConstants.goodboi)),
      MarkerData(
          marker: Marker(
              markerId: const MarkerId('id-7'),
              position: locations[6],
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.petDetails);
              }),
          child: _customMarker('G', Colors.yellowAccent, ImageConstants.paper)),
    ];
  }

  void _updateMap(Position locationData) {
    LatLng userLocation = LatLng(locationData.latitude, locationData.longitude);

    // Update the polyline with the user's current location
    setState(() {
      polylineCoordinates.insert(0, userLocation);
      polylines.clear();
      polylines.add(Polyline(
        polylineId: PolylineId("polyline_1"),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      ));
    });

    // Optionally, you can move the camera to follow the user's location
    mapController?.animateCamera(CameraUpdate.newLatLng(userLocation));
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      locationUtils.handleLocationPermission(context);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
            // LatLng(position.latitude, position.longitude),
            LatLng(position.latitude, position.longitude)),
      );
      currentPosition = position;
      setState(() {});
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   // setState(() {
  //   mapController = controller;
  //   setState(() {});
  //   //   // Call a function to fetch and draw the initial polyline
  //   //   // _addPolyline();
  //   // });
  // }

  // void _fetchAndDrawPolyline() {
  //   // Fetch the polyline coordinates from a routing service (e.g., Google Maps Directions API)
  //   // Replace the origin and destination coordinates with your actual values
  //   List<LatLng> fetchedPolylineCoordinates = [
  //     LatLng(37.7749, -122.4194),
  //     LatLng(37.7859, -122.4294),
  //     // Add more points as needed
  //   ];

  //   setState(() {
  //     polylineCoordinates = fetchedPolylineCoordinates;
  //     polylines.add(Polyline(
  //       polylineId: PolylineId("polyline_1"),
  //       color: Colors.blue,
  //       points: polylineCoordinates,
  //       width: 5,
  //     ));
  //   });
  // }
  // void _getPolyline(LatLng latLng) async {
  //   List<LatLng> polylineCoordinates = [];

  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyBIYLEFVCl9maBoD7lGZgAk5p4fYfejs-g",
  //     PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
  //     PointLatLng(latLng.latitude, latLng.longitude),
  //     travelMode: TravelMode.walking,
  //   );
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   } else {
  //     print(result.errorMessage);
  //   }
  //   _addPolyline(polylineCoordinates);
  // }

  void _addPolyline(List<LatLng> fetchedPolylineCoordinates) {
    polylineCoordinates = [];

    polylines.clear();

    setState(() {
      polylineCoordinates = fetchedPolylineCoordinates;
      polylines.add(Polyline(
        polylineId: PolylineId("polyline_1"),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 22, right: 22),
              child: CustomGoogleMapMarkerBuilder(
                customMarkers: _customMarkers,
                builder: (BuildContext context, Set<Marker>? markers) {
                  if (markers == null || currentPosition == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CupertinoActivityIndicator(color: ColorConstant.primaryColor)),
                        SizedBox(height: 8),
                        Text(
                          "Loading...",
                          style: TextStyle(color: ColorConstant.primaryColor, fontSize: 14, fontWeight: FontWeight.w700),
                        )
                      ],
                    );
                  }
                  return GoogleMap(
                    myLocationEnabled: true, // Enables the my-location layer on the map
                    onMapCreated: (controller) {
                      if (!isMapInitialized) {
                        setState(() {
                          mapController = controller;
                          isMapInitialized = true;
                        });
                      }
                    },
                    polylines: polylines,
                    markers: markers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                      zoom: 18.0,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios, color: ColorConstant.blackColor),
                  Text(
                    "Pets around the campus!",
                    style: TextStyle(color: ColorConstant.blackColor, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).pushNamed(AppRoutes.locations);
                      Navigator.pushNamed(context, AppRoutes.locations).then((value) {
                        print(value);
                        if (value != null) {
                          // _addPolyline(value as LatLng);
                          // _getPolyline(value as LatLng);
                        }
                      });
                    },
                    child: Image.asset(
                      ImageConstants.taskIcon,
                      height: 26,
                      width: 26,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _customMarker(String symbol, Color color, String icon) {
    return Stack(
      children: [
        Icon(
          Icons.add_location,
          color: color,
          size: 50,
        ),
        Positioned(
          left: 15,
          top: 8,
          child: InkWell(
            onTap: () {
              print("ontap clicked");
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
              child: Center(
                  child: Image.asset(
                icon,
                fit: BoxFit.fill,
              )),
            ),
          ),
        )
      ],
    );
  }
}
