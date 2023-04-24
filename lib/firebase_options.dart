// coverage:ignore-start
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
    apiKey: 'AIzaSyA9lbUyRY0S23XZBz9bodeE6Hz8NDSUESU',
    appId: '1:1023203529666:web:6ba59d758522d3b96f3c5b',
    messagingSenderId: '1023203529666',
    projectId: 'kwiz-4ab1f',
    authDomain: 'kwiz-4ab1f.firebaseapp.com',
    storageBucket: 'kwiz-4ab1f.appspot.com',
    measurementId: 'G-N7V7L605F0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD33Z0Zw_7PiWCuwJyRJWW2LSYiAlpMnDA',
    appId: '1:1023203529666:android:515a3acd384bf7e06f3c5b',
    messagingSenderId: '1023203529666',
    projectId: 'kwiz-4ab1f',
    storageBucket: 'kwiz-4ab1f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC716MHaV_R_nLSnGDkvXeLeeTdAge1u20',
    appId: '1:1023203529666:ios:4e384034d60e57d66f3c5b',
    messagingSenderId: '1023203529666',
    projectId: 'kwiz-4ab1f',
    storageBucket: 'kwiz-4ab1f.appspot.com',
    iosClientId:
        '1023203529666-3vurghs0ser6ighqokpfdh1e5d91eqgo.apps.googleusercontent.com',
    iosBundleId: 'com.example.kwizV2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC716MHaV_R_nLSnGDkvXeLeeTdAge1u20',
    appId: '1:1023203529666:ios:4e384034d60e57d66f3c5b',
    messagingSenderId: '1023203529666',
    projectId: 'kwiz-4ab1f',
    storageBucket: 'kwiz-4ab1f.appspot.com',
    iosClientId:
        '1023203529666-3vurghs0ser6ighqokpfdh1e5d91eqgo.apps.googleusercontent.com',
    iosBundleId: 'com.example.kwizV2',
  );
}

// coverage:ignore-end