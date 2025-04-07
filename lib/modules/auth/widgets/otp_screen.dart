import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/pinput_utils.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final Function(String, bool) onOTPEntered;
  final String mobile;

  const OtpScreen({super.key, required this.onOTPEntered, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  int? oldOTP;
  bool otpVerified = false;
  bool isOTPNotEntered = false;

  FocusNode otpFocusNode = FocusNode();
  String? otpcode;
  int minutes = 0;
  int seconds = 30;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  bool isWithin60Seconds(DateTime creationTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(creationTime);
    int differenceInSeconds = difference.inSeconds.abs();
    return differenceInSeconds <= 180;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (minutes > 0 || seconds > 0) {
          if (seconds == 0) {
            minutes--;
            seconds = 59;
          } else {
            seconds--;
          }
        } else {
          // Timer reached 0:00, you can perform actions here if needed
          // timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 36),
            Text(
              "OTP Verification",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 20),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Text(
                "Enter the code from the sms\nwe sent to +91-${widget.mobile}",
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
            SizedBox(height: 16),
            Text(
              formattedTime,
              style: TextStyle(color: ColorConstant.timerColor, fontWeight: FontWeight.w400, fontSize: 20),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Pinput(
                validator: (String? value) {
                  if (_otpController.text.length != 6) {
                    return "Please enter OTP";
                  }
                  return "";
                },
                onChanged: (value) {
                  widget.onOTPEntered(value, value.length == 6);
                  if (value.length == 6) {
                    FocusScope.of(context).unfocus(); // Dismiss the keyboard
                  }
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                length: 6,
                focusNode: otpFocusNode,
                defaultPinTheme: PinputUtils().defaultPinTheme.copyWith(
                      width: 62,
                      height: 62,
                      textStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                controller: _otpController,
                pinAnimationType: PinAnimationType.scale,
              ),
            ),
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn’t receive OTP?   ",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 20),
                ),
                Text(
                  "Resend",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorConstant.selectedColor, fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
