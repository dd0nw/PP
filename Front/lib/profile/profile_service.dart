import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileService {
  final String baseUrl = 'http://10.0.2.2:3000';
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

  // 프로필을 저장하는 메서드
  Future<Map<String, dynamic>> saveProfile({
    required String name,
    required String birthdate,
    required String gender,
    required double height,
    required double weight,
  }) async {
    String? token = await storage.read(key: 'jwtToken');

    // 토큰이 없거나 유효하지 않으면 새로운 토큰을 요청
    if (token == null || !(await isTokenValid(token))) {
      print('Token not found or invalid, fetching new token');
      token = await getToken();
    } else {
      print('Token found and valid: $token');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'name': name,
      'birthdate': birthdate,
      'gender': gender,
      'height': height,
      'weight': weight,
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/infoUpdate'),
        headers: headers,
        body: body,
      );
      print('Response status: ${response.statusCode}'); // 응답 상태 코드 로그

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // 응답 데이터 로그
        return responseData;
      } else {
        print('Failed to save profile, status code: ${response.statusCode}');
        throw Exception('Failed to save profile');
      }
    } catch (error) {
      print('Error saving profile: $error');
      throw error;
    }
  }
}
