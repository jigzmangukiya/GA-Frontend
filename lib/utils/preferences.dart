// import 'package:shared_preferences/shared_preferences.dart';

// class Preference {
//   static const String languageCode = "languageCode";
//   // static const String _isUserLoggedIn = "isUserLoggedIn";
//   static const String userId = "userId";
//   static const String geoHashId = "geoHashId";

//   // ------------------ SINGLETON ----------------------- //
//   static final Preference _preference = Preference._internal();

//   factory Preference() {
//     return _preference;
//   }

//   Preference._internal();

//   static Preference get shared => _preference;

//   static SharedPreferences? _pref;

//   // make connection with preference only once in application /
//   Future<SharedPreferences?> instance() async {
//     if (_pref != null) return _pref;
//     await SharedPreferences.getInstance().then((onValue) {
//       _pref = onValue;
//     }).catchError((onError) {
//       _pref = null;
//     });
//     return _pref;
//   }

//   clearSharedPreference() {
//     _pref?.clear();
//   }

//   // bool getIsUserLoggedIn() {
//   //   return _pref?.getBool(_isUserLoggedIn) ?? false;
//   // }

//   // setIsUserLoggedIn(bool value) {
//   //   _pref?.setBool(_isUserLoggedIn, value);
//   // }

//   // String? getUserID() {
//   //   return _pref?.getString(userId) ?? null;
//   // }

//   // setUserID(String value) {
//   //   _pref?.setString(userId, value);
//   // }

//   // String? getGeoHashID() {
//   //   return _pref?.getString(geoHashId) ?? null;
//   // }

//   // setGeoHashID(String value) {
//   //   _pref?.setString(geoHashId, value);
//   // }

//   /* remove  element from preferences */
//   Future<bool?>? remove(key, {multi = false}) async {
//     SharedPreferences? pref = await instance();
//     if (multi) {
//       key.forEach((f) async {
//         return await pref?.remove(f);
//       });
//     } else {
//       return await pref?.remove(key);
//     }

//     return new Future.value(true);
//   }

//   String? get getLanguageCode {
//     return _pref?.getString(languageCode) ?? "en";
//   }

//   setLanguageCode(String value) {
//     _pref?.setString(languageCode, value);
//   }
// }
