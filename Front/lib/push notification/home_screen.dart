import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// 이 기본 화면에서 화면 Homescreen -> notification_screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        Navigator.pushNamed(
          context,
          '/notification',
          arguments: {
            'title': message.data['title'] ?? 'No Title',
            'body': message.data['body'] ?? 'No Body',
            'style': message.data['style'] ?? 'No Style',
          },
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        Navigator.pushNamed(
          context,
          '/notification',
          arguments: {
            'title': message.data['title'] ?? 'No Title',
            'body': message.data['body'] ?? 'No Body',
            'style': message.data['style'] ?? 'No Style',
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Waiting for notifications...'),
      ),
    );
  }
}
