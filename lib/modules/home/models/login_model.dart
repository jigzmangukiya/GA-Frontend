class LoginRequestModel {
  String? firebaseUserID;

  LoginRequestModel({this.firebaseUserID});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firebaseUserID != null) data['FirebaseUserID'] = firebaseUserID;
    return data;
  }
}

class LoginResponseModel {
  String? message;
  String? userID;
  String? error;
  bool? userExists;

  LoginResponseModel({this.message, this.userID, this.error, this.userExists});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userID = json['userID'];
    error = json['error'];
    userExists = json['userExists'];
  }
}
