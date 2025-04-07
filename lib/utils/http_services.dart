import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_angel/modules/home/models/chat_model.dart';
import 'package:guardian_angel/modules/home/models/contribute_model.dart';
import 'package:guardian_angel/modules/home/models/feedback_model.dart';
import 'package:guardian_angel/modules/home/models/login_model.dart';
import 'package:guardian_angel/modules/home/models/signup_model.dart';
import 'package:guardian_angel/utils/common_utils.dart';
import 'package:guardian_angel/utils/custom_exception.dart';
import 'package:guardian_angel/utils/full_screen_loader.dart';
import 'package:guardian_angel/utils/preference_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  // String prodUrl = "https://prod-platform.follocare.com"; // production url is changed
  // String devChatUrl = "http://10.2.8.138:7000";
  // String devUrl = "http://10.2.8.138:7001";
  // String devMqttUrl = "http://10.2.8.138:8000";

  String devChatUrl = "https://canvas.iiit.ac.in/chatbotbeprod";
  String devUrl = "https://canvas.iiit.ac.in/gaurdiananglebeprod";
  String devMqttUrl = "https://canvas.iiit.ac.in/gaurdiananglebeprod";

  String currentChatUrl = '';
  String currentUrl = '';
  String currentMqttUrl = '';

  // TODO: Change url when releasing
  HttpService() {
    currentChatUrl = devChatUrl;
    currentUrl = devUrl;
    currentMqttUrl = devMqttUrl;
  }

  dynamic _responseChecker(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;

      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());

      case 404:
        return response;

      case 500:
        // navigationService.customAlertDialog(
        //     message: 'Error occured while Communication with Server with StatusCode : ${response.statusCode}', buttonText: 'Okay');
        LoadingIndicator.dismiss();
        AwesomeDialog(
          context: Utils.globalContext!,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          dismissOnTouchOutside: true,
          headerAnimationLoop: false,
          title: 'Error',
          desc: "Error occurred while Communication with Server with StatusCode : ${response.statusCode}",
          btnOkOnPress: () {},
          btnOkText: "Okay",
        )..show();
        break;

      default:
        throw FetchDataException('Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  _postRequest({required String url, dynamic body}) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, OPTIONS, GET",
        },
      ).timeout(Duration(seconds: 60));

      // Check if response is successful
      if (response.statusCode != 200) {
        throw Exception("Failed to post request");
      }

      response = _responseChecker(response);
      print(response.toString());
    } on TimeoutException catch (e) {
      print(e.toString());
      LoadingIndicator.dismiss();
      AwesomeDialog(
        context: Utils.globalContext!,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        dismissOnTouchOutside: true,
        headerAnimationLoop: false,
        title: 'Connection Timeout',
        desc: "It seems your internet connection is down. Please try again later!",
        btnOkOnPress: () {},
        btnOkText: "Okay",
      )..show();
    } on SocketException {
      LoadingIndicator.dismiss();
      AwesomeDialog(
        context: Utils.globalContext!,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        dismissOnTouchOutside: true,
        headerAnimationLoop: false,
        title: 'No Internet Connection',
        desc: "It seems your internet connection is off. Please check your connectivity.",
        btnOkOnPress: () {},
        btnOkText: "Okay",
      )..show();
      throw FetchDataException('No Internet connection');
    } on Exception catch (e) {
      developer.log("Error == $e");
      LoadingIndicator.dismiss();
      AwesomeDialog(
        context: Utils.globalContext!,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        dismissOnTouchOutside: true,
        headerAnimationLoop: false,
        title: 'Error',
        desc: "Something went wrong!",
        btnOkOnPress: () {},
        btnOkText: "Okay",
      )..show();
      developer.log(e.toString());
    }

    if (response == null) {
      throw Exception("Response is null after request");
    }

    return response;
  }

  _getRequest({required String url}) async {
    http.Response? response;
    try {
      response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS, GET",
      }).timeout(Duration(seconds: 30));
      response = _responseChecker(response);
      print(response.toString());
    } on TimeoutException catch (e) {
      print(e.toString());
      LoadingIndicator.dismiss();
      AwesomeDialog(
        context: Utils.globalContext!,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        dismissOnTouchOutside: true,
        headerAnimationLoop: false,
        title: 'Connection Timeout',
        desc: "It seems your internet connection down. Please try again later!",
        btnOkOnPress: () {},
        btnOkText: "Okay",
      )..show();
    } on SocketException {
      LoadingIndicator.dismiss();
      // AwesomeDialog(
      //   context: Utils.globalContext!,
      //   dialogType: DialogType.error,
      //   animType: AnimType.topSlide,
      //   dismissOnTouchOutside: true,
      //   headerAnimationLoop: false,
      //   title: 'No Internet Connection',
      //   desc: "It seems your internet connection off, Please check your connectivity.",
      //   btnOkOnPress: () {},
      //   btnOkText: "Okay",
      // )..show();
      // throw FetchDataException('No Internet connection');
    } on Exception catch (_) {
      developer.log("Error == $_");
      LoadingIndicator.dismiss();
      AwesomeDialog(
        context: Utils.globalContext!,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        dismissOnTouchOutside: true,
        headerAnimationLoop: false,
        title: 'Error',
        desc: "Something went wrong!",
        btnOkOnPress: () {},
        btnOkText: "Okay",
      )..show();
      developer.log(_.toString());
    }
    return response;
  }

  chatApi({
    required String question,
    required String outputLanguage,
    required String id,
  }) async {
    String url = currentChatUrl + '/chat';
    ChatRequestModel obj = ChatRequestModel();
    obj.question = question;
    obj.outputLanguage = outputLanguage;
    obj.id = id;
    http.Response response = await _postRequest(url: url, body: obj.toJson());
    developer.log(response.toString());
    return response;
  }

  contributionApi({required ContributeModel model}) async {
    String url = currentUrl + '/contribute_food';
    try {
      ContributeModel obj = ContributeModel();
      obj = model;
      developer.log("contribution model : " + obj.toJson().toString());
      http.Response response = await _postRequest(url: url, body: obj.toJson());
      developer.log(response.toString());
      return response;
    } catch (e) {
      print('Error in contributionApi: $e');
      return null;
    }
  }

  signupApi({required SignupRequestModel model}) async {
    String url = currentUrl + '/register_user';
    try {
      SignupRequestModel obj = SignupRequestModel();
      obj = model;
      http.Response response = await _postRequest(url: url, body: obj.toJson());
      developer.log(response.toString());
      return response;
    } catch (e) {
      print('Error in signup api call: $e');
      return null;
    }
  }

  loginApi({
    required String firebaseUserID,
  }) async {
    String url = currentUrl + '/login_user';
    LoginRequestModel obj = LoginRequestModel();
    obj.firebaseUserID = firebaseUserID;
    http.Response response = await _postRequest(url: url, body: obj.toJson());
    developer.log(response.toString());
    return response;
  }

  getGeoHashApi({required double latitude, required double longitutde}) async {
    String url = currentMqttUrl + '/getGeohash?lat=$latitude&long=$longitutde';
    http.Response response = await _getRequest(url: url);
    developer.log(response.toString());
    return response;
  }

  contributeFeedbackApi({required FeedbackRequestModel model}) async {
    String url = currentUrl + '/contributionFeedback';
    FeedbackRequestModel obj = FeedbackRequestModel();
    obj = model;
    http.Response response = await _postRequest(url: url, body: obj.toJson());
    developer.log(response.toString());
    return response;
  }

  getContributionsDataApi({required Position currentPosition}) async {
    final prefs = await SharedPreferences.getInstance();
    var languageCode = await prefs.getString(PreferenceConstant.languageCode);
    if (languageCode == "null") {
      languageCode = "english";
    }
    String url = devUrl +
        '/get_past_contributions?latitude=${currentPosition.latitude}&longitude=${currentPosition.longitude}&language=${languageCode}';
    http.Response response = await _getRequest(url: url);
    developer.log(response.toString());
    return response;
  }
}
