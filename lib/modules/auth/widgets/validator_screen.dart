import 'package:flutter/material.dart';
import 'package:guardian_angel/modules/auth/widgets/transport_screen.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/common_widgets.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:guardian_angel/utils/translator_utils.dart';

class ValidatorScreen extends StatefulWidget {
  final SignupRequestModel model;

  const ValidatorScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<ValidatorScreen> createState() => _ValidatorScreenState();
}

class _ValidatorScreenState extends State<ValidatorScreen> {
  late SignupRequestModel model;
  List<String> validators = ['Food', 'Shelter', 'Disaster', 'Cloth', 'Animal'];
  List<bool> selectedValidators = List.generate(5, (index) => false);

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  String getSelectedValidators() {
    List<String> selected = [];
    for (int i = 0; i < validators.length; i++) {
      if (selectedValidators[i]) {
        selected.add(validators[i]);
      }
    }
    return selected.join('|');
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
            text: selectedValidators.contains(true) ? 'Next' : 'Skip',
            height: 56,
            color: ColorConstant.primaryColor,
            onPressed: () async {
              if (selectedValidators.contains(true)) {
                model.validate = getSelectedValidators();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransportScreen(
                    isValidatorSelected: selectedValidators.contains(true),
                    model: model,
                  ),
                ),
              );
            },
            textStyle: TextStyle(
              color: ColorConstant.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 100),
            Image.asset(
              ImageConstants.logo,
              height: 90,
              width: 182,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 36),
            TextWidget(
              text: "What do you want to validate?",
              txtstyle: TextStyle(
                color: ColorConstant.lightBlackColor,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 26),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.center,
              runSpacing: 16,
              children: validators.asMap().entries.map((entry) => _chipWidget(entry.value, entry.key)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipWidget(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedValidators[index] = !selectedValidators[index];
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Container(
          width: 107,
          height: 39,
          decoration: ShapeDecoration(
            color: selectedValidators[index] ? Color(0xFF3D2EF5) : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFF3D2EF5)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Center(
            child: TextWidget(
              text: text,
              txtstyle: TextStyle(
                color: selectedValidators[index] ? Colors.white : Color(0xFF3D2EF5),
                fontSize: 16,
                fontFamily: 'Cabin',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
