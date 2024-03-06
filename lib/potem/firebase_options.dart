// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyD249ey28RBThGsHoxu0789Jmet5I6o6As',
    appId: '1:562570400279:web:cc300fc823dffcc20b4252',
    messagingSenderId: '562570400279',
    projectId: 'owe-me-stuff',
    authDomain: 'owe-me-stuff.firebaseapp.com',
    databaseURL: 'https://owe-me-stuff-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'owe-me-stuff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOzJP8tfmpyPpQ4MQIGJOj6uI2C326Ygw',
    appId: '1:562570400279:android:eeb4107c53232d790b4252',
    messagingSenderId: '562570400279',
    projectId: 'owe-me-stuff',
    databaseURL: 'https://owe-me-stuff-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'owe-me-stuff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeTgoA9d26hcqHmNwnKxOstnNWDDz79nU',
    appId: '1:562570400279:ios:be77ad813ef1a5590b4252',
    messagingSenderId: '562570400279',
    projectId: 'owe-me-stuff',
    databaseURL: 'https://owe-me-stuff-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'owe-me-stuff.appspot.com',
    iosBundleId: 'com.example.oweme',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAeTgoA9d26hcqHmNwnKxOstnNWDDz79nU',
    appId: '1:562570400279:ios:be77ad813ef1a5590b4252',
    messagingSenderId: '562570400279',
    projectId: 'owe-me-stuff',
    databaseURL: 'https://owe-me-stuff-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'owe-me-stuff.appspot.com',
    iosBundleId: 'com.example.oweme',
  );
}
