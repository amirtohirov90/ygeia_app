import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAS1ynTQkyx7ZkjdMsB187_pz57sbOXN8',
    appId: '1:1065003776220:android:16efac7b2a23250cae1c19',
    messagingSenderId: '1065003776220',
    projectId: 'ygeia-c6ec5',
    storageBucket: 'ygeia-c6ec5.firebasestorage.app',
  );
}
