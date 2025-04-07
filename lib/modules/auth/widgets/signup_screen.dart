import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:guardian_angel/modules/auth/widgets/location_screen.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/common_widgets.dart';
import 'package:guardian_angel/utils/full_screen_loader.dart';
import 'package:guardian_angel/utils/http_services.dart';
import 'package:guardian_angel/utils/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:guardian_angel/utils/preference_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  final SignupRequestModel model;

  const SignUp({super.key, required this.model});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _firstNamesController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  String genderType = 'Male'; // Set an initial value
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
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 120, vertical: 32),
        child: RoundedTextButton(
          text: 'Submit',
          height: 56,
          width: 100,
          color: _firstNamesController.text.isEmpty || _lastNameController.text.isEmpty || _birthdateController.text.isEmpty ? Colors.grey : ColorConstant.primaryColor,
          onPressed: () async {
            if (_firstNamesController.text.isNotEmpty && _lastNameController.text.isNotEmpty && _birthdateController.text.isNotEmpty) {
              model.firstName = _firstNamesController.text;
              model.lastName = _lastNameController.text;
              model.dateOfBirth = _birthdateController.text;
              model.gender = genderType;
              await signupApiCall();
            } else {
              // signupApiCall();
            }
          },
          textStyle: TextStyle(color: ColorConstant.whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 42),
            Text(
              'Sign Up',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w700, color: ColorConstant.primaryColor),
            ),
            SizedBox(height: 26),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.58,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'First Name',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("5F5F63")),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _firstNamesController,
                              style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0XFFFAFAFA),
                                hintText: 'Enter first name',
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
                              onSaved: (value) {
                                model.firstName = value!;
                              },
                            ),
                            SizedBox(height: 26),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Name',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("5F5F63")),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _lastNameController,
                              style: TextStyle(color: ColorConstant.darkGreyTextColor, fontSize: 18),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0XFFFAFAFA),
                                hintText: 'Enter last name',
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
                              onSaved: (value) {
                                model.lastName = value!;
                              },
                            ),
                            SizedBox(height: 26),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("5F5F63")),
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
                            SizedBox(height: 26),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date of Birth',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16.0, color: ColorConstant.getColorFromHex("5F5F63")),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _birthdateController,
                              style: TextStyle(color: Colors.grey[800], fontSize: 18),
                              readOnly: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFFAFAFA),
                                hintText: 'Select Date',
                                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w400),
                                contentPadding: const EdgeInsets.only(left: 16.0, bottom: 14.0, top: 16.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorConstant.textfieldBorderColor),
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
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900), // Adjust the range as needed
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _birthdateController.text = pickedDate.toLocal().toString().split(' ')[0];
                                  });
                                }
                              },
                              onSaved: (value) {
                                model.dateOfBirth = value!;
                              },
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  signupApiCall() async {
    LoadingIndicator.show(context);
    Future.delayed(Duration(milliseconds: 1000), () async {
      try {
        http.Response response = await httpService.signupApi(model: model);
        LoadingIndicator.dismiss();
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
              // if (signupResponseModel.userID != null) {
              //   // await Preference.shared.setIsUserLoggedIn(true);
              //   // await Preference.shared.setUserID(signupResponseModel.userID.toString());
              // }
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(PreferenceConstant.userId, signupResponseModel.userID.toString());
              await prefs.setString(PreferenceConstant.languageCode, model.language.toString());
              final userName = '${signupResponseModel.FirstName ?? ""} + " " +${signupResponseModel.LastName ?? ""}';
              await prefs.setString(PreferenceConstant.userName, userName);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationPermissionScreen(model: SignupRequestModel()),
                ),
              );
            },
          )..show();
        } else if (response.statusCode == 500) {
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
      }
    });
  }
}
