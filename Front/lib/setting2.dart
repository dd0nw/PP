import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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
        Uri.parse('$baseUrl/logout'),
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
      appBar: AppBar(
        leading: Icon(Icons.chevron_left),
        elevation: 0,
        title: Text("설정", style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
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
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('비밀번호 변경'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 콘텐츠 설정 클릭 시 동작
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_outlined),
              title: Text('알림설정'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 소셜 클릭 시 동작
              },
            ),
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('센서 연결정보'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 언어 클릭 시 동작
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('사용방법'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 개인정보 및 보안 클릭 시 동작
              },
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await logoutService.logout();
                  // 로그아웃 후, 로그인 페이지로 리디렉션
                  Navigator.pushReplacementNamed(context, '/dashPage');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 아이콘과 텍스트 가운데 정렬
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.black,),
                    SizedBox(width: 3), // 아이콘과 텍스트 사이 간격 추가
                    Text(
                      '로그아웃',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(150, 40), // 버튼의 고정 크기 설정
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.notifications),
            //   title: Text('알림'),
            // ),
            // Divider(),
            // SwitchListTile(
            //   title: Text('다크 모드'),
            //   value: isDarkTheme,
            //   onChanged: (value) {
            //     setState(() {
            //       isDarkTheme = value;
            //     });
            //   },
            // ),
            // SwitchListTile(
            //   title: Text('계정 활성화'),
            //   value: isAccountActive,
            //   onChanged: (value) {
            //     setState(() {
            //       isAccountActive = value;
            //     });
            //   },
            // ),
            // SwitchListTile(
            //   title: Text('기회 알림'),
            //   value: isOpportunityEnabled,
            //   onChanged: (value) {
            //     setState(() {
            //       isOpportunityEnabled = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}