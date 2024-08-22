import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyFCMPage extends StatefulWidget {
  @override
  _MyFCMPageState createState() => _MyFCMPageState();
}

class _MyFCMPageState extends State<MyFCMPage> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _getFCMToken();
  }

  // FCM 토큰을 가져오는 함수
  Future<void> _getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _fcmToken = token;
      });
      print('FCM Token: $_fcmToken');  // FCM 토큰 출력
    } catch (e) {
      print('Error fetching FCM Token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Token Page'),
      ),
      body: Center(
        child: Text(
          _fcmToken != null ? 'FCM Token: $_fcmToken' : 'Loading FCM Token...',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
