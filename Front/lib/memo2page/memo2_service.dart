import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // 추가된 패키지
import 'memo2.dart';

class MemoService {
  final String baseUrl = 'http://10.0.2.2:3000'; // 에뮬레이터에서 로컬 서버에 접속하기 위한 주소
  // final String baseUrl = 'http://192.168.1.100:3000'; // Replace with your local machine's IP address
  final storage = FlutterSecureStorage();

  Future<String> getToken() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/get-token'));
      print('Server response: ${response.body}'); // 서버 응답을 출력하여 디버깅
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

  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwtToken', value: token);
  }

  Future<bool> isTokenValid(String token) async {
    try {
      // 디코딩하여 토큰의 만료 시간을 확인
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

  Future<List<Memo>> fetchMemos() async {
    String? token = await storage.read(key: 'jwtToken');

    // 토큰이 없거나 유효하지 않으면 새로운 토큰을 요청
    if (token == null || !(await isTokenValid(token))) {
      print('Token not found or invalid, fetching new token');
      token = await getToken();
    } else {
      print('Token found and valid: $token');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/memo'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      print('Fetched memos from server: $body'); // 추가된 로그
      List<dynamic> memoList = body['memos'];
      List<Memo> memos = memoList.map((dynamic item) => Memo.fromJson(item)).toList();
      return memos;
    } else {
      print('Failed to load memos with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load memos');
    }
  }

  Future<void> createMemo(Memo memo) async {
    String? token = await storage.read(key: 'jwtToken');

    // 토큰이 없거나 유효하지 않으면 새로운 토큰을 요청
    if (token == null || !(await isTokenValid(token))) {
      print('Token not found or invalid, fetching new token');
      token = await getToken();
    } else {
      print('Token found and valid: $token');
    }

    final jsonBody = jsonEncode(memo.toJson());
    print('Sending memo to server: $jsonBody'); // 로그 추가

    final response = await http.post(
      Uri.parse('$baseUrl/memo'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      print('Failed to create memo with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create memo');
    }
  }
}
