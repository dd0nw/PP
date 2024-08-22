import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front/recordPage/recordPage.dart';
import 'package:front/setting/setting_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bottomPage.dart';
import '../ex01_login.dart';
import '../password/passwordPage.dart';
import '../profile/profile.dart';
import '../sensor/sensorattach.dart';
import '../sensor/sensorattach22.dart';
import 'settings_alarm.dart';

class LogoutService {
  //final String baseUrl = 'http://10.0.2.2:3000';
  final String baseUrl = 'http://192.168.27.113:3000';
  final storage = FlutterSecureStorage(); // JWT토큰 저장

  Future<void> logout() async {
    try {
      final token = await storage.read(key: 'jwtToken');
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/user/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Logout successful');
        await storage.delete(key: 'jwtToken');
      } else {
        print('Logout failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while logging out: $e');
    }
  }
}

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final ProfileService _profileService = ProfileService(); // 이메일, 이름 조회
  final LogoutService logoutService = LogoutService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int? lastVariableCheck;
  int? lastVariableStatus;
  Timer? timer;
  Profile? _profile;
  bool _isLoading = true; // 로딩 상태를 추적하기 위한 변수


  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _requestPermissions();
    _startPolling();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      Profile profile = await _profileService.fetchProfile();
      setState(() {
        _profile = profile;
        _isLoading = false; // 데이터 로드 후 로딩 상태 변경
      });
    } catch (e) {
      print('프로필 로드 실패: $e');
      setState(() {
        _isLoading = false; // 오류 발생 시에도 로딩 상태 변경
      });
    }
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
        print('Received notification with payload: $payload');
        if (payload == 'arrhythmia') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomPage(initialIndex: 1), // index 1 -> recordPage
            ),
          );
        }
      },
    );

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'arrhythmia_channel_id',
      '부정맥 감지',
      description: '부정맥 감지 알림을 위한 채널',
      importance: Importance.max,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  // 알림 트리거 메서드
  Future<void> _showArrhythmiaNotification() async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'arrhythmia_channel_id',
      '부정맥 감지',
      channelDescription: '부정맥 감지 알림을 위한 채널',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'drawable/logo2', // drawable 폴더에 있는 이미지 파일 이름 (확장자 제외)
      timeoutAfter: 10000, // 10초
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'PulsePulse',
      '부정맥이 감지되었습니다. 건강 상태를 확인하세요.',
      platformChannelSpecifics,
      payload: 'arrhythmia',
    );
  }

  // 주기적으로 서버에 요청
  void _startPolling() {
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      await _pollCheckEndpoint();
      await _pollStatusEndpoint();
    });
  }

  Future<void> _pollCheckEndpoint() async {
    try {
      final checkResponse = await http.get(Uri.parse('http://192.168.27.113:3000/check'));
      final checkData = json.decode(checkResponse.body);
      final variable = checkData['variable'];

      if (lastVariableCheck == null || variable != lastVariableCheck) {
        await _showArrhythmiaNotification();
        lastVariableCheck = variable;
      }
    } catch (e) {
      print('Error during polling /check: $e');
    }
  }

  Future<void> _pollStatusEndpoint() async {
    try {
      final statusResponse = await http.get(Uri.parse('http://192.168.27.113:3000/status'));
      final statusData = json.decode(statusResponse.body);
      final variable = statusData['variable'];

      if (lastVariableStatus == null || variable != lastVariableStatus) {
        await _showArrhythmiaNotification();
        lastVariableStatus = variable;
      }
    } catch (e) {
      print('Error during polling /status: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F9),
      appBar: AppBar(
        title: Text(
          "설정",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomPage()),
            );
          },
        ),
        backgroundColor: Color(0xFFFFF8F9),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFFFF8F9),
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            SizedBox(height: 10,),
            Container(
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(3),
                color: Colors.white,
                child: ListTile(
                  onTap: () {},
                  // title: Text(_profile!.id, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  // subtitle: Text(_profile!.name, style: TextStyle(fontSize: 17),),
                    title: Text("doa1029@gmail.com", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    subtitle: Text("모찌나가요", style: TextStyle(fontSize: 17),),
                  leading: Image.asset('img/logo2.PNG')
                ),
              ),
            ),
            SizedBox(height: 40,),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('프로필 변경', style: TextStyle(fontSize: 18),),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeProfile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('비밀번호 변경', style: TextStyle(fontSize: 18),),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordCh()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_outlined),
              title: Text('알림설정', style: TextStyle(fontSize: 18),),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppNoti()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('센서 연결정보', style: TextStyle(fontSize: 18),),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 센서 연결정보 화면으로 이동
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('사용방법', style: TextStyle(fontSize: 18),),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sensorattach22()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('로그아웃', style: TextStyle(fontSize: 18),),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await logoutService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

