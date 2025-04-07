import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardian_angel/modules/home/models/contribute_model.dart';
import 'package:guardian_angel/modules/home/widgets/search_location_screen.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/common_utils.dart';
import 'package:guardian_angel/utils/common_widgets.dart';
import 'package:guardian_angel/utils/enums.dart';
import 'package:guardian_angel/utils/full_screen_loader.dart';
import 'package:guardian_angel/utils/http_services.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:guardian_angel/utils/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:guardian_angel/utils/preference_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContributeScreen extends StatefulWidget {
  final Position currentPosition;
  const ContributeScreen({super.key, required this.currentPosition});
  @override
  State<ContributeScreen> createState() => _ContributeScreenState();
}

class _ContributeScreenState extends State<ContributeScreen> {
  CategoryType selectedCategory = CategoryType.Disaster;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController animalNameController = TextEditingController();
  String selectedFoodType = 'Food'; // Set an initial value
  String selectedDisasterType = 'Flood'; // Set an initial value
  String genderType = 'Male'; // Set an initial value
  String speciesType = 'Dog'; // Set an initial value
  String clothType = 'Shirt'; // Set an initial value
  String behaviorType = 'Aggresive'; // Set an initial value
  String helpType = 'Food'; // Set an initial value
  TextEditingController genderController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now().add(Duration(hours: 24));
  HttpService httpService = locator<HttpService>();
  final ImagePicker _picker = ImagePicker();
  dynamic profileFile;
  String imagePath = '';
  bool isButtonEnabled = false;
  late Position currentPosition;
  String currentAddress = '';

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    startDateTime = now;
    endDateTime = now.add(Duration(hours: 1));
    startDateController.text = DateFormat('dd/MM/yyyy').format(startDateTime);
    startTimeController.text = DateFormat('HH:mm:ss').format(startDateTime);
    endDateController.text = DateFormat('dd/MM/yyyy').format(endDateTime);
    endTimeController.text = DateFormat('HH:mm:ss').format(endDateTime);
    currentPosition = widget.currentPosition;
    _getAddressFromLatLng();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _updateEndDateTimeIfNeeded() {
    setState(() {
      if (endDateTime.isBefore(startDateTime.add(Duration(hours: 1)))) {
        endDateTime = startDateTime.add(Duration(hours: 1));
        endDateController.text = DateFormat('dd/MM/yyyy').format(endDateTime);
        endTimeController.text = DateFormat('HH:mm:ss').format(endDateTime);
      }
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        if (place.subThoroughfare != '') {
          currentAddress = "${place.subThoroughfare}, ${place.thoroughfare}";
        } else if (place.thoroughfare != '') {
          currentAddress = "${place.thoroughfare}, ${place.subLocality}";
        } else if (place.subLocality != '') {
          currentAddress = "${place.subLocality}, ${place.locality}";
        } else if (place.locality != '') {
          currentAddress = "${place.locality}, ${place.administrativeArea}";
        } else {
          currentAddress = "${place.administrativeArea}, ${place.country}";
        }
        print("current address : " + currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(232, 230, 255, 0.80), // Set the color with transparency
          borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
                    color: ColorConstant.getColorFromHex('D6D3FF'),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(ImageConstants.contribute, height: 36, width: 36),
                            Text(
                              'Contribute',
                              style: TextStyle(fontSize: 20.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Image.asset(ImageConstants.closeIcon, height: 26, width: 26))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.66,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            currentAddress == '' ? 'IIIT Hyderabad' : currentAddress,
                            maxLines: 2,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 14.0, color: ColorConstant.primaryColor, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                          onTap: () async {
                            await Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => SerachLocationScreen(
                                  currentPosition: currentPosition,
                                ),
                              ),
                            )
                                .then((value) async {
                              if (value != null) {
                                print("new location : ${value}");
                                LatLng latLng = value;
                                print("new latLng : ${latLng}");
                                currentPosition = Position(
                                    longitude: latLng.longitude,
                                    latitude: latLng.latitude,
                                    timestamp: currentPosition.timestamp,
                                    accuracy: currentPosition.accuracy,
                                    altitude: currentPosition.altitude,
                                    altitudeAccuracy: currentPosition.altitudeAccuracy,
                                    heading: currentPosition.heading,
                                    headingAccuracy: currentPosition.headingAccuracy,
                                    speed: currentPosition.speed,
                                    speedAccuracy: currentPosition.speedAccuracy);
                                await _getAddressFromLatLng();
                              } else {
                                print("location not picked");
                              }
                            });
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.06,
                              child: Image.asset(ImageConstants.location, height: 20, width: 20)))
                    ],
                  ),
                ),
                SizedBox(height: 26),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Domain to contribute',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("656565")),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 56,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: CategoryType.values.length,
                            itemBuilder: (BuildContext context, int index) {
                              CategoryType categoryType = CategoryType.values[index];
                              bool isSelected = categoryType == selectedCategory;
                              // Skip the removed category
                              if (categoryType == CategoryType.All || categoryType == CategoryType.Needy) {
                                return SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.only(right: 26),
                                child: GestureDetector(
                                  onTap: () {
                                    selectedCategory = categoryType;
                                    print(selectedCategory);
                                    setState(() {});
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
                                                            ? (isSelected
                                                                ? ImageConstants.clothesSelected
                                                                : ImageConstants.clothesUnselected)
                                                            : (isSelected
                                                                ? ImageConstants.shelterSelected
                                                                : ImageConstants.shelterUnselected),
                                        height: 32,
                                        width: 32,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        categoryType.name,
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
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.58,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Visibility(
                                visible: selectedCategory == CategoryType.Animal,
                                child: Column(
                                  children: [
                                    Text(
                                      'Name',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    TextField(
                                      controller: animalNameController,
                                      style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        hintText: 'Type here',
                                        hintStyle: TextStyle(color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 14.0, top: 16.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.primaryColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Description',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                  ),
                                  SizedBox(height: 4),
                                  TextField(
                                    controller: descriptionController,
                                    style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0XFFFAFAFA),
                                      hintText: 'Type here',
                                      hintStyle: TextStyle(color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                                      contentPadding: const EdgeInsets.only(left: 16.0, bottom: 14.0, top: 16.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstant.primaryColor),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      descriptionController.text.length > 0 ? isButtonEnabled = true : isButtonEnabled = false;
                                    },
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Food,
                                child: Column(
                                  children: [
                                    Text(
                                      'Food Type',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value: selectedFoodType,
                                      itemHeight: 48,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 12.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      hint: Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedFoodType = newValue!;
                                        });
                                      },
                                      items: <String>['Food', 'Plants', 'Shelter'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Disaster,
                                child: Column(
                                  children: [
                                    Text(
                                      'Disaster Type',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value: selectedDisasterType,
                                      itemHeight: 48,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 12.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      hint: Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedDisasterType = newValue!;
                                        });
                                      },
                                      items: <String>['Flood', 'Earthquake', 'Fire'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Animal,
                                child: Column(
                                  children: [
                                    Text(
                                      'Species',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value: speciesType,
                                      itemHeight: 48,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 12.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      hint: Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          speciesType = newValue!;
                                        });
                                      },
                                      items: <String>['Dog', 'Cat', 'Snake'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Clothes,
                                child: Column(
                                  children: [
                                    Text(
                                      'Gender',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value: genderType,
                                      itemHeight: 48,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 12.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      hint: Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          genderType = newValue!;
                                        });
                                      },
                                      items: <String>['Male', 'Female', 'Others'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Clothes,
                                child: Column(
                                  children: [
                                    Text(
                                      'Type of clothing',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value: clothType,
                                      itemHeight: 48,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 12.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      hint: Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          clothType = newValue!;
                                        });
                                      },
                                      items: <String>['Shirt', 'Pent', 'Trousers'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Animal,
                                child: Column(
                                  children: [
                                    Text(
                                      'Behaviour',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value: behaviorType,
                                      itemHeight: 48,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 12.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      hint: Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          behaviorType = newValue!;
                                        });
                                      },
                                      items: <String>['Aggresive', 'Friendly', 'Calm'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Upload Picture',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                  ),
                                  SizedBox(height: 4),
                                  InkWell(
                                    onTap: () async {
                                      if (imagePath == '') await buildBottomSheet(context: context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.all(Radius.circular(4))),
                                      height: 48,
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 16),
                                          Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                            size: MediaQuery.of(context).size.width * 0.05,
                                          ),
                                          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                          imagePath == ''
                                              ? Text(
                                                  'Tap here',
                                                  style: TextStyle(
                                                      color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                                                )
                                              : SizedBox(
                                                  height: 26,
                                                  width: 26,
                                                  child: Image.file(
                                                    File(imagePath),
                                                    fit: BoxFit.cover,
                                                  )),
                                          Spacer(),
                                          Visibility(
                                            visible: imagePath != '',
                                            child: SizedBox(
                                                height: 26,
                                                width: 26,
                                                child: InkWell(
                                                    onTap: () {
                                                      profileFile = null;
                                                      imagePath = '';
                                                      setState(() {});
                                                    },
                                                    child: Image.asset(ImageConstants.closeIcon2))),
                                          ),
                                          SizedBox(width: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Visibility(
                                  //   visible: imagePath != '',
                                  //   child: Column(
                                  //     children: [
                                  //       SizedBox(height: 4),
                                  //       SizedBox(
                                  //           height: 26,
                                  //           width: 26,
                                  //           child: Image.file(
                                  //             File(imagePath),
                                  //             fit: BoxFit.cover,
                                  //           )),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: 16),
                                ],
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Needy,
                                child: Column(
                                  children: [
                                    Text(
                                      'Help Type',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                    ),
                                    SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value: helpType,
                                      itemHeight: 48,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: Color(0XFFFAFAFA),
                                        contentPadding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 12.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      hint: Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          helpType = newValue!;
                                        });
                                      },
                                      items: <String>['Food', 'Shelter', 'Cloth'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedCategory == CategoryType.Food ||
                                    selectedCategory == CategoryType.Clothes ||
                                    selectedCategory == CategoryType.Shelter,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Start Date',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              child: TextField(
                                                controller: startDateController,
                                                style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0XFFFAFAFA),
                                                  hintText: 'Start date',
                                                  hintStyle: TextStyle(
                                                      color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                                                  contentPadding: const EdgeInsets.only(left: 16.0, bottom: 14.0, top: 16.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.primaryColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  DateTime? pickedDate = await showDatePicker(
                                                    context: context,
                                                    initialDate: startDateTime,
                                                    firstDate: DateTime.now().add(Duration(hours: 1)),
                                                    lastDate: DateTime(2101),
                                                  );
                                                  if (pickedDate != null) {
                                                    setState(() {
                                                      startDateTime = DateTime(
                                                        pickedDate.year,
                                                        pickedDate.month,
                                                        pickedDate.day,
                                                        startDateTime.hour,
                                                        startDateTime.minute,
                                                        startDateTime.second,
                                                      );
                                                      startDateController.text = DateFormat('dd/MM/yyyy').format(startDateTime);
                                                      _updateEndDateTimeIfNeeded();
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Start Time',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              child: TextField(
                                                controller: startTimeController,
                                                style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0XFFFAFAFA),
                                                  hintText: 'Start time',
                                                  hintStyle: TextStyle(
                                                      color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                                                  contentPadding: const EdgeInsets.only(left: 16.0, bottom: 14.0, top: 16.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.primaryColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  TimeOfDay? pickedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.fromDateTime(startDateTime),
                                                  );
                                                  if (pickedTime != null) {
                                                    final now = DateTime.now();
                                                    final newStartDateTime = DateTime(
                                                      startDateTime.year,
                                                      startDateTime.month,
                                                      startDateTime.day,
                                                      pickedTime.hour,
                                                      pickedTime.minute,
                                                    );
                                                    if (newStartDateTime.isAfter(now.add(Duration(hours: 1)))) {
                                                      setState(() {
                                                        startDateTime = newStartDateTime;
                                                        startTimeController.text = DateFormat('HH:mm:ss').format(startDateTime);
                                                        _updateEndDateTimeIfNeeded();
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'End Date',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              child: TextField(
                                                controller: endDateController,
                                                style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0XFFFAFAFA),
                                                  hintText: 'End date',
                                                  hintStyle: TextStyle(
                                                      color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                                                  contentPadding: const EdgeInsets.only(left: 16.0, bottom: 14.0, top: 16.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.primaryColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  DateTime? pickedDate = await showDatePicker(
                                                    context: context,
                                                    initialDate: endDateTime,
                                                    firstDate: startDateTime.add(Duration(hours: 1)),
                                                    lastDate: DateTime(2101),
                                                  );
                                                  if (pickedDate != null && pickedDate.isAfter(startDateTime.add(Duration(hours: 1)))) {
                                                    setState(() {
                                                      endDateTime = DateTime(
                                                        pickedDate.year,
                                                        pickedDate.month,
                                                        pickedDate.day,
                                                        endDateTime.hour,
                                                        endDateTime.minute,
                                                        endDateTime.second,
                                                      );
                                                      endDateController.text = DateFormat('dd/MM/yyyy').format(endDateTime);
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'End Time',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              child: TextField(
                                                controller: endTimeController,
                                                style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0XFFFAFAFA),
                                                  hintText: 'End time',
                                                  hintStyle: TextStyle(
                                                      color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                                                  contentPadding: const EdgeInsets.only(left: 16.0, bottom: 14.0, top: 16.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.primaryColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  TimeOfDay? pickedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.fromDateTime(endDateTime),
                                                  );
                                                  if (pickedTime != null) {
                                                    final newEndDateTime = DateTime(
                                                      endDateTime.year,
                                                      endDateTime.month,
                                                      endDateTime.day,
                                                      pickedTime.hour,
                                                      pickedTime.minute,
                                                    );
                                                    if (newEndDateTime.isAfter(startDateTime.add(Duration(hours: 1)))) {
                                                      setState(() {
                                                        endDateTime = newEndDateTime;
                                                        endTimeController.text = DateFormat('HH:mm:ss').format(endDateTime);
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 168,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 26),
                  child: RoundedTextButton(
                    text: 'Submit',
                    height: 56,
                    color: isButtonEnabled ? ColorConstant.primaryColor : Colors.grey,
                    onPressed: () async {
                      if (isButtonEnabled) {
                        await contributionApiCall();
                      }
                    },
                    textStyle: TextStyle(color: ColorConstant.whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String domainTypeString(CategoryType categoryType) {
    if (categoryType == CategoryType.All) {
      return "All";
    } else if (categoryType == CategoryType.Disaster) {
      return "Disaster";
    } else if (categoryType == CategoryType.Animal) {
      return "Animal";
    } else if (categoryType == CategoryType.Food) {
      return "Food";
    } else if (categoryType == CategoryType.Clothes) {
      return "Clothes";
    } else if (categoryType == CategoryType.Shelter) {
      return "Shelter";
    } else if (categoryType == CategoryType.Needy) {
      return "Needy";
    } else {
      return "";
    }
  }

  contributionApiCall() async {
    try {
      LoadingIndicator.show(context);
      ContributeModel data = ContributeModel();
      final prefs = await SharedPreferences.getInstance();
      String? userId = await prefs.getString(PreferenceConstant.userId);
      if (userId != null) {
        data.userID = userId;
      } else {
        data.userID = "wtbovJyQ2MVCG7NBjRq748xs2Pw1";
      }
      data.description = descriptionController.text;
      data.domainType = domainTypeString(selectedCategory);
      data.latitude = currentPosition.latitude;
      data.longitude = currentPosition.longitude;
      if (selectedCategory == CategoryType.Food || selectedCategory == CategoryType.Shelter || selectedCategory == CategoryType.Clothes) {
        data.startDate = startDateController.text;
        data.startTime = startTimeController.text;
        data.endDate = endDateController.text;
        data.endTime = endTimeController.text;
      }

      if (profileFile != null) {
        data.image = profileFile;
      }

      if (selectedCategory == CategoryType.Disaster) {
        data.disasterType = selectedDisasterType;
      } else if (selectedCategory == CategoryType.Animal) {
        data.name = animalNameController.text;
        data.species = speciesType;
        data.behavior = behaviorType;
      } else if (selectedCategory == CategoryType.Food) {
        data.foodType = selectedFoodType;
      } else if (selectedCategory == CategoryType.Clothes) {
        data.gender = genderType;
        data.clothingType = clothType;
      } else if (selectedCategory == CategoryType.Shelter) {
      } else if (selectedCategory == CategoryType.Needy) {
        data.helpType = helpType;
      }

      http.Response response = await httpService.contributionApi(model: data);
      LoadingIndicator.dismiss();
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        ContributionResponseModel contributionResponseModel = ContributionResponseModel.fromJson(responseBody);

        AwesomeDialog(
          context: context,
          width: MediaQuery.of(context).size.width,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          dismissOnTouchOutside: false,
          headerAnimationLoop: false,
          title: 'Success',
          desc: contributionResponseModel.message,
          btnOkOnPress: () {
            profileFile == null;
            imagePath = '';
            descriptionController.clear();
            animalNameController.clear();
            setState(() {});
          },
        )..show();
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
      LoadingIndicator.dismiss();
    }
  }

  Future buildBottomSheet({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          height: 160.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (await Permission.camera.request().isGranted) {
                            _onImageButtonPressed(
                              ImageSource.camera,
                              context: context,
                            );
                            Navigator.pop(context);
                          } else if (await Permission.camera.request().isPermanentlyDenied) {
                            print("permission denided");
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.topSlide,
                                dismissOnTouchOutside: true,
                                headerAnimationLoop: false,
                                title: 'Permission not granted!',
                                desc: "You need to allow camera option by clicking on Open Settings button.",
                                btnOkOnPress: () {
                                  openAppSettings();
                                },
                                btnOkText: "Open Settings",
                                btnCancelOnPress: () {})
                              ..show();
                          } else {}
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: ColorConstant.textfieldBorderColor,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Icon(Icons.photo, size: 40, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Camera",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  // SizedBox(width: 50.0),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         openImagePickerForProfile();
                  //         Navigator.pop(context);
                  //       },
                  //       child: Container(
                  //         height: 100,
                  //         width: 100,
                  //         decoration: BoxDecoration(
                  //           color: ColorConstant.textfieldBorderColor,
                  //           borderRadius: BorderRadius.circular(100.0),
                  //         ),
                  //         child: Icon(Icons.insert_drive_file_outlined, size: 40, color: Colors.white),
                  //       ),
                  //     ),
                  //     SizedBox(height: 10),
                  //     Text("Documents", style: TextStyle(fontSize: 14)),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        profileFile = pickedFile != null ? File(pickedFile.path) : null;
        imagePath = pickedFile != null ? pickedFile.path : '';
        print("file path : " + profileFile.toString());
      });
    } catch (e) {
      print('Error picking image from camera: $e');
    }
  }

  openImagePickerForProfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);

    if (result != null) {
      print("picked image size : " + Utils.getFileSizeString(bytes: File(result.paths.first!).lengthSync()));
      profileFile = null;
      profileFile = result.files.first;
    }
    setState(() {});
  }
}
