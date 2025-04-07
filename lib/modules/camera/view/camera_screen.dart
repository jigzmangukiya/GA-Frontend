import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:guardian_angel/route/app_routes.dart';
import 'package:guardian_angel/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  dynamic captureFile;
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  CameraDescription? camera;
  FlashMode flashMode = FlashMode.off;
  String lastSpot = "Option 1";
  String timeSlot = "Time 1";
  TextEditingController _moreTextController = TextEditingController();

  @override
  void initState() {
    openCameraPermission(0);
    super.initState();
  }

  Future<void> _initCamera({CameraLensDirection direction = CameraLensDirection.back}) async {
    cameras = await availableCameras();
    _controller = CameraController(
      getCameraBasedOnLensDirection(direction: direction),
      ResolutionPreset.max,
    );
    await _controller!.initialize();
  }

  openCameraPermission(int cameraType) async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      camera = cameras[cameraType];
      if (camera != null) _controller = CameraController(camera!, ResolutionPreset.max);
      if (_controller != null) await _controller?.initialize();

      if (!mounted) {
        return;
      }

      setState(() {});
    } else if (await Permission.camera.request().isPermanentlyDenied) {
      print("permission denided");
      AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.topSlide,
          dismissOnTouchOutside: true,
          headerAnimationLoop: false,
          title: 'Permission not granted!',
          desc: "You need to allow camera option by clicking on Open Settings button.",
          btnOkOnPress: () {
            openAppSettings();
          },
          btnOkText: "Open Settings",
          btnCancelOnPress: () {})
        ..show();
    } else {}
  }

  CameraDescription getCameraBasedOnLensDirection({
    required CameraLensDirection direction,
  }) =>
      cameras.firstWhere((camera) => camera.lensDirection == direction);

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CupertinoActivityIndicator());
    }
    return Scaffold(
      backgroundColor: captureFile == null ? ColorConstant.greyTextColor : ColorConstant.whiteColor,
      body: Stack(
        children: [
          if (captureFile == null)
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Column(
                  children: [
                    Container(
                      child: CameraPreview(_controller!),
                      height: MediaQuery.of(context).size.height * 0.56,
                      width: double.infinity,
                    ),
                    SizedBox(height: 26),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              final newCameraDirection = _controller!.description.lensDirection == CameraLensDirection.front ? CameraLensDirection.back : CameraLensDirection.front;
                              await _initCamera(direction: newCameraDirection);
                              setState(() {});
                            },
                            child: Icon(Icons.flip_camera_android),
                          ),
                          InkWell(
                            onTap: () async {
                              try {
                                // Ensure that the camera is initialized.
                                if (_controller != null || _controller!.value.isInitialized) {
                                  // Attempt to take a picture and get the file `image`
                                  // where it was saved.
                                  captureFile = await _controller!.takePicture();

                                  if (!mounted) return;
                                  setState(() {});
                                  // If the picture was taken, display it on a new screen.
                                  // await Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => DisplayPictureScreen(
                                  //       // Pass the automatically generated path to
                                  //       // the DisplayPictureScreen widget.
                                  //       imagePath: image.path,
                                  //     ),
                                  //   ),
                                  // );
                                }
                              } catch (e) {
                                // If an error occurs, log the error to the console.
                                print(e);
                              }
                            },
                            child: Image.asset(
                              ImageConstants.cameraButton,
                              height: 66,
                              width: 66,
                              fit: BoxFit.cover,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (flashMode == FlashMode.off) {
                                  _controller!.setFlashMode(FlashMode.always);
                                  flashMode = FlashMode.always;
                                } else {
                                  _controller!.setFlashMode(FlashMode.off);
                                  flashMode = FlashMode.off;
                                }
                              });
                            },
                            child: flashMode == FlashMode.off ? const Icon(Icons.flash_off) : const Icon(Icons.flash_on),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3, width: MediaQuery.of(context).size.width, child: Image.file(File(captureFile.path), fit: BoxFit.cover)),
                    SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          "Where did you last spot him?",
                          style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: MediaQuery.of(context).size.width - 66,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: lastSpot,
                              isExpanded: true,
                              icon: Image.asset(ImageConstants.arrowDown, height: 26, width: 26),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  lastSpot = newValue!;
                                });
                              },
                              items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Around What time?",
                          style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: MediaQuery.of(context).size.width - 66,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: timeSlot,
                              isExpanded: true,
                              icon: Image.asset(ImageConstants.arrowDown, height: 26, width: 26),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  timeSlot = newValue!;
                                });
                              },
                              items: <String>['Time 1', 'Time 2', 'Time 3', 'Time 4'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Please tell us more identification marks!",
                          style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 66,
                          child: CustomCard(
                            child: TextFormField(
                              controller: _moreTextController,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorConstant.blackColor),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Placeholder',
                                hintStyle: TextStyle(color: ColorConstant.hintTextColor),
                                contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                              ), // decoration: buildCustomDecoration(labelText: 'Enter Email Address'),
                            ),
                          ),
                        ),
                        SizedBox(height: 26),
                        Container(
                          decoration: BoxDecoration(color: ColorConstant.lightGreenColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 42, vertical: 12),
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(height: 42),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.only(top: 26),
            color: ColorConstant.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: captureFile != null,
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true,
                    child: InkWell(
                      onTap: () {
                        captureFile = null;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstant.blackColor,
                      ),
                    ),
                  ),
                  Text(
                    "Take a picture!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorConstant.blackColor, fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.checkList);
                      },
                      child: Image.asset(ImageConstants.taskIcon, height: 26, width: 26)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
