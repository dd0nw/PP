import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // JWT 디코딩 패키지

class Profile {
  final String id;
  final String name;

  Profile({required this.id, required this.name});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class ProfileService {
  //final String baseUrl = 'http://10.0.2.2:3000'; // 에뮬레이터에서 로컬 서버에 접속하기 위한 주소
  final String baseUrl = 'http://192.168.27.113:3000';
  final storage = FlutterSecureStorage();

  Future<String> getToken() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/get-token'));
      print('서버 응답: ${response.body}'); // 서버 응답을 출력하여 디버깅
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        if (token == null || token.isEmpty) {
          throw Exception('토큰이 없습니다');
        }
        await saveToken(token);
        print('토큰을 가져와서 저장했습니다: $token');
        return token;
      } else {
        print('토큰 가져오기 실패, 상태 코드: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        throw Exception('토큰을 가져오는 데 실패했습니다');
      }
    } catch (e) {
      print('토큰 가져오는 중 오류 발생: $e');
      throw e;
    }
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwtToken', value: token);
  }

  Future<bool> isTokenValid(String token) async {
    try {
      final isExpired = JwtDecoder.isExpired(token);
      if (isExpired) {
        print('토큰이 만료되었습니다');
        return false;
      }
      print('토큰이 유효합니다');
      return true;
    } catch (e) {
      print('토큰 디코딩 실패: $e');
      return false;
    }
  }

  Future<Profile> fetchProfile() async {
    String? token = await storage.read(key: 'jwtToken');

    // 토큰이 없거나 유효하지 않으면 새로운 토큰을 요청
    if (token == null || !(await isTokenValid(token))) {
      print('토큰이 없거나 유효하지 않아 새 토큰을 가져옵니다');
      token = await getToken();
    } else {
      print('유효한 토큰을 찾았습니다: $token');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      print('서버에서 프로필을 가져왔습니다: $body'); // 추가된 로그
      return Profile.fromJson(body); // Profile 모델 클래스의 fromJson 메소드 사용
    } else {
      print('프로필 로드 실패, 상태 코드: ${response.statusCode}');
      print('응답 본문: ${response.body}');
      throw Exception('프로필을 로드하는 데 실패했습니다');
    }
  }
}