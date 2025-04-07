import 'package:flutter/material.dart';
import 'package:guardian_angel/modules/auth/widgets/location_screen.dart';
import 'package:guardian_angel/modules/auth/widgets/signup_screen.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/common_widgets.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:guardian_angel/utils/translator_utils.dart';

class TransportScreen extends StatefulWidget {
  final bool isValidatorSelected;
  final SignupRequestModel model;

  const TransportScreen({Key? key, this.isValidatorSelected = false, required this.model}) : super(key: key);

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  bool isTransportSelected = false;
  List<bool> boolList = List.generate(4, (index) => false);
  late SignupRequestModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  String getSelectedTransports() {
    List<String> selected = [];
    for (int i = 0; i < boolList.length; i++) {
      if (boolList[i]) {
        selected.add(_getTransportName(i));
      }
    }
    return selected.join('|');
  }

  String _getTransportName(int index) {
    switch (index) {
      case 0:
        return 'Food';
      case 1:
        return 'Shelter';
      case 2:
        return 'Disaster';
      case 3:
        return 'Cloth';
      default:
        return '';
    }
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
            text: isTransportSelected ? 'Next' : 'Skip',
            height: 56,
            color: ColorConstant.primaryColor,
            onPressed: () async {
              if (widget.isValidatorSelected || isTransportSelected) {
                model.transport = getSelectedTransports();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(
                      model: model,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationPermissionScreen(model: model),
                  ),
                );
              }
            },
            textStyle: TextStyle(color: ColorConstant.whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
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
            Image.asset(ImageConstants.logo, height: 90, width: 182, fit: BoxFit.contain),
            SizedBox(height: 36),
            TextWidget(
              text: "What do you want to transport?",
              txtstyle: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 22),
            ),
            SizedBox(height: 26),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.center,
              runSpacing: 16,
              children: [
                _chipWidget(Icons.food_bank, 'Food', 0),
                _chipWidget(Icons.house, 'Shelter', 1),
                _chipWidget(Icons.warning, 'Disaster', 2),
                _chipWidget(Icons.wheelchair_pickup, 'Cloth', 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipWidget(IconData icon, String text, int num) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (boolList[num]) {
            boolList[num] = false;
          } else {
            boolList[num] = true;
            isTransportSelected = true;
          }

          bool flag = false;

          for (int i = 0; i < boolList.length; i++) {
            if (boolList[i] == true) {
              flag = true;
              break;
            }
          }
          isTransportSelected = flag;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Container(
          width: 107,
          height: 39,
          decoration: ShapeDecoration(
            color: boolList[num] ? Color(0xFF3D2EF5) : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFF3D2EF5)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(
                      width: 1,
                      color: boolList[num] ? Colors.white : Color(0xFF3D2EF5),
                    ),
                  ),
                ),
                child: Icon(
                  icon,
                  color: boolList[num] ? Colors.white : Color(0xFF3D2EF5),
                  size: 18,
                ),
              ),
              SizedBox(width: 5),
              TextWidget(
                text: text,
                txtstyle: TextStyle(
                  color: boolList[num] ? Colors.white : Color(0xFF3D2EF5),
                  fontSize: 16,
                  fontFamily: 'Cabin',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
