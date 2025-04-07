import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_angel/modules/auth/widgets/auth_screen.dart';
import 'package:guardian_angel/modules/auth/widgets/language_screen.dart';
import 'package:guardian_angel/modules/auth/widgets/otp_screen.dart';
import 'package:guardian_angel/modules/home/models/login_model.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/route/app_routes.dart';
import 'package:guardian_angel/utils.dart';
import 'package:flutter/material.dart';
import 'package:guardian_angel/utils/full_screen_loader.dart';
import 'package:guardian_angel/utils/http_services.dart';
import 'package:guardian_angel/utils/location_utils.dart';
// import 'package:guardian_angel/utils/preferences.dart';
import 'package:guardian_angel/utils/preference_constant.dart';

import 'package:guardian_angel/utils/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _currentPage = 0;
  final PageController _controller = PageController();
  Position? currentPosition;
  LocationUtils locationUtils = LocationUtils();
  bool isloading = false;
  String mobileNumber = '';
  String otpNumber = '';

  String verificationId = '';
  bool isButtonEnabled = false;
  bool isOTPEnabled = false;
  HttpService httpService = locator<HttpService>();

  @override
  void initState() {
    super.initState();
  }

  void updateMobilButtonState(String mobile, bool isValid) {
    setState(() {
      mobileNumber = mobile;
      isButtonEnabled = isValid;
    });
  }

  void updateOTPButtonState(String otp, bool isValid) {
    setState(() {
      otpNumber = otp;
      isOTPEnabled = isValid;
    });
  }

  bool isWithin60Seconds(DateTime creationTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(creationTime);
    int differenceInSeconds = difference.inSeconds.abs();
    return differenceInSeconds <= 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120, vertical: 80),
          child: RoundedTextButton(
            text: _currentPage == 1 ? "Verify" : 'Send OTP',
            height: 56,
            color: _currentPage == 0
                ? (isButtonEnabled ? ColorConstant.primaryColor : Colors.grey)
                : (isOTPEnabled ? ColorConstant.primaryColor : Colors.grey),
            onPressed: isButtonEnabled
                ? () async {
                    if (_currentPage == 0) {
                      if (mobileNumber.length == 10) {
                        // try {
                        //   LoadingIndicator.show(context);
                        //   FirebaseAuth auth = FirebaseAuth.instance;
                        //   await auth.verifyPhoneNumber(
                        //     phoneNumber: "+91${mobileNumber.toString()}",
                        //     timeout: const Duration(seconds: 60),
                        //     verificationCompleted: (PhoneAuthCredential credential) async {
                        //       await auth.signInWithCredential(credential);
                        //       LoadingIndicator.dismiss();
                        //     },
                        //     verificationFailed: (FirebaseAuthException e) {
                        //       LoadingIndicator.dismiss();
                        //       // showAlertDialog(
                        //       //   context,
                        //       //   title: 'ERROR',
                        //       //   message: e.toString(),
                        //       // );

                        //       if (e.code == 'invalid-phone-number') {
                        //         print('The provided phone number is not valid.');
                        //       }
                        //     },
                        //     codeSent: (String verificationid, int? resendToken) {
                        //       LoadingIndicator.dismiss();
                        //       verificationId = verificationid;
                        //       _currentPage += 1;
                        //       setState(() {});
                        //     },
                        //     codeAutoRetrievalTimeout: (String verificationId) {},
                        //   );
                        // } catch (e) {
                        //   LoadingIndicator.dismiss();
                        //   showAlertDialog(
                        //     context,
                        //     title: 'ERROR',
                        //     message: e.toString(),
                        //   );
                        // }
                        _currentPage += 1;
                        setState(() {});
                      }
                    } else if (_currentPage == 1) {
                      await _loginApiCall("3lkAzYcVMsRRPLvLYIOaXOOSi3Y2");

                      // if (otpNumber.length == 6) {
                      // try {
                      //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      //     verificationId: verificationId,
                      //     smsCode: otpNumber,
                      //   );
                      //   await FirebaseAuth.instance.signInWithCredential(credential);

                      //   FirebaseAuth _auth = FirebaseAuth.instance;

                      //   User? user = _auth.currentUser;

                      //   if (user != null) {
                      //     String userId = user.uid;
                      //     await _loginApiCall(userId);
                      //   } else {
                      //     AwesomeDialog(
                      //       context: context,
                      //       width: MediaQuery.of(context).size.width,
                      //       dialogType: DialogType.error,
                      //       animType: AnimType.topSlide,
                      //       dismissOnTouchOutside: false,
                      //       headerAnimationLoop: false,
                      //       title: 'ERROR',
                      //       desc: "Something went wrong!",
                      //       btnOkOnPress: () {},
                      //     )..show();
                      //   }
                      // } catch (e) {
                      //   showAlertDialog(
                      //     context,
                      //     title: 'ERROR',
                      //     message: e.toString(),
                      //   );
                      // }
                      // }
                    } else {}
                  }
                : null,
            textStyle: TextStyle(color: ColorConstant.whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 62),
          buildDotIndicator(),
          SizedBox(height: 26),
          Image.asset(ImageConstants.logo, height: 90, width: 182, fit: BoxFit.cover),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              onPageChanged: (int page) {},
              itemBuilder: (BuildContext context, int index) {
                if (_currentPage == 0) {
                  return AuthScreen(
                    onMobileNumberEntered: (mobile, isValid) {
                      updateMobilButtonState(mobile, isValid);
                    },
                  );
                } else if (_currentPage == 1) {
                  return OtpScreen(
                    mobile: mobileNumber,
                    onOTPEntered: (otp, isValid) {
                      updateOTPButtonState(otp, isValid);
                    },
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _loginApiCall(String userId) async {
    LoadingIndicator.show(context);
    Future.delayed(Duration(milliseconds: 1000), () async {
      try {
        http.Response response = await httpService.loginApi(firebaseUserID: userId);
        LoadingIndicator.dismiss();
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);

          LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(responseBody);

          if (loginResponseModel.userExists == true) {
            SignupResponseModel signupResponseModel = SignupResponseModel.fromJson(responseBody);

            if (loginResponseModel.userID != null) {
              final prefs = await SharedPreferences.getInstance();
              final userName = '${signupResponseModel.FirstName ?? ""} ${signupResponseModel.LastName ?? ""}';
              await prefs.setString(PreferenceConstant.userId, signupResponseModel.userID.toString());
              await prefs.setString(PreferenceConstant.languageCode, signupResponseModel.Language.toString());
              await prefs.setString(PreferenceConstant.userName, userName);
              // LoadingIndicator.dismiss();
              Navigator.pushReplacementNamed(context, AppRoutes.locationValidator);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          } else {
            SignupRequestModel model = SignupRequestModel();
            model.firebaseUserID = userId;
            model.phoneNo = "+91${mobileNumber}";
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LanguageScreen(model: model)));
          }
        } else {
          LoadingIndicator.dismiss();
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
        showAlertDialog(
          context,
          title: 'ERROR',
          message: e.toString(),
        );
      }
    });
  }

  void showAlertDialog(BuildContext context, {String? title, String? message}) {
    // Show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return an alert dialog
        return AlertDialog(
          title: Text(title!),
          content: Text(message!),
          actions: <Widget>[
            // Add a button to close the dialog
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialogp
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2, // Number of pages
        (index) => Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}
