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
    apiKey: 'AIzaSyDcGGhf9ZlRDBskdsMIN0qcxKDQ-Gc2cNI',
    appId: '1:483134690799:web:b036e86810818a1885521a',
    messagingSenderId: '483134690799',
    projectId: 'petapp-a9d6f',
    authDomain: 'petapp-a9d6f.firebaseapp.com',
    storageBucket: 'petapp-a9d6f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDOCZPSAjIKQ7iq2dVt2OjLzUTaXPwJIo',
    appId: '1:483134690799:android:0f9d21110ae34d3b85521a',
    messagingSenderId: '483134690799',
    projectId: 'petapp-a9d6f',
    storageBucket: 'petapp-a9d6f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVS1FzIZrP8ZKupFivJfaZ7ePCHXOB5oo',
    appId: '1:483134690799:ios:b9976c5bd41dbcc085521a',
    messagingSenderId: '483134690799',
    projectId: 'petapp-a9d6f',
    storageBucket: 'petapp-a9d6f.firebasestorage.app',
    iosBundleId: 'com.example.petApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVS1FzIZrP8ZKupFivJfaZ7ePCHXOB5oo',
    appId: '1:483134690799:ios:b9976c5bd41dbcc085521a',
    messagingSenderId: '483134690799',
    projectId: 'petapp-a9d6f',
    storageBucket: 'petapp-a9d6f.firebasestorage.app',
    iosBundleId: 'com.example.petApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcGGhf9ZlRDBskdsMIN0qcxKDQ-Gc2cNI',
    appId: '1:483134690799:web:54da84b5278d7e8d85521a',
    messagingSenderId: '483134690799',
    projectId: 'petapp-a9d6f',
    authDomain: 'petapp-a9d6f.firebaseapp.com',
    storageBucket: 'petapp-a9d6f.firebasestorage.app',
  );
}