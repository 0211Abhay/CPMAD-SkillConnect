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
    apiKey: 'AIzaSyAL-tt-vUPzWW41RNXT6yW2FtuJrHW-1D8',
    appId: '1:609621391548:web:58ac3f1b3321479d67f8b9',
    messagingSenderId: '609621391548',
    projectId: 'skillconnect-app-cf044',
    authDomain: 'skillconnect-app-cf044.firebaseapp.com',
    storageBucket: 'skillconnect-app-cf044.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZTHKkc5GpWKb9CBYyJsw1qQ7sYP9TsiQ',
    appId: '1:609621391548:android:b183670b20c94c5567f8b9',
    messagingSenderId: '609621391548',
    projectId: 'skillconnect-app-cf044',
    storageBucket: 'skillconnect-app-cf044.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaRYB38jdFyzHIWO1jAJY_1b2ISGjMPR8',
    appId: '1:609621391548:ios:5d01e3361667ee1367f8b9',
    messagingSenderId: '609621391548',
    projectId: 'skillconnect-app-cf044',
    storageBucket: 'skillconnect-app-cf044.firebasestorage.app',
    iosBundleId: 'com.example.skillconnectApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaRYB38jdFyzHIWO1jAJY_1b2ISGjMPR8',
    appId: '1:609621391548:ios:5d01e3361667ee1367f8b9',
    messagingSenderId: '609621391548',
    projectId: 'skillconnect-app-cf044',
    storageBucket: 'skillconnect-app-cf044.firebasestorage.app',
    iosBundleId: 'com.example.skillconnectApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAL-tt-vUPzWW41RNXT6yW2FtuJrHW-1D8',
    appId: '1:609621391548:web:31bc3a703f1562c167f8b9',
    messagingSenderId: '609621391548',
    projectId: 'skillconnect-app-cf044',
    authDomain: 'skillconnect-app-cf044.firebaseapp.com',
    storageBucket: 'skillconnect-app-cf044.firebasestorage.app',
  );
}
