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
    apiKey: 'AIzaSyDP-zZz9vJZqCzxXRTWNoRKPq-PljTbHfk',
    appId: '1:252988818920:web:79307a027ac6922233505d',
    messagingSenderId: '252988818920',
    projectId: 'bookify-b3456',
    authDomain: 'bookify-b3456.firebaseapp.com',
    storageBucket: 'bookify-b3456.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBINK24rwagaTOslYgAdKzw8_LDfl1c5eg',
    appId: '1:252988818920:android:c529539b8b4804df33505d',
    messagingSenderId: '252988818920',
    projectId: 'bookify-b3456',
    storageBucket: 'bookify-b3456.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-AQsxcgEsNN2PcZXD8M0i5Aw6ynTUJiE',
    appId: '1:252988818920:ios:682e83c9fdc70db233505d',
    messagingSenderId: '252988818920',
    projectId: 'bookify-b3456',
    storageBucket: 'bookify-b3456.appspot.com',
    iosBundleId: 'com.example.bookify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-AQsxcgEsNN2PcZXD8M0i5Aw6ynTUJiE',
    appId: '1:252988818920:ios:682e83c9fdc70db233505d',
    messagingSenderId: '252988818920',
    projectId: 'bookify-b3456',
    storageBucket: 'bookify-b3456.appspot.com',
    iosBundleId: 'com.example.bookify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDP-zZz9vJZqCzxXRTWNoRKPq-PljTbHfk',
    appId: '1:252988818920:web:f4cdf2724420749933505d',
    messagingSenderId: '252988818920',
    projectId: 'bookify-b3456',
    authDomain: 'bookify-b3456.firebaseapp.com',
    storageBucket: 'bookify-b3456.appspot.com',
  );
}
