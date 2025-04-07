import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:guardian_angel/modules/splash/splash.dart';
import 'package:guardian_angel/route/app_router.dart';
import 'package:guardian_angel/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_angel/utils/firebase_options.dart';
import 'package:guardian_angel/utils/service_locator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // CHANGE THIS parameter to true if you want to test GDPR privacy consent
    bool _requireConsent = false;
    String _debugLabelString = "";
    bool _enableConsentButton = false;

    if (!mounted) return;

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(_requireConsent);

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    OneSignal.initialize("835b8f0a-1355-4bde-95ba-c4d55c3c4560");

    // AndroidOnly stat only
    // OneSignal.Notifications.removeNotification(1);
    // OneSignal.Notifications.removeGroupedNotifications("group5");

    OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });

    OneSignal.Notifications.addClickListener((event) {
      print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      this.setState(() {
        _debugLabelString = "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();

      this.setState(() {
        _debugLabelString = "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    this.setState(() {
      _enableConsentButton = _requireConsent;
    });

    OneSignal.InAppMessages.paused(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Platform.isIOS ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: Platform.isIOS ? Brightness.dark : Brightness.light,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: ColorConstant.primaryColor,
            ),
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: SplashScreen(),
    );
  }
}
