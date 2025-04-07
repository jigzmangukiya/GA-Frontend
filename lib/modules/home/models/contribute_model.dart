import 'dart:convert';
import 'dart:io';

class ContributeModel {
  String? userID;
  String? domainType;
  String? description;
  String? name;
  String? phone;
  String? foodType;
  String? disasterType;
  String? behavior;
  String? species;
  String? clothingType;
  String? gender;
  String? helpType;
  double? latitude;
  double? longitude;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  File? image;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (userID != null) data['userID'] = userID!;
    if (domainType != null) data['domainType'] = domainType!;
    if (description != null) data['description'] = description!;
    if (name != null) data['name'] = name!;
    if (phone != null) data['phone'] = phone!;
    if (foodType != null) data['foodType'] = foodType!;
    if (disasterType != null) data['disasterType'] = disasterType!;
    if (behavior != null) data['behavior'] = behavior!;
    if (species != null) data['species'] = species!;
    if (clothingType != null) data['clothingType'] = clothingType!;
    if (gender != null) data['gender'] = gender!;
    if (helpType != null) data['helpType'] = helpType!;
    if (latitude != null) data['latitude'] = latitude!;
    if (longitude != null) data['longitude'] = longitude!;
    if (startDate != null) data['startDate'] = startDate!;
    if (endDate != null) data['endDate'] = endDate!;
    if (startTime != null) data['startTime'] = startTime!;
    if (endTime != null) data['endTime'] = endTime!;
    if (image != null) {
      List<int> imageBytes = image!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      data['image'] = base64Image;
    }

    return data;
  }
}

class ContributionResponseModel {
  String? message;
  String? imageFileName;

  ContributionResponseModel({this.message, this.imageFileName});

  ContributionResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    imageFileName = json['image_file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (message != null) data['message'] = message;
    if (imageFileName != null) data['image_file_name'] = imageFileName;

    return data;
  }
}
