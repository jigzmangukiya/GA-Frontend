import 'package:guardian_angel/utils.dart';

/// The possible flash modes that can be set for a camera
enum FlashMode {
  /// Do not use the flash when taking a picture.
  off,

  /// Let the device decide whether to flash the camera when taking a picture.
  auto,

  /// Always use the flash when taking a picture.
  always,

  /// Turns on the flash light and keeps it on until switched off.
  torch,
}

enum CategoryType { All, Disaster, Animal, Food, Clothes, Shelter, Needy }

class GetCategoryIcon {
  String categoryIcon() {
    if (CategoryType == CategoryType.All) {
      return ImageConstants.all;
    } else if (CategoryType == CategoryType.Disaster) {
      return ImageConstants.disaster;
    } else if (CategoryType == CategoryType.Animal) {
      return ImageConstants.animal;
    } else if (CategoryType == CategoryType.Food) {
      return ImageConstants.food;
    } else if (CategoryType == CategoryType.Clothes) {
      return ImageConstants.animal;
    } else if (CategoryType == CategoryType.Shelter) {
      return ImageConstants.disaster;
    } else if (CategoryType == CategoryType.Needy) {
      return ImageConstants.disaster;
    } else {
      return "";
    }
  }
}
