import 'package:flutter/material.dart';
import 'package:guardian_angel/modules/auth/widgets/validator_screen.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/utils.dart';

class LanguageScreen extends StatefulWidget {
  final SignupRequestModel model;
  const LanguageScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<bool> boolList = List.generate(12, (index) => false);
  late SignupRequestModel model;
  String? selectedLanguage;

  @override
  void initState() {
    model = widget.model;
    super.initState();
    boolList[2] = true; // Default to English
    selectedLanguage = 'english';
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
            text: 'Next',
            height: 56,
            color: ColorConstant.primaryColor,
            onPressed: selectedLanguage != null
                ? () {
                    model.language = selectedLanguage?.toLowerCase();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ValidatorScreen(model: model),
                      ),
                    );
                  }
                : null, // Disable button if no language is selected
            textStyle: TextStyle(
              color: ColorConstant.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          Image.asset(ImageConstants.logo, height: 90, width: 182, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 36),
                Text(
                  "Select Language",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstant.lightBlackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 26),
                _buildLanguageRows(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageRows() {
    return Column(
      children: [
        _buildLanguageRow([
          _Language("Hindi", 'hi', 0),
          _Language("Marathi", 'mr', 1),
          _Language("English", 'en', 2),
          _Language("Telugu", 'te', 3),
        ]),
        SizedBox(height: 10),
        _buildLanguageRow([
          _Language("Marwari", 'hi', 4),
          _Language("Bengali", 'bn', 5),
          _Language("Tamil", 'ta', 6),
          _Language("Gujarati", 'gu', 7),
        ]),
        SizedBox(height: 10),
        _buildLanguageRow([
          _Language("Assamese", 'as', 8),
          _Language("Pahari", 'en', 9),
          _Language("Kannada", 'kn', 10),
          _Language("Oriya", 'or', 11),
        ]),
      ],
    );
  }

  Widget _buildLanguageRow(List<_Language> languages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: languages.map((language) => _languageWidget(language.text, language.code, language.index)).toList(),
    );
  }

  Widget _languageWidget(String text, String code, int num) {
    return GestureDetector(
      onTap: () {
        setState(() {
          boolList = List.generate(12, (index) => false);
          boolList[num] = true;
          selectedLanguage = code;
        });
      },
      child: Container(
        width: 81,
        height: 39,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFF3D2EF5)),
            borderRadius: BorderRadius.circular(8),
          ),
          color: boolList[num] ? ColorConstant.primaryColor : Colors.transparent,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: boolList[num] ? ColorConstant.whiteColor : ColorConstant.primaryColor,
              fontSize: 16,
              fontFamily: 'Cabin',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _Language {
  final String text;
  final String code;
  final int index;

  _Language(this.text, this.code, this.index);
}
