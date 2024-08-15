import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bottomPage.dart';
import 'dashPage.dart';
// import 'package:flutter_appauth/flutter_appauth.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idCon = TextEditingController();
  final TextEditingController pwCon = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FlutterAppAuth _appAuth = FlutterAppAuth();
  // late WebViewController _webViewController;
  // final String kakaoLoginUrl = "http://10.0.2.2:3000/auth/kakao";  // Node.js 서버 URL

  // @override
  // void initState() {
  //   super.initState();
  //   _webViewController = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           // 로딩 바 업데이트
  //         },
  //         onPageStarted: (String url) {},
  //         onPageFinished: (String url) {},
  //         onHttpError: (HttpResponseError error) {},
  //         onWebResourceError: (WebResourceError error) {},
  //         onNavigationRequest: (NavigationRequest request) {
  //           if (request.url.contains("?token=")) {
  //             final token = Uri.parse(request.url).queryParameters['token'];
  //             Navigator.pop(context, token);
  //             return NavigationDecision.prevent;
  //           }
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(kakaoLoginUrl));
  // }

  Future<void> _login() async {
    // 일반 로그인
    final String url = 'http://10.0.2.2:3000/user/login';
    // final String url = 'http://192.168.219.228:3000/user/login';
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomPage()),
      );
    } else {
      print("Login failed: ${response.statusCode}");
    }
  }

  // Future<void> _loginWithKakao() async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => KakaoLoginWebView(controller: _webViewController),
  //     ),
  //   );
  //
  //   if (result != null) {
  //     // 로그인 성공 및 JWT 토큰 사용
  //     print("JWT Token: $result");
  //     // TODO: 토큰 저장 및 이후 요청에 사용
  //   }
  // }

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
                Image.asset('img/logo.png', width: 170, height: 170),
                SizedBox(height: 30),
                Container(
                  child: Flexible(
                    child: TextField(
                      controller: idCon,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: '이메일',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  width: 273,
                ),
                Container(
                  child: Flexible(
                    child: TextField(
                      controller: pwCon,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: '비밀번호',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  width: 273,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(284, 40),
                    backgroundColor: Colors.red[900],
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
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
                  onPressed: (){},
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
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
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
