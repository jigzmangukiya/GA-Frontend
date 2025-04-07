import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:guardian_angel/modules/home/models/chat_model.dart';
import 'package:guardian_angel/utils/color_utils.dart';
import 'package:guardian_angel/utils/full_screen_loader.dart';
import 'package:guardian_angel/utils/http_services.dart';
import 'package:guardian_angel/utils/image_utils.dart';
import 'package:guardian_angel/utils/preference_constant.dart';
import 'package:guardian_angel/utils/service_locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isFullScreenHeight = false;
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  HttpService httpService = locator<HttpService>();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: isFullScreenHeight ? 1 : 0.5, // Adjust this value to set the initial height (e.g., half screen)
      child: Container(
        padding: EdgeInsets.only(bottom: 26),
        decoration: BoxDecoration(
          color: Color.fromRGBO(232, 230, 255, 0.80), // Set the color with transparency
          borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
                color: ColorConstant.getColorFromHex('D6D3FF'),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 26, right: 26, top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(ImageConstants.angel, height: 36, width: 36),
                        Text(
                          'Talk with Angel',
                          style: TextStyle(fontSize: 20.0, color: ColorConstant.getColorFromHex("4D4D4D")),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  isFullScreenHeight = !isFullScreenHeight;
                                  setState(() {});
                                },
                                child: Image.asset(ImageConstants.heightAdjust, height: 16, width: 16, fit: BoxFit.cover)),
                            SizedBox(width: 22),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Image.asset(ImageConstants.closeIcon, height: 16, width: 16, fit: BoxFit.cover)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: _messages.length == 0
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "What should I carry with me in case of flooding in my area?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ColorConstant.getColorFromHex("4D4D4D"), fontSize: 18),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildMessage(_messages[index]);
                      },
                    ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    bool isAngel = message.sender == "Angel";
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Align(
        alignment: isAngel ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: isAngel ? ColorConstant.getColorFromHex("D6D3FF") : Color(0XFFFEFEFE),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message.text,
              textAlign: isAngel ? TextAlign.left : TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildMessage(Message message) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.only(left: message.sender == "Angel" ? 16 : 36, right: message.sender == "Angel" ? 26 : 16),
  //     title: Container(
  //       width: MediaQuery.of(context).size.width * 0.4,
  //       decoration:
  //           BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: message.sender == "Angel" ? ColorConstant.getColorFromHex("D6D3FF") : Color(0XFFFEFEFE)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Text(
  //           message.text,
  //           textAlign: message.sender == "You" ? TextAlign.right : TextAlign.left,
  //         ),
  //       ),
  //     ),
  //     subtitle: Text(
  //       message.sender,
  //       textAlign: message.sender == "You" ? TextAlign.right : TextAlign.left,
  //     ),
  //   );
  // }

  Widget _buildMessageInput() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26.0),
                ),
                child: TextField(
                  style: TextStyle(color: ColorConstant.getColorFromHex("3C3C3C"), fontSize: 16),
                  controller: _textController,
                  onSubmitted: (value) {},
                  decoration: InputDecoration(
                      hintText: 'Type your Message here',
                      hintStyle: TextStyle(color: ColorConstant.hintTextColor, fontSize: 16),
                      contentPadding: EdgeInsets.all(16.0),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () async {
                              // await Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => SpeechToTextExample(),
                              //   ),
                              // );
                            },
                            child: Image.asset(ImageConstants.recordIcon, height: 26, width: 26)),
                      )),
                ),
              ),
            ),
            SizedBox(width: 16),
            InkWell(
                onTap: () {
                  _sendMessage(_textController.text);
                },
                child: Image.asset(ImageConstants.sendIcon, height: 26, width: 26)),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.isNotEmpty) {
      FocusScope.of(context).requestFocus(new FocusNode());
      await chatApi();
    }
  }

  chatApi() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = await prefs.getString(PreferenceConstant.userId);
    var language = await prefs.getString(PreferenceConstant.languageCode);
    LoadingIndicator.show(context);
    Future.delayed(Duration(milliseconds: 500), () async {
      try {
        http.Response response = await httpService.chatApi(question: _textController.text.trim(), outputLanguage: language ?? "en", id: userId ?? "");
        LoadingIndicator.dismiss();
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);

          ChatResponseModel chatResponse = ChatResponseModel.fromJson(responseBody);

          String? audioUrl = chatResponse.audio;
          String? data = chatResponse.data;

          print('Audio URL: $audioUrl');
          print('Data: $data');
          _messages.add(Message(text: _textController.text, sender: 'You'));
          _messages.add(Message(text: chatResponse.data ?? "", sender: 'Angel'));
          _textController.clear();

          setState(() {});
        } else {
          LoadingIndicator.dismiss();
          AwesomeDialog(
            context: context,
            width: MediaQuery.of(context).size.width * 0.6,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            dismissOnTouchOutside: false,
            headerAnimationLoop: false,
            title: 'ERROR',
            desc: "Something went wrong!",
            btnOkOnPress: () {},
          )..show();
        }
      } catch (e) {
        LoadingIndicator.dismiss();
      }
    });
  }
}
