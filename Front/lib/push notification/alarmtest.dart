import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:vibration/vibration.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmTest extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AlarmTest> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _requestPermissions();
  }

  // 알림 권한 요청
  Future<void> _requestPermissions() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  // 알림 초기화
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String? payload = response.payload;
        if (payload != null) {
          print("Notification clicked with payload: $payload");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondPage(payload)),
          );
        }
      },
    );

    // 채널 생성 (Android 8.0 이상)
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'arrhythmia_channel_id', // 채널 ID
      '부정맥 감지', // 채널 이름
      description: '부정맥 감지 알림을 위한 채널', // 채널 설명
      importance: Importance.max, // 중요도 설정
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  // 알림 트리거 메서드
  Future<void> _showArrhythmiaNotification() async {
    // final bool hasVibrator = await Vibration.hasVibrator() ?? false;
    // if (hasVibrator) {
    //   Vibration.vibrate(duration: 1000); // 1초간 진동
    // }

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'arrhythmia_channel_id', // 채널 ID
      '부정맥 감지', // 채널 이름
      channelDescription: '부정맥 감지 알림을 위한 채널', // 채널 설명
      importance: Importance.max, // 중요도 설정
      priority: Priority.high, // 우선순위 설정
      ticker: 'ticker',
      icon: 'drawable/heart', // 하트 아이콘 사용
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      '부정맥 감지됨', // 알림 제목
      '부정맥이 감지되었습니다. 건강 상태를 확인하세요.', // 알림 내용
      platformChannelSpecifics,
      payload: 'arrhythmia', // 알림과 함께 전달할 데이터
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("부정맥 감지"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showArrhythmiaNotification, // 버튼을 누르면 알림이 트리거됨
          child: Text('부정맥 확인'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String? payload;

  SecondPage(this.payload, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Payload: ${payload ?? 'No payload'}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}


