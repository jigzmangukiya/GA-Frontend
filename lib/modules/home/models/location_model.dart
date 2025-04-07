// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceLocation {
  String? locationId;
  String? locationName;
  LatLng? latLng;

  PlaceLocation({
    this.locationId = '',
    this.locationName = '',
    this.latLng = null,
  });

  PlaceLocation.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'] as String;
    locationName = json['locationName'] as String;
    latLng = json['latLng'] as LatLng;
  }
}
