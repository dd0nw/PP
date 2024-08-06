import 'dart:convert'; //Json인코딩 및 디코딩
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'memo.dart';

void main(){
  runApp(MemoService() as Widget);

}
class MemoService {
  final String baseUrl = "http://192.168.219.230:3000"; // 서버 주소

  Future<List<Memo>> fetchMemos() async {
    final response = await http.post(Uri.parse('$baseUrl/memo'));

    if (response.statusCode == 200) {
      print("Server response!!!: ${response.body}"); // 서버 응답 로그 출력
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Memo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load memos');
    }
  }

  Future<void> createMemo(Memo memo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/memo'), // 여기를 '/'로 변경
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode != 201) {
      print("Failed to create memo!!!!: ${response.body}"); // 실패한 경우 로그 출력
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