// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBFF0p5JHAEP55jeqQkfWnHbCFxIOoCo3U',
    appId: '1:634837106528:web:7271d9695cc864f5b76805',
    messagingSenderId: '634837106528',
    projectId: 'rotikapdamakan-2abf7',
    authDomain: 'rotikapdamakan-2abf7.firebaseapp.com',
    storageBucket: 'rotikapdamakan-2abf7.appspot.com',
    measurementId: 'G-Q27QY0TX9J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcg_ysPrzNy0y11YENFj59xGkC7gp4pJY',
    appId: '1:723488232923:android:96a96fd7a5eee0485843fe',
    messagingSenderId: '723488232923',
    projectId: 'guardian-angel-de0cc',
    storageBucket: 'guardian-angel-de0cc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDX3bMGKdulD4S7xEujNzt1FCD0nBRWkJg',
    appId: '1:634837106528:ios:867de115be74d9d4b76805',
    messagingSenderId: '723488232923',
    projectId: 'rotikapdamakan-2abf7',
    storageBucket: 'rotikapdamakan-2abf7.appspot.com',
    iosBundleId: 'com.example.rotiKapdaMakan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDX3bMGKdulD4S7xEujNzt1FCD0nBRWkJg',
    appId: '1:634837106528:ios:a6f3ad52755da6ddb76805',
    messagingSenderId: '634837106528',
    projectId: 'rotikapdamakan-2abf7',
    storageBucket: 'rotikapdamakan-2abf7.appspot.com',
    iosBundleId: 'com.example.rotiKapdaMakan.RunnerTests',
  );
}
