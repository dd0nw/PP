// Flutter - Node.js 연결한 클래스

import 'package:http/http.dart' as http;

class ApiService {
  final String _url = "http://192.168.219.230:3000";

  Future<String> fetchData() async {
    http.Response response = await http.get(Uri.parse("$_url/"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}