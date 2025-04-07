import 'dart:ui';

import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/common_widgets.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:flutter/material.dart';

class PetDetailsScreen extends StatefulWidget {
  const PetDetailsScreen({super.key});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    ImageConstants.pet1,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 36),
                      child: Icon(Icons.arrow_back_ios, color: ColorConstant.whiteColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 72),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(ImageConstants.aboutIcon, height: 26, width: 26),
                        SizedBox(width: 8),
                        Text(
                          "About Chubby",
                          style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCommonTextDetails("Weight", "5,5 kg"),
                        getCommonTextDetails("Height", "42 cm"),
                        getCommonTextDetails("Color", "Brown"),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Friendliness Level: ",
                              style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            Text(
                              "Moderately Friendly | | Not Trained",
                              style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(ImageConstants.behavior, height: 26, width: 26),
                            SizedBox(width: 8),
                            Text(
                              "Chubby behavior",
                              style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            Spacer(),
                            Image.asset(ImageConstants.arrowRight, height: 26, width: 26),
                          ],
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            cardTextBox("Loves Pets"),
                            cardTextBox("Friendly with People"),
                            cardTextBox("Active"),
                            cardTextBox("Loves a treat"),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Padding(
              padding: EdgeInsets.only(right: 26, left: 26),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(26)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 12,
                    sigmaY: 12,
                  ),
                  child: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstant.whiteColor.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(26)),
                        boxShadow: [
                          BoxShadow(
                              color: ColorConstant.shadowColor,
                              blurRadius: 27.0, // soften the shadow
                              offset: Offset(5, 43)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Chubby",
                                          style: TextStyle(color: ColorConstant.blackColor, fontSize: 26, fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "Indie: 1y 4m",
                                          style: TextStyle(color: ColorConstant.lightBlackColor, fontSize: 16, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    RoundedTextButton(
                                      text: 'Pet him!',
                                      width: 100,
                                      color: ColorConstant.secondaryColor,
                                      onPressed: () async {},
                                      textStyle: TextStyle(color: ColorConstant.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                          Text(
                            "Total Pets received from fellow pet lovers: 125 🐕",
                            style: TextStyle(color: ColorConstant.lightBlackColor, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getCommonTextDetails(String title, String val) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.26,
      decoration: BoxDecoration(color: ColorConstant.secondaryColor.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: TextStyle(color: ColorConstant.lightBlackColor, fontWeight: FontWeight.w400, fontSize: 14),
            ),
            Text(
              val,
              style: TextStyle(color: ColorConstant.secondaryColor, fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardTextBox(String val) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.secondaryColor, width: 1), borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(val, style: TextStyle(color: ColorConstant.lightBlackColor)),
      ),
    );
  }
}
