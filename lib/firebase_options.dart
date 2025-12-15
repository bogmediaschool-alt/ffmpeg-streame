import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'YOUR_API_KEY'),
      appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: 'YOUR_APP_ID'),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'SENDER_ID'),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'YOUR_PROJECT_ID'),
      androidClientId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID', defaultValue: 'ANDROID_APP_ID'),
    );
  }
}
