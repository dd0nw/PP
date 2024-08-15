import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'dart:typed_data';

class MemoService {
  final String baseUrl = 'http://10.0.2.2:3000'; // 에뮬레이터에서 로컬 서버에 접속하기 위한 주소
  //final String baseUrl = 'http://192.168.219.228:3000'; // 핸드폰
  final storage = FlutterSecureStorage(); // JWT토큰

  Future<String> getToken() async { // 서버에서 JWT토큰 가져옴
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/get-token'));
      print('Server response: ${response.body}'); // 서버 응답을 출력하여 디버깅//////////////
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        if (token == null || token.isEmpty) {
          throw Exception('Token not found');
        }
        await saveToken(token);
        print('Token fetched and saved: $token');//////////////////
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

  Future<void> saveToken(String token) async { // JWT토큰을 fluttersecurestorage에 저장
    await storage.write(key: 'jwtToken', value: token);
  }

  Future<bool> isTokenValid(String token) async { // JWT토큰이 유효한지 확인
    try {
      // 디코딩하여 토큰의 만료 시간을 확인
      final decodedToken = JwtDecoder.decode(token);
      final isExpired = JwtDecoder.isExpired(token);

      if (isExpired) {
        print('Token is expired');
        return false;
      }

      print('Token is valid. Payload: $decodedToken');////////////////////
      return true;
    } catch (e) {
      print('Failed to decode token: $e');
      return false;
    }
  }

  // 서버 -> 데이터 받아와서 flutter에서 사용
  Future<List<Map<String, dynamic>>> fetchAnalysis(String date) async { // 날짜에 대한 데이터
    String? token = await storage.read(key: 'jwtToken');

    // 토큰이 없거나 유효하지 않으면 새로운 토큰을 요청
    if (token == null || !(await isTokenValid(token))) {
      print('Token not found or invalid, fetching new token');///////////
      token = await getToken();
    } else {
      print('Token found and valid: $token');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analysis'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'createdAt': date,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load analysis data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("Error fetching BLOB data: $e");
      throw e;
    }
  }
}

class BlobExample extends StatefulWidget {
  @override
  _BlobExampleState createState() => _BlobExampleState();
}

class _BlobExampleState extends State<BlobExample> {
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    fetchBlobData();
  }

  Future<void> fetchBlobData() async {
    final memoService = MemoService();

    try {
      final analysisData = await memoService.fetchAnalysis('2024/08/11');

      if (analysisData.isNotEmpty) {
        String base64String = analysisData[0]['ECG'];

        // Base64 문자열에서 프리픽스를 제거
        if (base64String.startsWith('data:image')) {
          base64String = base64String.split(',')[1];
        }

        // Base64 문자열을 디코딩하여 Uint8List로 변환
        final decodedBytes = base64Decode(base64String);

        // 확인용 로그
        print('Decoded bytes length: ${decodedBytes.length}');
        print('First 20 bytes: ${decodedBytes.sublist(0, 20)}');

        setState(() {
          imageData = decodedBytes;
        });
      } else {
        print('No analysis data found.');
      }
    } catch (e) {
      print("Error fetching BLOB data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blob Example'),
      ),
      body: Center(
        child: imageData != null
            ? Image.memory(imageData!) // Uint8List 데이터를 이미지로 표시
            : Text('이미지를 불러오는 중입니다...'),
      ),
    );
  }
}
