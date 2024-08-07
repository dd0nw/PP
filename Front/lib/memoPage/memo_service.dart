import 'dart:convert'; //Json인코딩 및 디코딩
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'memo.dart';
import 'package:front/api_service.dart';

}
class MemoService {
  final String baseUrl = 'http://localhost:3000'; // 192.168.219.49

  Future<List<Memo>> fetchMemos() async {
    final response = await http.get(Uri.parse('$baseUrl/memos'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Memo.fromJson(item)).toList();
    } else {
      print('Failed to load memos with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load memos');
    }
  }

  Future<void> createMemo(Memo memo) async {
    String? token = await storage.read(key: 'jwtToken');
    if (token == null) {
      print('Token not found in storage, fetching new token');
      token = await getToken();
    } else {
      print('Token found in storage: $token');
    }

    final jsonBody = jsonEncode(memo.toJson());
    print('Sending memo to server: $jsonBody'); // 로그 추가

    final response = await http.post(
      Uri.parse('$baseUrl/memos'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create memo');
    } else {
      print("Create memo success: ${response.body}");
    }
  }

  Future<void> updateMemo(Memo memo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/memo'), // 여기를 '/'로 변경
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      print("Failed to update memo: ${response.body}"); // 실패한 경우 로그 출력
      throw Exception('Failed to update memo');

    } else {
      print("Update memo success: ${response.body}");
    }
  }
}
