import 'package:guardian_angel/modules/home/home.dart';
import 'package:guardian_angel/utils/bottom_nav_bar.dart';
import 'package:guardian_angel/utils.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, this.fromCameraScreen = false}) : super(key: key);
  final bool fromCameraScreen;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentPage = 0;
  int? _noOfScreens;
  PageController? _pageController;

  @override
  void initState() {
    _noOfScreens = 3;
    _currentPage = widget.fromCameraScreen ? 1 : 0;
    _pageController = PageController(initialPage: widget.fromCameraScreen ? 1 : 0);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentPage != 0) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
            return MainScreen();
          }), (route) => false);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          color: Colors.white,
          child: BottomNavyBar(
            selectedIndex: _currentPage,
            backgroundColor: ColorConstant.whiteColor,
            onItemSelected: (index) => setState(() {
              _currentPage = index;
              _pageController?.jumpToPage(index);
            }),
            items: [
              BottomNavyBarItem(
                  icon: Image.asset(ImageConstants.homeIcon,
                      color: _currentPage == 0 ? ColorConstant.selectedColor : ColorConstant.blackColor, height: 26, width: 26, fit: BoxFit.cover),
                  title: Text('Places')),
              BottomNavyBarItem(
                  icon: Image.asset(ImageConstants.cameraIcon,
                      color: _currentPage == 1 ? ColorConstant.selectedColor : ColorConstant.blackColor, height: 26, width: 26, fit: BoxFit.cover),
                  title: Text('Camera')),
              BottomNavyBarItem(
                  icon: Image.asset(ImageConstants.foodIcon,
                      color: _currentPage == 2 ? ColorConstant.selectedColor : ColorConstant.blackColor, height: 26, width: 26, fit: BoxFit.cover),
                  title: Text('Food Spots')),
            ],
          ),
        ),
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: _noOfScreens,
          onPageChanged: (position) {
            FocusScope.of(context).unfocus();
            setState(() {
              _currentPage = position;
            });
          },
          itemBuilder: (buildContext, position) {
            switch (position) {
              case 1:
                return CameraScreen();
              case 2:
                return FoodScreen();
              case 0:
              default:
                return PlaceScreen();
            }
          },
        ),
      ),
    );
  }
}
