import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_angel/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:guardian_angel/utils/location_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardian_angel/utils/preference_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  LocationUtils locationUtils = LocationUtils();
  Position? currentPosition;
  AnimationController? _logoAnimationController;
  AnimationController? _bgAnimationController;
  Tween<double> _logoTween = Tween(begin: 0, end: 2);

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _bgAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 10))..forward().whenComplete(() => _bgAnimationController?.reverse());
    Future.delayed(Duration(milliseconds: 700), () {
      _logoAnimationController?.forward(from: 0.0);
    });
    _checkFlagAndNavigate();
  }

  @override
  void dispose() {
    _logoAnimationController?.dispose();
    _bgAnimationController?.dispose();
    super.dispose();
  }

  Future<void> _checkFlagAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = await prefs.getString(PreferenceConstant.userId);
    var userName = await prefs.getString(PreferenceConstant.userName);

    if (userId != null) {
      locationUtils.handleLocationPermission(context).then((value) async {
        if (value) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          print("Latitude :  ${position.latitude}");
          print("Longitude :  ${position.longitude}");
          currentPosition = position;
          if (currentPosition != null) {
            Map<String, dynamic> arguments = {"isDataFetch": false, 'userName': userName};
            Navigator.pushReplacementNamed(context, AppRoutes.main, arguments: arguments);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.locationValidator);
          }
        }
      });
      // Navigator.pushReplacementNamed(context, AppRoutes.locationValidator);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(232, 230, 255, 1), // Set the color with transparency
          ),
          ScaleTransition(
            scale: _logoTween.animate(CurvedAnimation(parent: _logoAnimationController!, curve: Curves.elasticOut)),
            child: Center(
              child: Image.asset(
                ImageConstants.logo,
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoTheme(
                    data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark),
                    child: CupertinoActivityIndicator(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      "Please wait while we are fetching data....",
                      style: TextStyle(fontSize: 14, color: ColorConstant.primaryColor, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
