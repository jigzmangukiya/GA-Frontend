import 'package:guardian_angel/modules/auth/auth.dart';
import 'package:guardian_angel/modules/auth/widgets/language_screen.dart';
import 'package:guardian_angel/modules/auth/widgets/location_screen.dart';
import 'package:guardian_angel/modules/auth/widgets/signup_screen.dart';
import 'package:guardian_angel/modules/auth/widgets/transport_screen.dart';
import 'package:guardian_angel/modules/auth/widgets/validator_screen.dart';
import 'package:guardian_angel/modules/home/home.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/modules/home/widgets/home_screen.dart';
import 'package:guardian_angel/modules/home/widgets/locations_screen.dart';
import 'package:guardian_angel/modules/splash/view/splash_screen.dart';
import 'package:guardian_angel/route/app_routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _getPageRoute(const SplashScreen(), settings);
      case AppRoutes.login:
        return _getPageRoute(const LoginScreen(), settings);
      case AppRoutes.main:
        final arguments = settings.arguments as Map<String, dynamic>;
        return _getPageRoute(HomeScreen(arguments: arguments), settings);
      case AppRoutes.place:
        return _getPageRoute(const PlaceScreen(), settings);
      case AppRoutes.camera:
        return _getPageRoute(const CameraScreen(), settings);
      case AppRoutes.food:
        return _getPageRoute(const FoodScreen(), settings);
      case AppRoutes.petDetails:
        return _getPageRoute(const PetDetailsScreen(), settings);
      case AppRoutes.checkList:
        return _getPageRoute(ChecklistScreen(), settings);
      case AppRoutes.locations:
        return _getPageRoute(const LocationScreen(), settings);
      case AppRoutes.language:
        return _getPageRoute(
            LanguageScreen(
              model: SignupRequestModel(),
            ),
            settings);
      case AppRoutes.locationValidator:
        return _getPageRoute(
            LocationPermissionScreen(
              model: SignupRequestModel(),
            ),
            settings);
      case AppRoutes.validator:
        return _getPageRoute(
            ValidatorScreen(
              model: SignupRequestModel(),
            ),
            settings);
      case AppRoutes.transport:
        return _getPageRoute(
            TransportScreen(
              model: SignupRequestModel(),
            ),
            settings);
      case AppRoutes.signup:
        return _getPageRoute(
            SignUp(
              model: SignupRequestModel(),
            ),
            settings);
      default:
        return _getPageRoute(const SplashScreen(), settings);
    }
  }

  static PageRoute _getPageRoute(Widget child, RouteSettings settings) {
    return _FadeRoute(child: child, routeName: settings.name!, arguments: settings.arguments);
  }

  // static _trackPage(RouteSettings settings) async {
  //   var userData = await HelperFunctions.storedUserData;
  //   bool isLoggedIn = HelperFunctions.isLogin ?? false;
  //   HelperFunctions.currentScreen = settings.name;

  //   HelperFunctions().sendAnalyticsEvent("page_view", parameters: {
  //     "user_id": isLoggedIn ? userData?.data?.userId ?? "" : "",
  //     "user_type": isLoggedIn ? "registered" : "guest",
  //     "page": settings.name,
  //   });

  //   HelperFunctions().setCurrentScreen(settings.name ?? "Home", null);
  // }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget? child;
  final String? routeName;
  final Object? arguments;

  _FadeRoute({this.child, this.routeName, this.arguments})
      : super(
          settings: RouteSettings(name: routeName, arguments: arguments),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            // Turned off animation
            opacity: const AlwaysStoppedAnimation<double>(1),
            // replace above with 'animation' to enable fade animation
            child: child,
          ),
        );
}
