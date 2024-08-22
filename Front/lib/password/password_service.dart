import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class PasswordService {
  final String baseUrl = 'http://192.168.27.113:3000'; // 서버의 기본 URL
  final storage = FlutterSecureStorage();

  // 서버에서 토큰을 받아오는 메서드
  Future<String> getToken() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/get-token'));
      print('Server status: ${response.statusCode}');
      print('Server response: ${response.body}'); // 서버 응답 디버깅

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        if (token == null || token.isEmpty) {
          throw Exception('Token not found');
        }

        await saveToken(token);
        print('Token fetched and saved: $token');
        return token;
      } else {
        print('Failed to get token with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load token');
      }
    } catch (e) {
      print('Error occurred while fetching token: $e');
      throw e;
    }
  }

  // 토큰을 저장하는 메서드
  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwtToken', value: token);
  }

  // 토큰의 유효성을 검사하는 메서드
  Future<bool> isTokenValid(String token) async {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final isExpired = JwtDecoder.isExpired(token);

      if (isExpired) {
        print('Token is expired');
        return false;
      }

      print('Token is valid. Payload: $decodedToken');
      return true;
    } catch (e) {
      print('Failed to decode token: $e');
      return false;
    }
  }

  // 새 비밀번호 변경 함수 추가
  Future<String> changePassword(String id, String forwardPw, String backwardPw) async {
    final url = Uri.parse('$baseUrl/user/changePw');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'forwardpw': forwardPw,
        'backwardpw': backwardPw,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        return '비밀번호 변경 성공';
      } else {
        return jsonResponse['message'];
      }
    } else {
      return '비밀번호 변경에 실패했습니다. 다시 시도해주세요.';
    }
  }
}
