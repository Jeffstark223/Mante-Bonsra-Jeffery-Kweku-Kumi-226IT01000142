// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDVRYRqdlAzGtBDlUHsHaYrQkemvA-s62I',
          appId: '1:375627026273:ios:4d1e571fdf0f261525bf20',
          messagingSenderId: '375627026273',
          projectId: 'class-week5',
          storageBucket: 'class-week5.firebasestorage.app',
        );
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'YOUR_ANDROID_API_KEY',
          appId: 'YOUR_ANDROID_APP_ID',
          messagingSenderId: 'YOUR_ANDROID_MESSAGING_SENDER_ID',
          projectId: 'class-week5',
          storageBucket: 'class-week5.firebasestorage.app',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}