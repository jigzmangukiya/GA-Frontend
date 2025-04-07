class SignupRequestModel {
  String? phoneNo;
  String? language;
  String? firebaseUserID;
  String? validate;
  String? transport;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;

  SignupRequestModel({
    this.phoneNo,
    this.language,
    this.firebaseUserID,
    this.validate,
    this.transport,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
  });

  SignupRequestModel.fromJson(Map<String, dynamic> json) {
    phoneNo = json['PhoneNo'];
    language = json['Language'];
    firebaseUserID = json['FirebaseUserID'];
    // validate = json['Validate'] != null ? List<String>.from(json['Validate']) : null;
    // transport = json['Transport'] != null ? List<String>.from(json['Transport']) : null;
    firstName = json['FirstName'];
    lastName = json['LastName'];
    dateOfBirth = json['DateOfBirth'];
    gender = json['Gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (phoneNo != null) data['PhoneNo'] = phoneNo;
    if (language != null) data['Language'] = language;
    if (firebaseUserID != null) data['FirebaseUserID'] = firebaseUserID;
    if (validate != null) data['Validate'] = validate;
    if (transport != null) data['Transport'] = transport;
    if (firstName != null) data['FirstName'] = firstName;
    if (lastName != null) data['LastName'] = lastName;
    if (dateOfBirth != null) data['DateOfBirth'] = dateOfBirth;
    if (gender != null) data['Gender'] = gender;
    return data;
  }
}

class SignupResponseModel {
  String? message;
  String? error;
  String? userID;
  String? DateOfBirth;
  String? FirebaseUserID;
  String? FirstName;
  String? Gender;
  String? Language;
  String? LastName;
  String? PhoneNo;
  int? downvoteCount;
  int? upvoteCount;
  bool? userExists;

  SignupResponseModel({
    this.message,
    this.error,
    this.userID,
    this.DateOfBirth,
    this.FirebaseUserID,
    this.FirstName,
    this.Gender,
    this.Language,
    this.LastName,
    this.PhoneNo,
    this.downvoteCount,
    this.upvoteCount,
    this.userExists,
  });

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    userID = json['userID'];
    DateOfBirth = json['DateOfBirth'];
    FirebaseUserID = json['FirebaseUserID'];
    FirstName = json['FirstName'];
    Gender = json['Gender'];
    Language = json['Language'];
    LastName = json['LastName'];
    PhoneNo = json['PhoneNo'];
    downvoteCount = json['downvoteCount'];
    upvoteCount = json['upvoteCount'];
    userExists = json['userExists'];
  }
}
