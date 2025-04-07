import 'package:guardian_angel/modules/home/models/location_model.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<PlaceLocation> places = [];

  @override
  void initState() {
    places = [
      PlaceLocation(
        locationId: "1",
        locationName: "Nilgiri Block",
        latLng: LatLng(17.447024534275602, 78.34883747091021),
      ),
      PlaceLocation(
        locationId: "2",
        locationName: "Himalayan Block",
        latLng: LatLng(17.445453416447815, 78.3491164206444),
      ),
      PlaceLocation(
        locationId: "3",
        locationName: "Vindhya C4 Block",
        latLng: LatLng(17.44566835844844, 78.34958312500741),
      ),
      PlaceLocation(
        locationId: "4",
        locationName: "Vindhya C6 Block",
        latLng: LatLng(17.445914006138864, 78.34926125992948),
      ),
      PlaceLocation(
        locationId: "5",
        locationName: "Vindhya Block",
        latLng: LatLng(17.445264062570654, 78.35006055820637),
      ),
      PlaceLocation(
        locationId: "6",
        locationName: "Kohli Block",
        latLng: LatLng(17.44513100297175, 78.34955630291759),
      ),
      PlaceLocation(
        locationId: "7",
        locationName: "Vindhya Canteen",
        latLng: LatLng(17.44625177117279, 78.34923443783967),
      )
    ];
    super.initState();
  }

  // final places = const ["Nilgiri Block", "Himalayan Block", "Vindhya C4 Block", "Vindhya C6 Block", "Vindhya Block", "Kohli Block", "Vindhya Canteen"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(onTap: () {}, child: Icon(Icons.arrow_back_ios, color: ColorConstant.blackColor)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Where would you like to navigate to?",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ColorConstant.blackColor, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: places.length,
                  padding: EdgeInsets.only(top: 26),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 32, right: 32),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, places[index].latLng);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                places[index].locationName ?? "",
                                maxLines: 2,
                                style: TextStyle(color: ColorConstant.blackColor, fontSize: 22, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Image.asset(ImageConstants.arrowRight, height: 26, width: 26)
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
