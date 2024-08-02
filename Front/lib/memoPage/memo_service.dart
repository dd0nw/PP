import 'dart:convert'; //Json인코딩 및 디코딩
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'memo.dart';
import 'package:front/api_service.dart';

class MemoService {
  final String baseUrl = 'http://localhost:3000'; // 192.168.219.49

  Future<List<Memo>> fetchMemos() async {
    final response = await http.get(Uri.parse('$baseUrl/memos'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Memo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load memos');
    }
  }

  Future<void> createMemo(Memo memo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/memos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create memo');
    }
  }
}