import 'package:flutter/material.dart';
import 'package:front/password/passwordPage.dart';
import 'package:front/profile/profile.dart';
import 'package:front/sensorattach.dart';
import 'package:front/sensorattach22.dart';
import 'package:front/settings_alarm.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'bottomPage.dart';
import 'ex01_login.dart';

// 이름, 아이디 가져오기


// 로그아웃 하기
class LogoutService {
  final String baseUrl = 'http://10.0.2.2:3000'; // 에뮬레이터에서 로컬 서버에 접속하기 위한 주소
  final storage = FlutterSecureStorage(); // JWT토큰 저장

  Future<void> logout() async {
    try {
      // 저장된 토큰 읽기
      final token = await storage.read(key: 'jwtToken');
      if (token == null) {
        throw Exception('No token found');
      }

      // 로그아웃 요청 보내기
      final response = await http.post(
        Uri.parse('$baseUrl/user/logout'),
        headers: {
          'Authorization': 'Bearer $token', // 토큰을 Authorization 헤더에 포함
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Logout successful');
        // 로그아웃 성공 시, 토큰 삭제
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


class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  final LogoutService logoutService = LogoutService();

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
                MaterialPageRoute(builder: (context) => BottomPage()),);

          }, // 전페이지로 이동
        ),
        backgroundColor: Color(0xFFFFF8F9),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFFFF8F9),
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            SizedBox(height: 15,),
            Container(
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black12, // 테두리 색상
                  width: 1, // 테두리 두께
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
                  onTap: () {}, // edit페이지
                  title: Text("김도아", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  subtitle: Text("doa1029@naver.com", style: TextStyle(fontSize: 17),),
                  leading: Icon(Icons.account_circle, size: 50,),
                ),
              ),
            ),
            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('프로필 변경'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 비밀번호 변경 클릭 시 동작
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeProfile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('비밀번호 변경'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordCh()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_outlined),
              title: Text('알림설정'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppNoti()));

              },
            ),
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('센서 연결정보'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {

              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('사용방법'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sensorattach22()));

              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('로그아웃'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await logoutService.logout();
                // 로그아웃 후, 로그인 페이지로 리디렉션
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