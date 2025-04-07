import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardian_angel/modules/home/models/feedback_model.dart';
import 'package:guardian_angel/modules/home/models/map_model.dart';
import 'package:guardian_angel/modules/home/widgets/chat_screen.dart';
import 'package:guardian_angel/modules/home/widgets/contribute_screen.dart';
import 'package:guardian_angel/utils.dart';
import 'package:guardian_angel/utils/common_utils.dart';
import 'package:guardian_angel/utils/enums.dart';
import 'package:guardian_angel/utils/http_services.dart';
import 'package:guardian_angel/utils/location_utils.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:guardian_angel/utils/service_locator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:http/http.dart' as http;
import 'package:guardian_angel/utils/preference_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const HomeScreen({super.key, required this.arguments});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? currentPosition;
  LocationUtils locationUtils = LocationUtils();
  GoogleMapController? mapController;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  StreamSubscription<Position>? locationSubscription;
  bool isMapInitialized = false;
  PolylinePoints polylinePoints = PolylinePoints();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CategoryType selectedCategory = CategoryType.All;
  double _geoFenceRadius = 500000;
  // var client;
  HttpService httpService = locator<HttpService>();
  late MqttServerClient client;
  String broker = '10.10.16.34';
  List<MarkerResponseData> messages = [];
  bool isDataFetch = false;

  final images = const [];
  Set<Circle> circles = const <Circle>{};

  List<MarkerData> _customMarkers = [];
  int selectedIndex = 0;

  @override
  void initState() {
    isDataFetch = widget.arguments['isDataFetch'];
    print("isDataFetch " + isDataFetch.toString());
    if (currentPosition == null) {
      _moveToCurrentLocation();
    } else {
      _checkDataFetch(currentPosition);
    }
    locationSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
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

  _checkDataFetch(Position? currentPosition) {
    // if (isDataFetch) {
    _fetchMarkerDataApiCall(currentPosition!);
    // } else {
    //   setCustomMarkers();
    // }
  }

  @override
  Widget build(BuildContext context) {
    Utils.globalContext = context;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32, left: 26, right: 26),
                child: Column(
                  children: [
                    // _buildSearchBar(),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 56,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: CategoryType.values.length,
                          itemBuilder: (BuildContext context, int index) {
                            CategoryType categoryType = CategoryType.values[index];
                            bool isSelected = categoryType == selectedCategory;
                            if (categoryType == CategoryType.Needy) {
                              return SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsets.only(right: 26),
                              child: GestureDetector(
                                onTap: () {
                                  selectedCategory = categoryType;
                                  polylineCoordinates.clear();
                                  _customMarkers = [];
                                  SetMarkerData().showCardNotifier.value = false;
                                  setState(() {});
                                  setCustomMarkers();
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      categoryType == CategoryType.All
                                          ? (isSelected ? ImageConstants.allUnselected : ImageConstants.allUnselected)
                                          : categoryType == CategoryType.Disaster
                                              ? (isSelected ? ImageConstants.disasterSelected : ImageConstants.disasterUnselected)
                                              : categoryType == CategoryType.Animal
                                                  ? (isSelected ? ImageConstants.animalSelected : ImageConstants.animalUnselected)
                                                  : categoryType == CategoryType.Food
                                                      ? (isSelected ? ImageConstants.foodSelected : ImageConstants.foodUnselected)
                                                      : categoryType == CategoryType.Clothes
                                                          ? (isSelected ? ImageConstants.clothesSelected : ImageConstants.clothesUnselected)
                                                          : (isSelected
                                                              ? ImageConstants.shelterSelected
                                                              : ImageConstants.shelterUnselected),

                                      height: 32,
                                      width: 32,
                                      // color: categoryType == selectedCategory ? ColorConstant.primaryColor : ColorConstant.categoryTextColor,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      categoryType.name.toString(),
                                      style: TextStyle(
                                          color: ColorConstant.primaryColor,
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
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
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
                                color: Colors.white),
                            child: GoogleMap(
                              myLocationEnabled: true, // Ena bles the my-location layer on the map
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
                              circles: circles,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                                zoom: 15.0,
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                            valueListenable: SetMarkerData().showCardNotifier,
                            builder: (context, showCard, child) {
                              return Visibility(
                                visible: showCard,
                                child: Positioned(
                                  bottom: 32,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(26)),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 24,
                                          sigmaY: 24,
                                        ),
                                        child: ClipRRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(26)),
                                                color: ColorConstant.getColorFromHex("786DFF").withOpacity(0.2)),
                                            width: MediaQuery.of(context).size.width - 82,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                              child: Stack(
                                                children: [
                                                  ValueListenableBuilder<MarkerResponseData>(
                                                      valueListenable: SetMarkerData().selectedMarkerDataNotifier,
                                                      builder: (context, selectedMarkerData, child) {
                                                        return Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                if (selectedMarkerData.image != "")
                                                                  Container(
                                                                    width: 46,
                                                                    height: 46,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.transparent,
                                                                      borderRadius: BorderRadius.circular(4), // Slight rounding if needed
                                                                      image: DecorationImage(
                                                                        image: MemoryImage(convertBase64Image(selectedMarkerData.image!)),
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (selectedMarkerData.image != "") SizedBox(width: 8),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    if (selectedMarkerData.domainType == CategoryType.Animal.name)
                                                                      Column(
                                                                        children: [
                                                                          if (selectedMarkerData.name != '')
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(height: 4),
                                                                                Text(
                                                                                  selectedMarkerData.name ?? "",
                                                                                  style: TextStyle(
                                                                                      color: ColorConstant.blackColor,
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          SizedBox(height: 4),
                                                                          Text(
                                                                            selectedMarkerData.behavior ?? "",
                                                                            style: TextStyle(
                                                                                color: ColorConstant.blackColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400),
                                                                          ),
                                                                          SizedBox(height: 4),
                                                                          Text(
                                                                            selectedMarkerData.species ?? "",
                                                                            style: TextStyle(
                                                                                color: ColorConstant.blackColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    Text(
                                                                      selectedMarkerData.domainType ?? "",
                                                                      style: TextStyle(
                                                                          color: ColorConstant.blackColor,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    if (selectedMarkerData.domainType == CategoryType.Clothes.name)
                                                                      Column(
                                                                        children: [
                                                                          if (selectedMarkerData.gender != '')
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(height: 4),
                                                                                Text(
                                                                                  selectedMarkerData.gender ?? "",
                                                                                  style: TextStyle(
                                                                                      color: ColorConstant.blackColor,
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          SizedBox(height: 4),
                                                                          Text(
                                                                            selectedMarkerData.clothingType ?? "",
                                                                            style: TextStyle(
                                                                                color: ColorConstant.blackColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    SizedBox(height: 4),
                                                                    Container(
                                                                      width: selectedMarkerData.image != ""
                                                                          ? MediaQuery.of(context).size.width * 0.4
                                                                          : MediaQuery.of(context).size.width * 0.68,
                                                                      child: Text(
                                                                        '${selectedMarkerData.description}',
                                                                        maxLines: 3,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: ColorConstant.blackColor,
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                    if (selectedMarkerData.domainType == CategoryType.Disaster.name)
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(height: 4),
                                                                          Text(
                                                                            selectedMarkerData.disasterType ?? "",
                                                                            style: TextStyle(
                                                                                color: ColorConstant.blackColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    SizedBox(height: 4),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                            onTap: () async {
                                                                              final prefs = await SharedPreferences.getInstance();
                                                                              var userId = await prefs.getString(PreferenceConstant.userId);
                                                                              FeedbackRequestModel model = FeedbackRequestModel(
                                                                                contributionID: selectedMarkerData.contributionID,
                                                                                userID: userId,
                                                                                feedback: "upvote",
                                                                              );
                                                                              _upDownVoteApiCall(model);
                                                                            },
                                                                            child: Image.asset(ImageConstants.thumbsUp,
                                                                                height: 26, width: 26, fit: BoxFit.cover)),
                                                                        SizedBox(width: 32),
                                                                        InkWell(
                                                                            onTap: () async {
                                                                              final prefs = await SharedPreferences.getInstance();
                                                                              var userId = await prefs.getString(PreferenceConstant.userId);
                                                                              FeedbackRequestModel model = FeedbackRequestModel(
                                                                                contributionID: selectedMarkerData.contributionID,
                                                                                userID: userId,
                                                                                feedback: "downvote",
                                                                              );
                                                                              _upDownVoteApiCall(model);
                                                                            },
                                                                            child: Image.asset(ImageConstants.thumbsDown,
                                                                                height: 26, width: 26, fit: BoxFit.cover)),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 8),
                                                            Row(
                                                              children: [
                                                                Image.asset(ImageConstants.locationIcon,
                                                                    height: 16, width: 16, fit: BoxFit.cover),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "${selectedMarkerData.distance?.toStringAsFixed(2)} Km away from you",
                                                                  style: TextStyle(
                                                                      color: ColorConstant.blackColor,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w400),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 8),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: 132,
                                                                  child: RoundedTextButton(
                                                                    text: 'Route',
                                                                    height: 36,
                                                                    color: ColorConstant.primaryColor,
                                                                    onPressed: () async {
                                                                      LatLng latLng = LatLng(selectedMarkerData.latitude ?? 0.0,
                                                                          selectedMarkerData.longitude ?? 0.0);
                                                                      _getPolyline(latLng);
                                                                      // currentPosition = Position(
                                                                      //   longitude: 72.888709,
                                                                      //   latitude: 21.214845,
                                                                      //   timestamp: currentPosition!.timestamp,
                                                                      //   accuracy: currentPosition!.accuracy,
                                                                      //   altitude: currentPosition!.altitude,
                                                                      //   altitudeAccuracy: currentPosition!.altitudeAccuracy,
                                                                      //   heading: currentPosition!.heading,
                                                                      //   headingAccuracy: currentPosition!.headingAccuracy,
                                                                      //   speed: currentPosition!.speed,
                                                                      //   speedAccuracy: currentPosition!.speedAccuracy,
                                                                      // );

                                                                      // setState(() {});

                                                                      // await Navigator.of(context).push(
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) => MapScreen(),
                                                                      //   ),
                                                                      // );
                                                                    },
                                                                    suffix: Padding(
                                                                      padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                                                                      child: Image.asset(
                                                                        ImageConstants.arrowRight,
                                                                        color: Colors.white,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                    textStyle: TextStyle(
                                                                        color: ColorConstant.whiteColor,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 72,
                                                                  child: RoundedTextButton(
                                                                    text: 'Report',
                                                                    height: 36,
                                                                    color: ColorConstant.primaryColor,
                                                                    onPressed: () async {
                                                                      // currentPosition = Position(
                                                                      //   longitude: 72.888709,
                                                                      //   latitude: 21.214845,
                                                                      //   timestamp: currentPosition!.timestamp,
                                                                      //   accuracy: currentPosition!.accuracy,
                                                                      //   altitude: currentPosition!.altitude,
                                                                      //   altitudeAccuracy: currentPosition!.altitudeAccuracy,
                                                                      //   heading: currentPosition!.heading,
                                                                      //   headingAccuracy: currentPosition!.headingAccuracy,
                                                                      //   speed: currentPosition!.speed,
                                                                      //   speedAccuracy: currentPosition!.speedAccuracy,
                                                                      // );

                                                                      // setState(() {});

                                                                      // await Navigator.of(context).push(
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) => MapScreen(),
                                                                      //   ),
                                                                      // );
                                                                    },
                                                                    textStyle: TextStyle(
                                                                        color: ColorConstant.whiteColor,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                  Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        SetMarkerData().toggleCardVisibility();
                                                      },
                                                      child: Image.asset(
                                                        ImageConstants.closeIcon2,
                                                        height: 26,
                                                        width: 26,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                },
              )),
              Container(
                height: 80,
                color: Colors.white,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 46,
            right: 46,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    _openContributeBottomSheet(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageConstants.contribute, height: 60, width: 60),
                      SizedBox(height: 6),
                      Text(
                        'Contribute',
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    _openAngelBottomSheet(context);
                  },
                  child: Column(
                    children: [
                      Image.asset(ImageConstants.angel, height: 60, width: 60),
                      SizedBox(height: 6),
                      Text(
                        'Angel',
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _customMarker(MarkerResponseData map) {
    return InkWell(
      onTap: () {
        print("ontap clicked");
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(100)),
        child: Center(
            child: Image.asset(
          map.domainType == CategoryType.Animal.name
              ? ImageConstants.animalMarkerIcon
              : map.domainType == CategoryType.Clothes.name
                  ? ImageConstants.clothesMarkerIcon
                  : map.domainType == CategoryType.Disaster.name
                      ? ImageConstants.disasterMarkerIcon
                      : map.domainType == CategoryType.Food.name
                          ? ImageConstants.foodMarkerIcon
                          : ImageConstants.shelterMarkerIcon,
          fit: BoxFit.fill,
        )),
      ),
    );
  }

  void _openContributeBottomSheet(BuildContext context) {
    if (currentPosition == null) {
      AwesomeDialog(
        context: context,
        width: MediaQuery.of(context).size.width,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        dismissOnTouchOutside: false,
        headerAnimationLoop: false,
        title: 'ERROR',
        desc: "Something went wrong!",
        btnOkOnPress: () {},
      )..show();
    } else {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.4), // Set background color to transparent
        isScrollControlled: true, // Allow the bottom sheet to take up the full screen
        builder: (BuildContext context) {
          return ContributeScreen(currentPosition: currentPosition!);
        },
      ).then((_) {
        _fetchMarkerDataApiCall(currentPosition!);
      });
    }
  }

  // Widget _buildSearchBar() {
  //   return Autocomplete<String>(
  //     optionsBuilder: (TextEditingValue textEditingValue) {
  //       // Filter the options based on the current search query
  //       return _allItems.where((item) => item.toLowerCase().contains(textEditingValue.text.toLowerCase())).toList();
  //     },
  //     onSelected: (String selectedItem) {
  //       // Handle item selection
  //       FocusManager.instance.primaryFocus?.unfocus();
  //       print('Selected: $selectedItem');
  //     },
  //     fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode focusNode, VoidCallback onFieldSubmitted) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             color: ColorConstant.borderTextFieldColor,
  //             width: 1,
  //           ),
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         child: TextField(
  //           controller: controller,
  //           focusNode: focusNode,
  //           onSubmitted: (value) {
  //             onFieldSubmitted();
  //           },
  //           style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
  //           decoration: InputDecoration(
  //             filled: true,
  //             fillColor: Color(0XFFFAFAFA),
  //             suffixIcon: Icon(Icons.search),
  //             hintText: 'Search Here...',
  //             hintStyle: TextStyle(color: ColorConstant.hintTextColor, fontSize: 14, fontWeight: FontWeight.w400),
  //             contentPadding: const EdgeInsets.only(left: 26.0, bottom: 14.0, top: 16.0),
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.white),
  //               borderRadius: BorderRadius.circular(26),
  //             ),
  //             enabledBorder: UnderlineInputBorder(
  //               borderSide: BorderSide(color: Colors.white),
  //               borderRadius: BorderRadius.circular(26),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
  //       return Align(
  //         alignment: Alignment.topLeft,
  //         child: Material(
  //           elevation: 8.0,
  //           color: ColorConstant.whiteColor,
  //           borderRadius: BorderRadius.all(Radius.circular(12)),
  //           child: ListView(
  //             shrinkWrap: true, //just set this property
  //             padding: EdgeInsets.zero,
  //             children: options
  //                 .map((String option) => ListTile(
  //                       title: Text(option),
  //                       onTap: () {
  //                         onSelected(option);
  //                       },
  //                     ))
  //                 .toList(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _openAngelBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.4), // Set background color to transparent
      isScrollControlled: true, // Allow the bottom sheet to take up the full screen
      builder: (BuildContext context) {
        return SafeArea(child: Container(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: ChatScreen()));
      },
    );
  }

  setCustomMarkers() {
    getJsonList().then((existingJsonList) {
      if (existingJsonList != null) {
        if (selectedCategory == CategoryType.All) {
          for (var i = 0; i < existingJsonList.length; i++) {
            MarkerResponseData data = MarkerResponseData.fromJson(existingJsonList[i]);
            _customMarkers.add(
              MarkerData(
                  marker: Marker(
                      markerId: MarkerId(data.contributionID ?? ""),
                      position: LatLng(data.latitude ?? 0.0, data.longitude ?? 0.0),
                      onTap: () {
                        print("ontap");
                        SetMarkerData().showCardNotifier.value = true;
                        double distance = calculateDistance(currentPosition?.latitude ?? 0.0, currentPosition?.longitude ?? 0.0,
                            data.latitude ?? 0.0, data.longitude ?? 0.0);
                        data.distance = distance;
                        SetMarkerData().updateMarkerData(data);
                      }),
                  child: _customMarker(data)),
            );
          }
        } else {
          for (var i = 0; i < existingJsonList.length; i++) {
            MarkerResponseData data = MarkerResponseData.fromJson(existingJsonList[i]);
            if (data.domainType == selectedCategory.name) {
              _customMarkers.add(
                MarkerData(
                    marker: Marker(
                        markerId: MarkerId(data.contributionID ?? ""),
                        position: LatLng(data.latitude ?? 0.0, data.longitude ?? 0.0),
                        onTap: () {
                          print("ontap");
                          SetMarkerData().showCardNotifier.value = true;
                          double distance = calculateDistance(currentPosition?.latitude ?? 0.0, currentPosition?.longitude ?? 0.0,
                              data.latitude ?? 0.0, data.longitude ?? 0.0);
                          data.distance = distance;
                          SetMarkerData().updateMarkerData(data);
                        }),
                    child: _customMarker(data)),
              );
            }
          }
        }
        setState(() {});
      } else {
        print("There are no data to load");
      }
    });
  }

  Uint8List convertBase64Image(String base64String) {
    return Base64Decoder().convert(base64String.split(',').last);
  }

  void _updateMap(Position locationData) {
    LatLng userLocation = LatLng(locationData.latitude, locationData.longitude);
    // Update the polyline with the user's current location
    // setState(() {
    // polylineCoordinates.insert(0, userLocation);
    // polylines.clear();
    // polylines.add(Polyline(
    //   polylineId: PolylineId("p1"),
    //   color: Colors.transparent,
    //   points: polylineCoordinates,
    //   width: 0,
    // ));
    // });

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
      // await _mqttConnect();
      final prefs = await SharedPreferences.getInstance();
      var geoHashId = await prefs.getString(PreferenceConstant.geoHashId);
      log("Log geoHash ID : " + geoHashId.toString());
      if (geoHashId == null) {
        await _mqttApiCall(currentPosition!);
      }
      _checkDataFetch(currentPosition);
      await _connect();
      await _startGeofencing();
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _connect() async {
    client = MqttServerClient(broker, '');
    client.port = 1883;
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;

    final prefs = await SharedPreferences.getInstance();
    var userId = await prefs.getString(PreferenceConstant.userId);

    final connMess = MqttConnectMessage().withClientIdentifier(userId!).withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final updates = recMess;
      saveDataFronStream(updates);
    });
  }

  Future<void> onConnected() async {
    print('Connected');
    // client.subscribe(topic, MqttQos.atLeastOnce);
    final prefs = await SharedPreferences.getInstance();
    var geoHashId = await prefs.getString(PreferenceConstant.geoHashId);
    var languageCode = await prefs.getString(PreferenceConstant.languageCode);
    if (languageCode == "null" || languageCode == "en") {
      languageCode = "english";
    }
    log("Log geoHash ID : " + geoHashId.toString());
    client.subscribe('${geoHashId}/${languageCode}/Food', MqttQos.atLeastOnce);
    client.subscribe('${geoHashId}/${languageCode}/Shelter', MqttQos.atLeastOnce);
    client.subscribe('${geoHashId}/${languageCode}/Clothes', MqttQos.atLeastOnce);
    client.subscribe('${geoHashId}/${languageCode}/Disaster', MqttQos.atLeastOnce);
    client.subscribe('${geoHashId}/${languageCode}/Animal', MqttQos.atLeastOnce);
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) async {
    print('Subscribed to $topic');
  }

  Future _mqttApiCall(Position currentPosition) async {
    // LoadingIndicator.show(context);
    // Future.delayed(Duration(milliseconds: 1000), () async {
    try {
      http.Response response = await httpService.getGeoHashApi(latitude: currentPosition.latitude, longitutde: currentPosition.longitude);
      // LoadingIndicator.dismiss();
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(PreferenceConstant.geoHashId, response.body.substring(0, 5));
      } else {
        // LoadingIndicator.dismiss();
        AwesomeDialog(
          context: context,
          width: MediaQuery.of(context).size.width,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          dismissOnTouchOutside: false,
          headerAnimationLoop: false,
          title: 'ERROR',
          desc: "Something went wrong!",
          btnOkOnPress: () {},
        )..show();
      }
    } catch (e) {
      // LoadingIndicator.dismiss();
    }
    // });
  }

  Future _fetchMarkerDataApiCall(Position currentPosition) async {
    // LoadingIndicator.show(context);
    // Future.delayed(Duration(milliseconds: 1000), () async {
    try {
      http.Response response = await httpService.getContributionsDataApi(currentPosition: currentPosition);
      // LoadingIndicator.dismiss();
      if (response.statusCode == 200) {
        List<dynamic> newJsonList = jsonDecode(response.body);
        List<Map<String, dynamic>> newJsonListMaps = newJsonList.map((e) => e as Map<String, dynamic>).toList();
        await saveJsonList(newJsonListMaps);
      } else {
        // LoadingIndicator.dismiss();
        // AwesomeDialog(
        //   context: context,
        //   width: MediaQuery.of(context).size.width,
        //   dialogType: DialogType.error,
        //   animType: AnimType.topSlide,
        //   dismissOnTouchOutside: false,
        //   headerAnimationLoop: false,
        //   title: 'ERROR',
        //   desc: "Something went wrong!",
        //   btnOkOnPress: () {},
        // )..show();
      }
    } catch (e) {
      // LoadingIndicator.dismiss();
    }
    // });
  }

  Future _upDownVoteApiCall(FeedbackRequestModel model) async {
    // LoadingIndicator.show(context);
    // Future.delayed(Duration(milliseconds: 1000), () async {
    try {
      http.Response response = await httpService.contributeFeedbackApi(model: model);
      // LoadingIndicator.dismiss();
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        // SignupResponseModel signupResponseModel = SignupResponseModel.fromJson(responseBody);
        AwesomeDialog(
          context: context,
          width: MediaQuery.of(context).size.width,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          dismissOnTouchOutside: false,
          headerAnimationLoop: false,
          title: 'Success',
          desc: responseBody["message"],
          btnOkOnPress: () {},
        )..show();
      } else {
        // LoadingIndicator.dismiss();
        AwesomeDialog(
          context: context,
          width: MediaQuery.of(context).size.width,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          dismissOnTouchOutside: false,
          headerAnimationLoop: false,
          title: 'ERROR',
          desc: "Something went wrong!",
          btnOkOnPress: () {},
        )..show();
      }
    } catch (e) {
      // LoadingIndicator.dismiss();
    }
    //   });
  }

  Future _startGeofencing() async {
    bg.BackgroundGeolocation.onLocation((event) {
      currentPosition = Position(
        longitude: event.coords.longitude,
        latitude: event.coords.latitude,
        timestamp: DateTime.parse(event.timestamp),
        accuracy: event.coords.accuracy,
        altitude: event.coords.altitude,
        altitudeAccuracy: event.coords.altitudeAccuracy,
        heading: event.coords.heading,
        headingAccuracy: event.coords.headingAccuracy,
        speed: event.coords.speed,
        speedAccuracy: event.coords.speedAccuracy,
      );
    });

    bg.BackgroundGeolocation.onGeofence((event) {
      Fluttertoast.showToast(msg: "GEOFENCE EVENT ==> ${event.action}");

      if (event.action == "EXIT") {
        _addGeoFence();
      }
    });

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((bg.State state) {
      if (!state.enabled) {
        Fluttertoast.showToast(msg: "BG location service ready");
        bg.BackgroundGeolocation.start().then((value) {
          _addGeoFence();
        });
      } else {
        _addGeoFence();
      }
    });
  }

  void _addGeoFence() {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        identifier: "1",
        radius: _geoFenceRadius,
        latitude: currentPosition?.latitude,
        longitude: currentPosition?.longitude,
        notifyOnEntry: true,
        notifyOnExit: true,
        notifyOnDwell: false,
        extras: {
          'radius': _geoFenceRadius,
          'vertices': [],
          'center': {
            'latitude': currentPosition?.latitude,
            'longitude': currentPosition?.longitude,
          }
        })).then((bool success) {
      Fluttertoast.showToast(msg: "Geo-fence Added on $_geoFenceRadius meter radius");
      circles = Set<Circle>.from([
        Circle(
          circleId: CircleId('geofence'),
          center: LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
          radius: _geoFenceRadius,
          fillColor: Colors.red.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      ]);
      setState(() {});
    }).catchError((error) {
      Fluttertoast.showToast(msg: '[addGeofence] ERROR: $error');
    });
  }

  // void _onGeofence(bg.GeofenceEvent event) async {
  //   print('[${bg.Event.GEOFENCE}] - $event');
  //   var snackBar = SnackBar(content: Text(event.action));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  void _getPolyline(LatLng latLng) async {
    // List<LatLng> polylineCoordinates = [];
    polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
        destination: PointLatLng(latLng.latitude, latLng.longitude),
        mode: TravelMode.walking,
      ),
      googleApiKey: "AIzaSyBIYLEFVCl9maBoD7lGZgAk5p4fYfejs-g",
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyline(polylineCoordinates);
  }

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

  // Future<void> saveJsonList(List<Map<String, dynamic>> jsonList) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(jsonList);
  //   prefs.setString(PreferenceConstant.markerList, jsonString);
  //   // setState(() {});
  // }

  Future<void> saveJsonList(List<Map<String, dynamic>> newJsonList) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the existing JSON list
    String? existingJsonString = prefs.getString(PreferenceConstant.markerList);
    List<Map<String, dynamic>> existingJsonList = [];

    if (existingJsonString != null) {
      List<dynamic> existingJsonListDynamic = jsonDecode(existingJsonString);
      existingJsonList = existingJsonListDynamic.map((e) => e as Map<String, dynamic>).toList();
    }

    // Extract existing contribution IDs
    Set<String> existingContributionIds = existingJsonList.map((item) => item['contributionID'] as String).toSet();

    // Filter new list items to exclude duplicates and ensure userID is a string
    List<Map<String, dynamic>> filteredNewJsonList = newJsonList.where((newItem) {
      newItem['userID'] = newItem['userID']?.toString() ?? "";
      return !existingContributionIds.contains(newItem['contributionID'] as String);
    }).toList();

    // Merge the filtered new list items with the existing list
    existingJsonList.addAll(filteredNewJsonList);
    log("total markers : " + existingJsonList.length.toString());
    // Encode the merged list back to JSON
    String mergedJsonString = jsonEncode(existingJsonList);

    // Save the merged JSON string to shared preferences
    prefs.setString(PreferenceConstant.markerList, mergedJsonString);
    setCustomMarkers();
  }

  Future<List<Map<String, dynamic>>?> getJsonList() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(PreferenceConstant.markerList);
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => e as Map<String, dynamic>).toList();
    }
    return null;
  }

  saveDataFronStream(dynamic latestUpdate) {
    if (latestUpdate != null) {
      final payloadAsString = latestUpdate.payload.toString();
      final payloadContent = payloadAsString;

      // Convert ASCII payload to text
      var text = asciiToText(payloadContent);
      String cleanJsonString = '${text}';

      var encoded = cleanJsonString.substring(1);

      var decodedJson = json.decode(encoded);

      MarkerResponseData data = MarkerResponseData.fromJson(decodedJson);

      // Retrieve existing JSON list from SharedPreferences
      getJsonList().then((existingJsonList) async {
        List<Map<String, dynamic>> jsonList = existingJsonList ?? [];
        if (jsonList.length > 0) {
          if (!jsonList.map((e) => e['contributionID']).toList().contains(data.contributionID)) {
            jsonList.add(data.toJson());
            print(jsonList);
          } else {
            print("Repeated Data");
          }
        } else {
          jsonList.add(data.toJson());
        }
        print("contribution list length " + jsonList.length.toString());
        // Save the updated JSON list to SharedPreferences
        await saveJsonList(jsonList);
        // setState(() {});
        setCustomMarkers();
      });
    }
  }

  String asciiToText(String asciiCodes) {
    List<String> byteStrings = asciiCodes.split('<').where((s) => s.isNotEmpty).toList();
    List<int> asciiBytes = byteStrings.map((byteString) {
      int endIndex = byteString.indexOf('>');
      if (endIndex != -1) {
        return int.parse(byteString.substring(0, endIndex));
      }
      return 0; // Or any other fallback value
    }).toList();
    String text = String.fromCharCodes(asciiBytes);
    return text;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    double dLat = radians(lat2 - lat1);
    double dLon = radians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(radians(lat1)) * math.cos(radians(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double radians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

class SetMarkerData {
  // Singleton instance
  static final SetMarkerData _instance = SetMarkerData._internal();

  // Private constructor
  SetMarkerData._internal();

  // Factory constructor
  factory SetMarkerData() {
    return _instance;
  }

  // ValueNotifiers
  ValueNotifier<MarkerResponseData> selectedMarkerDataNotifier = ValueNotifier<MarkerResponseData>(MarkerResponseData());
  ValueNotifier<bool> showCardNotifier = ValueNotifier<bool>(false);

  // Methods to update data
  void updateMarkerData(MarkerResponseData data) {
    selectedMarkerDataNotifier.value = data;
  }

  void toggleCardVisibility() {
    showCardNotifier.value = !showCardNotifier.value;
  }
}
