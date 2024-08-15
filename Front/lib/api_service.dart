// Flutter - Node.js 연결한 클래스
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://192.168.219.228:3000"; // 서버 URL

  Future<Map<String, dynamic>> fetchAnalysisResult(String createdAt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/analysisResult'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN', // 필요 시 토큰 추가
      },
      body: jsonEncode(<String, String>{
        'createdAt': createdAt,
      }),
    );

    if (response.statusCode == 200) {
      print("Data fetched successfully");
      return json.decode(response.body);
    } else {
      print("Failed to load data, status code: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  }
}