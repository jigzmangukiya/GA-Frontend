class Message {
  final String text;
  final String sender;

  Message({required this.text, required this.sender});
}

class ChatRequestModel {
  String? question;
  String? outputLanguage;
  String? id;

  ChatRequestModel({this.question, this.outputLanguage, this.id});

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'output_language': outputLanguage,
      'id': id,
    };
  }
}

class ChatResponseModel {
  String? audio;
  String? data;

  ChatResponseModel({this.audio, this.data});

  ChatResponseModel.fromJson(Map<String, dynamic> json) {
    audio = json['audio'];
    data = json['data'];
  }
}
