class FeedbackRequestModel {
  String? contributionID;
  String? userID;
  String? feedback;

  FeedbackRequestModel({this.contributionID, this.userID, this.feedback});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contributionID'] = contributionID;
    data['userID'] = userID;
    data['feedback'] = feedback;
    return data;
  }
}
