// File generated using `flutterfire configure` command
// Replace this with your actual Firebase configuration
// To generate: run `flutterfire configure` in your terminal

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  // TODO: Replace with your actual Firebase Android configuration
  // Get from Firebase Console -> Project Settings -> Your apps -> Android app
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCagnE5moPz6YyACiElewdH-_aRPMuO6LE',
    appId: '1:570276633475:android:849503309311c98b96f4b6',
    messagingSenderId: '570276633475',
    projectId: 'malawi-invest',
    databaseURL: 'https://malawi-invest-default-rtdb.firebaseio.com/',
    storageBucket: 'malawi-invest.firebasestorage.app',
  );

  // TODO: Replace with your actual Firebase iOS configuration
  // Get from Firebase Console -> Project Settings -> Your apps -> iOS app
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'com.example.malawiInvest',
  );

  // Firebase Web configuration
  // Get these values from Firebase Console -> Project Settings -> Your apps -> Web app
  // Or run: flutterfire configure (and select Web platform)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCagnE5moPz6YyACiElewdH-_aRPMuO6LE',
    appId: '1:570276633475:web:afc408f4b7c8e90696f4b6', // TODO: Replace with actual web app ID from Firebase Console
    messagingSenderId: '570276633475',
    projectId: 'malawi-invest',
    authDomain: 'malawi-invest.firebaseapp.com',
    databaseURL: 'https://malawi-invest-default-rtdb.firebaseio.com/',
    storageBucket: 'malawi-invest.firebasestorage.app',
  );
}

