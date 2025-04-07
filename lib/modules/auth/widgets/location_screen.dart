import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/route/app_routes.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/common_widgets.dart';
import 'package:guardian_angel/utils/full_screen_loader.dart';
import 'package:guardian_angel/utils/http_services.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:guardian_angel/utils/location_utils.dart';
import 'package:guardian_angel/utils/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:guardian_angel/utils/preference_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPermissionScreen extends StatefulWidget {
  final SignupRequestModel model;

  const LocationPermissionScreen({Key? key, required this.model}) : super(key: key);
  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  String userName = "";
  bool isLoading = false;
  LocationUtils locationUtils = LocationUtils();
  Position? currentPosition;
  late SignupRequestModel model;
  HttpService httpService = locator<HttpService>();

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 120, vertical: 80),
            child: RoundedTextButton(
              text: 'Next',
              height: 56,
              color: ColorConstant.primaryColor,
              onPressed: () async {
                try {
                  // LoadingIndicator.show(context);
                  locationUtils.handleLocationPermission(context).then((value) async {
                    if (value) {
                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                      print("Latitude :  ${position.latitude}");
                      print("Longitude :  ${position.longitude}");
                      currentPosition = position;
                      if (currentPosition != null) {
                        final prefs = await SharedPreferences.getInstance();
                        var userId = await prefs.getString(PreferenceConstant.userId);
                        if (userId == null) {
                          await signupApiCall();
                        } else {
                          Map<String, dynamic> arguments = {"isDataFetch": true};
                          Navigator.pushReplacementNamed(context, AppRoutes.main, arguments: arguments);
                        }
                      }
                    }
                  });
                } catch (e) {
                  AwesomeDialog(
                    context: context,
                    width: MediaQuery.of(context).size.width,
                    dialogType: DialogType.error,
                    animType: AnimType.topSlide,
                    dismissOnTouchOutside: false,
                    headerAnimationLoop: false,
                    title: 'ERROR',
                    desc: "Please give location permission and try again later!",
                    btnOkOnPress: () {},
                  )..show();
                } finally {
                  // LoadingIndicator.dismiss();
                }
              },
              textStyle: TextStyle(color: ColorConstant.whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(children: [
            SizedBox(height: 100),
            Image.asset(ImageConstants.logo, height: 90, width: 182, fit: BoxFit.cover),
            SizedBox(height: 36),
            // TextWidget(
            //   text: "Location is key!",
            //   txtstyle: TextStyle(color: ColorConstant.boldgreyColor, fontWeight: FontWeight.w700, fontSize: 24),
            // ),
            Text(
              "Location is key!",
              style: TextStyle(color: ColorConstant.boldgreyColor, fontWeight: FontWeight.w700, fontSize: 24),
            ),
            SizedBox(height: 26),
            // TextWidget(
            //   text: "Location permission is very required as We are providing services which requires user location, So please grant access to location!",
            //   txtstyle: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 20),
            // ),
            Text(
              "Location permission is very required as We are providing services which requires user location, So please grant access to location!",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ]),
        ));
  }

  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied) {
      return true;
    } else {
      return false;
    }
  }

  signupApiCall() async {
    // LoadingIndicator.show(context);
    Future.delayed(Duration(milliseconds: 1000), () async {
      try {
        http.Response response = await httpService.signupApi(model: model);
        // LoadingIndicator.dismiss();
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          SignupResponseModel signupResponseModel = SignupResponseModel.fromJson(responseBody);
          AwesomeDialog(
            context: context,
            width: MediaQuery.of(context).size.width,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            dismissOnTouchOutside: false,
            headerAnimationLoop: false,
            title: 'Success',
            desc: signupResponseModel.message,
            btnOkOnPress: () async {
              if (signupResponseModel.userID != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString(PreferenceConstant.userId, signupResponseModel.userID.toString());
                await prefs.setString(PreferenceConstant.languageCode, model.language.toString());
                LoadingIndicator.dismiss();
                Map<String, dynamic> arguments = {"isDataFetch": true};
                Navigator.pushReplacementNamed(context, AppRoutes.main, arguments: arguments);
              }
            },
          )..show();
        } else if (response.statusCode == 500) {
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
        LoadingIndicator.dismiss();
      }
    });
  }
}
