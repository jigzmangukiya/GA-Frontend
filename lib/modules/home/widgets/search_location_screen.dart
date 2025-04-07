import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/location_utils.dart';

class SerachLocationScreen extends StatefulWidget {
  final Position currentPosition;

  const SerachLocationScreen({super.key, required this.currentPosition});

  @override
  _SerachLocationScreenState createState() => _SerachLocationScreenState();
}

class _SerachLocationScreenState extends State<SerachLocationScreen> {
  GoogleMapController? mapController;
  LocationUtils locationUtils = LocationUtils();
  LatLng? pickupLocation;
  bool isMapInitialized = false;
  Position? currentPosition;
  @override
  void initState() {
    super.initState();
    currentPosition = widget.currentPosition;
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup Location'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: currentPosition == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CupertinoActivityIndicator(color: ColorConstant.primaryColor)),
                  SizedBox(height: 8),
                  Text(
                    "Loading...",
                    style: TextStyle(color: ColorConstant.primaryColor, fontSize: 14, fontWeight: FontWeight.w700),
                  )
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)), color: Colors.white),
                  child: GoogleMap(
                    myLocationEnabled: true, // Enables the my-location layer on the map
                    onMapCreated: (controller) {
                      if (!isMapInitialized) {
                        setState(() {
                          mapController = controller;
                          isMapInitialized = true;
                        });
                      }
                    },
                    markers: _createMarkers(),
                    onTap: _onMapTap,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                      zoom: 18.0,
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 126),
        child: FloatingActionButton(
          onPressed: _confirmPickup,
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!isMapInitialized) {
      setState(() {
        mapController = controller;
        isMapInitialized = true;
      });
    }
  }

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      pickupLocation = tappedPoint;
    });
  }

  Set<Marker> _createMarkers() {
    return pickupLocation != null
        ? {
            Marker(
              markerId: MarkerId('pickup'),
              position: pickupLocation ?? LatLng(0, 0),
              draggable: true,
              onDragEnd: (newPosition) {
                setState(() {
                  pickupLocation = newPosition;
                });
              },
            )
          }
        : {};
  }

  void _confirmPickup() {
    // Handle the pickup location confirmation, e.g., send it to the server.
    print('Selected Pickup Location: $pickupLocation');
    Navigator.of(context).pop(pickupLocation);
  }
}
