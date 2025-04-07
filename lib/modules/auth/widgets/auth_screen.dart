import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/custom_card.dart';

class AuthScreen extends StatefulWidget {
  final Function(String, bool) onMobileNumberEntered;

  const AuthScreen({super.key, required this.onMobileNumberEntered});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isValidIndianMobileNumber(String mobileNumber) {
    final RegExp regex = RegExp(r'^[6789]\d{9}$');
    return regex.hasMatch(mobileNumber);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      //  await Preference.shared.setUserID(signupResponseModel.userID.toString());
                    },
                    child: Text(
                      "Enter mobile number and login",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomCard(
                    child: TextFormField(
                      onChanged: (value) {
                        bool isValid = isValidIndianMobileNumber(value);
                        widget.onMobileNumberEntered(value, isValid);
                        if (value.length == 10 && isValid) {
                          FocusScope.of(context).unfocus(); // Dismiss the keyboard
                        }
                      },
                      controller: _mobileController,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10), //n is maximum number of characters you want in textfield
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a mobile number';
                        } else if (!isValidIndianMobileNumber(value)) {
                          return 'Please enter a valid Indian mobile number';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorConstant.blackColor),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Mobile Number...',
                        hintStyle: TextStyle(color: ColorConstant.hintTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                        contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ), // decoration: buildCustomDecoration(labelText: 'Enter Email Address'),
                    ),
                  ),
                  SizedBox(height: 62),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
