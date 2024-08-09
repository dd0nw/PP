import 'package:flutter/material.dart';
import 'package:front/reportPage/reportPage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'api_service.dart'; // ApiService 정의된 파일 import

import 'Calendar.dart';
import 'Listtile.dart';
import 'bottomPage.dart';
import 'bt.dart';
import 'dashPage.dart';
import 'ecg_chart.dart';
import 'ecgchart/ECGchart.dart';
import 'ex01_login.dart';
import 'memo2page/memo2Page.dart';
import 'memoPage/memo_provider.dart';
import 'memoPage/memopage.dart';
import 'nodedb/nodedb.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MemoPage(),
      // routes: {
      //   '/report': (context) => const ReportPage(),
      // },
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
  final ApiService apiService = ApiService();
  String _text = '변경되기 전!';
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Future<void> _fetchData() async {
  //   try {
  //     // Assuming fetchData is a method in ApiService that fetches some data
  //     String data = await apiService.fetchData();
  //     setState(() {
  //       _text = data;
  //     });
  //   } catch (e) {
  //     print('Failed to fetch data: $e');
  //   }
  // }

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
        onPressed: (){},
        child: Icon(Icons.add),
      ),
    );
  }
}