import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String kakaoAuthUrl = 'http://192.168.219.157:3000/auth/kakao'; // Kakao 로그인 URL
  final String googleAuthUrl = 'http://192.168.219.157:3000/auth/google'; // Google 로그인 URL

  // Kakao 로그인 요청
  Future<void> loginWithKakao() async {
    try {
      final response = await http.get(Uri.parse(kakaoAuthUrl));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // 로그인 성공 후 처리
        print('Kakao login success: $result');
      } else {
        // 로그인 실패 처리
        print('Kakao login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Kakao login error: $e');
    }
  }

  // Google 로그인 요청
  Future<void> loginWithGoogle() async {
    try {
      final response = await http.get(Uri.parse(googleAuthUrl));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // 로그인 성공 후 처리
        print('Google login success: $result');
      } else {
        // 로그인 실패 처리
        print('Google login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Google login error: $e');
    }
  }
}
