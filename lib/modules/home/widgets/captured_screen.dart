// import 'dart:io';
// import 'package:guardian_angel/modules/home/home.dart';
// import 'package:guardian_angel/utils.dart';
// import 'package:flutter/material.dart';

// class CapturedScreen extends StatefulWidget {
//   const CapturedScreen({super.key});

//   @override
//   State<CapturedScreen> createState() => _CapturedScreenState();
// }

// class _CapturedScreenState extends State<CapturedScreen> {
//   dynamic captureFile;
//   String lastSpot = "Option 1";
//   String timeSlot = "Time 1";
//   TextEditingController _moreTextController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstant.whiteColor,
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
//                         return MainScreen(fromCameraScreen: true);
//                       }), (route) => false);
//                     },
//                     child: Icon(
//                       Icons.arrow_back_ios,
//                       color: ColorConstant.blackColor,
//                     ),
//                   ),
//                   Text(
//                     "Take a picture!",
//                     style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w700, fontSize: 18),
//                   ),
//                   Image.asset(ImageConstants.taskIcon, height: 26, width: 26)
//                 ],
//               ),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.3, width: MediaQuery.of(context).size.width, child: Image.file(File(captureFile.path), fit: BoxFit.cover)),
//             SizedBox(height: 16),
//             Column(
//               children: [
//                 Text(
//                   "Where did you last spot him?",
//                   style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w400, fontSize: 16),
//                 ),
//                 SizedBox(height: 4),
//                 Container(
//                   width: MediaQuery.of(context).size.width - 66,
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 1.0,
//                     ),
//                   ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                       canvasColor: Colors.white,
//                     ),
//                     child: DropdownButton<String>(
//                       value: lastSpot,
//                       isExpanded: true,
//                       icon: Image.asset(ImageConstants.arrowDown, height: 26, width: 26),
//                       iconSize: 24,
//                       elevation: 16,
//                       style: TextStyle(color: Colors.black),
//                       underline: SizedBox(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           lastSpot = newValue!;
//                         });
//                       },
//                       items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4'].map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   "Around What time?",
//                   style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w400, fontSize: 16),
//                 ),
//                 SizedBox(height: 4),
//                 Container(
//                   width: MediaQuery.of(context).size.width - 66,
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 1.0,
//                     ),
//                   ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                       canvasColor: Colors.white,
//                     ),
//                     child: DropdownButton<String>(
//                       value: timeSlot,
//                       isExpanded: true,
//                       icon: Image.asset(ImageConstants.arrowDown, height: 26, width: 26),
//                       iconSize: 24,
//                       elevation: 16,
//                       style: TextStyle(color: Colors.black),
//                       underline: SizedBox(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           timeSlot = newValue!;
//                         });
//                       },
//                       items: <String>['Time 1', 'Time 2', 'Time 3', 'Time 4'].map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   "Please tell us more identification marks!",
//                   style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w400, fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width - 66,
//                   child: CustomCard(
//                     child: TextFormField(
//                       validator: (val) {},
//                       controller: _moreTextController,
//                       textInputAction: TextInputAction.next,
//                       textAlign: TextAlign.start,
//                       maxLines: 3,
//                       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorConstant.blackColor),
//                       decoration: InputDecoration(
//                         filled: true,
//                         hintText: 'Placeholder',
//                         hintStyle: TextStyle(color: ColorConstant.hintTextColor),
//                         contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white),
//                           borderRadius: BorderRadius.circular(25.7),
//                         ),
//                       ), // decoration: buildCustomDecoration(labelText: 'Enter Email Address'),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 26),
//                 Container(
//                   decoration: BoxDecoration(color: ColorConstant.lightGreenColor, borderRadius: BorderRadius.all(Radius.circular(8))),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
//                     child: Text(
//                       'SUBMIT',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 42),
//               ],
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
