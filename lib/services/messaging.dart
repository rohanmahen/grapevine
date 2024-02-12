import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
   await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> subscribeToCircle(circleName) async {
    // Subscribe to a the all topic
    await fcm.subscribeToTopic(circleName);
  }

  Future<void> subscribeToUniversalTopic() async {
    // Subscribe to a the all topic
    await fcm.subscribeToTopic('universal');
  }
}
