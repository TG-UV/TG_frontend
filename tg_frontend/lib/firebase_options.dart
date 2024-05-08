// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyCZDVJ0OtNXF9pGp65XbmYmIkkieT7Y9bo',
    appId: '1:221302898477:web:c23dcf4d969dd9e4e65da4',
    messagingSenderId: '221302898477',
    projectId: 'rayo-2aa1a',
    authDomain: 'rayo-2aa1a.firebaseapp.com',
    storageBucket: 'rayo-2aa1a.appspot.com',
    measurementId: 'G-H5KWBD1J69',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBulidJNbRSNiPKxIkLJjK3hGf7z3DdEOI',
    appId: '1:221302898477:android:0d7ca8cd4df2ab48e65da4',
    messagingSenderId: '221302898477',
    projectId: 'rayo-2aa1a',
    storageBucket: 'rayo-2aa1a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChoI8MNZYsLDBxYpm26lBxr2_i8HTF-zc',
    appId: '1:221302898477:ios:c8e7daffbc8b8ed3e65da4',
    messagingSenderId: '221302898477',
    projectId: 'rayo-2aa1a',
    storageBucket: 'rayo-2aa1a.appspot.com',
    iosBundleId: 'com.example.tgFrontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChoI8MNZYsLDBxYpm26lBxr2_i8HTF-zc',
    appId: '1:221302898477:ios:c8e7daffbc8b8ed3e65da4',
    messagingSenderId: '221302898477',
    projectId: 'rayo-2aa1a',
    storageBucket: 'rayo-2aa1a.appspot.com',
    iosBundleId: 'com.example.tgFrontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCZDVJ0OtNXF9pGp65XbmYmIkkieT7Y9bo',
    appId: '1:221302898477:web:99a899c41e1aa484e65da4',
    messagingSenderId: '221302898477',
    projectId: 'rayo-2aa1a',
    authDomain: 'rayo-2aa1a.firebaseapp.com',
    storageBucket: 'rayo-2aa1a.appspot.com',
    measurementId: 'G-Y0R8N5R88Z',
  );

}