import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    String? token = await messaging.getToken();
    if (token != null) {
      print('FCM token: $token');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('FCM message received foreground: ${message.notification?.title}');
    });
  }
  Future<String> checkUserRole(User user) async {
    DocumentSnapshot doc =
    await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

    String role = doc["role"];
    return role;

  }


  static Future<void> saveTokenForUser(String uid, String token) async {
    await _firestore.collection('fcmTokens').doc(uid).set({'token': token});
  }

  static Future<String?> tokenForUser(String uid) async {
    final doc = await _firestore.collection('fcmTokens').doc(uid).get();
    return doc.exists ? doc['token'] as String? : null;
  }
}