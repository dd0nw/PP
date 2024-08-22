// 로그인(첫)페이지
import 'package:flutter/material.dart';
import 'package:front/sensor/sensorattach.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bottomPage.dart';
import 'dashPage.dart';
import 'sociallogin/OAuthWebview.dart';
import 'joinPage.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();

  // 일반 로그인
  Future<void> _login() async {
    //final String url = 'http://10.0.2.2:3000/user/login';
    final String url = 'http://192.168.27.113:3000/user/login';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'id': idCon.text,
        'pw': pwCon.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];
      print("Login successful, token: $token");

      // 로그인 성공 메시지를 Snackbar로 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("로그인에 성공하셨습니다!"),
          duration: Duration(seconds: 2),
        ),
      );


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Sensorattach()),
      );
    } else {
      print("Login failed: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            color: Colors.white,
            child: Column(
              children: [
                Image.asset('img/logo.png', width: 220, height: 200),
                SizedBox(height: 45),
                Container(
                  width: 290,
                  child: TextField(
                    controller: idCon,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: '이메일',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: 290,
                  child: TextField(
                    controller: pwCon,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: '비밀번호',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                SizedBox(height: 45),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(284, 50),
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: ()async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OAuthWebView(oauthProvider: 'google'),
                      ),
                    );

                    if (result != null) {
                      // result는 OAuth 인증 후 받은 토큰입니다.
                      print('Google Login Token: $result');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    backgroundColor: Colors.white,
                    fixedSize: Size(284, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('img/google.png', width: 30, height: 30),
                      SizedBox(width: 40),
                      Text(
                        '구글로 계속하기',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: ()async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OAuthWebView(oauthProvider: 'kakao'),
                      ),
                    );

                    if (result != null) {
                      // result는 OAuth 인증 후 받은 토큰입니다.
                      print('Kakao Login Token: $result');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    fixedSize: Size(284, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('img/kakao.png', width: 30, height: 30),
                      SizedBox(width: 40),
                      Text(
                        '카카오로 계속하기',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JoinPage()),
                          );
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '비밀번호 찾기',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class KakaoLoginWebView extends StatelessWidget {
//   final WebViewController controller;
//
//   KakaoLoginWebView({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Kakao Login")),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }
