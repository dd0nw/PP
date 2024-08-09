import 'package:flutter/material.dart';
import 'dart:convert';

import 'node_service.dart';
//import 'memo_service.dart'; // MemoService 클래스가 있는 파일을 import


class NodeDb extends StatefulWidget {
  const NodeDb({super.key});

  @override
  State<NodeDb> createState() => _NodeDbState();
}

class _NodeDbState extends State<NodeDb> {
  String _createdAt = "2024/08/07 19:52:20";  // Example datetime
  MemoService memoService = MemoService();
  Map<String, dynamic>? _analysisResult;

  Future<void> fetchAnalysisResult() async {
    try {
      final result = await memoService.fetchAnalysisResult(_createdAt);
      setState(() {
        _analysisResult = result;
      });
    } catch (e) {
      print('Error fetching analysis result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Result'),
      ),
      body: Center(
        child: _analysisResult == null
            ? ElevatedButton(
          onPressed: fetchAnalysisResult,
          child: Text('Fetch Analysis Result'),
        )
            : ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Text('BG Avg: ${_analysisResult!['bg_avg']}'),
            Text('BP Min: ${_analysisResult!['bp_min']}'),
            Text('BP Max: ${_analysisResult!['bp_max']}'),
            Text('PR: ${_analysisResult!['pr']}'),
            Text('QT: ${_analysisResult!['qt']}'),
            Text('RR: ${_analysisResult!['rr']}'),
            Text('QRS: ${_analysisResult!['qrs']}'),
            Text('Analysis Result: ${_analysisResult!['analisys_result']}'),
            Text('Analysis Etc: ${_analysisResult!['analisys_etc']}'),
            Text('ECG: ${_analysisResult!['ecg']}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NodeDb(),
  ));
}
