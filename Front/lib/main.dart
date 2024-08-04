import 'package:flutter/material.dart';
import 'package:front/memoPage.dart';
import 'package:front/memoPage/memo_service.dart';
import 'package:front/reportPage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'api_service.dart'; // ApiService 정의된 파일 import

import 'Calendar.dart';
import 'Listtile.dart';
import 'bottomPage.dart';
import 'mainPage.dart';
import 'memoPage/memo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: ReportPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // flutter - Node.js 연결
  final ApiService apiService = ApiService();
  String _text = '변경되기 전!';
  //final String _url = "http://192.168.219.49:3000";

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // flutter - Node.js 연결
  Future<void> _fetchData() async {
    try {
      String data = await apiService.fetchData();
      setState(() {
        _text = data;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(_text), // 서버에서 가져온 데이터를 표시
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        child: Icon(Icons.add),
      ),
    );
  }
}
