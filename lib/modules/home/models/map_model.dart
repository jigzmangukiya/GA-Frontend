class MarkerResponseData {
  String? userID;
  String? domainType;
  String? description;
  String? foodType;
  double? latitude;
  double? longitude;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? contributionID;
  int? upvoteCount;
  int? downvoteCount;
  String? image;
  // String? alert;
  double? distance;
  String? disasterType;
  String? name;
  String? species;
  String? behavior;
  String? gender;
  String? clothingType;
  MarkerResponseData({
    this.userID,
    this.domainType,
    this.description,
    this.foodType,
    this.latitude,
    this.longitude,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.contributionID,
    this.upvoteCount,
    this.downvoteCount,
    this.image,
    // this.alert,
    this.distance,
    this.disasterType,
    this.name,
    this.species,
    this.behavior,
    this.gender,
    this.clothingType,
  });

  MarkerResponseData.fromJson(Map<String, dynamic> json) {
    userID = json['userID']?.toString() ?? "";
    domainType = json['domainType'] ?? "";
    description = json['description'] ?? "";
    foodType = json['foodType'] ?? "";
    latitude = json['latitude'] ?? 0.0;
    longitude = json['longitude'] ?? 0.0;
    startDate = json['startDate'] ?? "";
    endDate = json['endDate'] ?? "";
    startTime = json['startTime'] ?? "";
    endTime = json['endTime'] ?? "";
    contributionID = json['contributionID'] ?? "";
    upvoteCount = json['upvoteCount'] ?? 0;
    downvoteCount = json['downvoteCount'] ?? 0;
    image = json['image'] ?? "";
    // alert = json['alert'] ?? "";
    distance = json['distance'] ?? 0.0;
    disasterType = json['disasterType'] ?? "";
    name = json['name'] ?? "";
    species = json['species'] ?? "";
    behavior = json['behavior'] ?? "";
    behavior = json['gender'] ?? "";
    clothingType = json['clothingType'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID ?? "";
    data['domainType'] = this.domainType ?? "";
    data['description'] = this.description ?? "";
    data['foodType'] = this.foodType ?? "";
    data['latitude'] = this.latitude ?? 0.0;
    data['longitude'] = this.longitude ?? 0.0;
    data['startDate'] = this.startDate ?? "";
    data['endDate'] = this.endDate ?? "";
    data['startTime'] = this.startTime ?? "";
    data['endTime'] = this.endTime ?? "";
    data['contributionID'] = this.contributionID;
    data['upvoteCount'] = this.upvoteCount ?? 0;
    data['downvoteCount'] = this.downvoteCount ?? 0;
    data['image'] = this.image ?? "";
    // data['alert'] = this.alert;
    data['distance'] = this.distance ?? 0.0;
    data['disasterType'] = this.disasterType ?? "";
    data['name'] = this.name ?? "";
    data['species'] = this.species ?? "";
    data['behavior'] = this.behavior ?? "";
    data['gender'] = this.gender ?? "";
    data['clothingType'] = this.clothingType ?? "";
    return data;
  }
}
