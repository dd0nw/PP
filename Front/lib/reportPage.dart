import 'package:flutter/material.dart';
import 'api_service.dart'; // ApiService가 정의된 파일을 import
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart'; // 플러터 차트 패키지 사용
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 추가된 부분
import 'package:path_provider/path_provider.dart'; // 추가된 부분
import 'dart:io'; // 추가된 부분


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ApiService apiService = ApiService();
  final storage = FlutterSecureStorage(); // 추가된 부분
  String _text = '변경되기 전!';
  List<double> _ecgData = []; // ECG 데이터 리스트

  @override
  void initState() {
    super.initState();
    _fetchEcgData();
  }

  Future<void> _fetchData() async {
    try {
      String data = await apiService.fetchData();
      setState(() {
        _text = data;
      });
    } catch (e) {
      _showMessage('Failed to fetch data: $e');
    }
  }

  Future<void> _fetchEcgData() async {
    try {
      String? token = await storage.read(key: 'jwtToken'); // 토큰 읽기
      if (token == null) {
        _showMessage('Token not found');
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/result/ecg-data'), // 에뮬레이터 사용 시
        // Uri.parse('http://220.71.121.134:3000/result/ecg-data'), // 실제 기기 사용 시
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 토큰 추가
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final ecgDataString = responseData['ecgData'] as String;
        final ecgData = ecgDataString.split(',').map((e) => double.parse(e)).toList();
        setState(() {
          _ecgData = ecgData;
        });
      } else {
        _showMessage('Failed to load ECG data with status code: ${response.statusCode}');
      }
    } catch (e) {
      _showMessage('Failed to fetch ECG data: $e');
    }
  }

  Future<void> _downloadPdf() async {
    try {
      String? token = await storage.read(key: 'jwtToken'); // 토큰 읽기
      if (token == null) {
        _showMessage('Token not found');
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/result/downloadPdf'), // 에뮬레이터 사용 시
        // Uri.parse('http://220.71.121.134:3000/result/downloadPdf'), // 실제 기기 사용 시
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 토큰 추가
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/analysis.pdf');
        await file.writeAsBytes(bytes);
        print('PDF downloaded successfully');
        _showMessage('PDF downloaded successfully to ${file.path}');
      } else {
        _showMessage('Failed to download PDF with status code: ${response.statusCode}');
      }
    } catch (e) {
      _showMessage('Failed to download PDF: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    print("파일경로는 -> ");
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
            icon: Icon(Icons.info_outline_rounded), onPressed: () {},
          ),
          IconButton(
            visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
            icon: Icon(Icons.add_alert), onPressed: () {},
          ),
        ],
        title: Text('Pulse Pulse'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text('리포트2', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: 250,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Text('24.7.22 오전 8:47 ~ 오전 9:05', textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                  SizedBox(height: 10), // 다운로드 버튼과 텍스트 사이의 간격
                  Center(
                    child: ElevatedButton(
                      onPressed: _downloadPdf,
                      child: Text('PDF 다운로드'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('심전도(ECG 그래프)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        SizedBox(height: 3),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: _ecgData.isNotEmpty
                              ? LineChart(LineChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _ecgData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                                isCurved: false,
                                barWidth: 1,
                                color: Colors.red,  // colors를 color로 수정
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ))
                              : Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Text('검사결과', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('심전도', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 0),
                                  visualDensity: VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  title: Text('이 심전도는 심방세동의 징후를 보이고 있습니다',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Divider(),
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 0),
                                  visualDensity: VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  title: Text('부정맥 유형', style: TextStyle(fontWeight: FontWeight.bold)),
                                  trailing: Icon(Icons.help_outline),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle, color: Colors.green, size: 12),
                                          SizedBox(width: 8),
                                          Text('No Arrhythmia'),
                                        ],
                                      ),
                                      Text('78 %', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle, color: Colors.red, size: 12),
                                          SizedBox(width: 8),
                                          Text('Tachycardia'),
                                        ],
                                      ),
                                      Text('22 %', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle, color: Colors.blue, size: 12),
                                          SizedBox(width: 8),
                                          Text('Bradycardia'),
                                        ],
                                      ),
                                      Text('5 %', style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  title: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              margin: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text('PR interval 178ms',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              margin: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text('QT interval 320ms',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              margin: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text('QTC interval 399ms',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              margin: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text('QRS interval 178ms',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  ListTile(
                    title: Text('심박수', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.info_outline),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetricColumn('평균 심박수', '68 BPM'),
                          _buildMetricColumn('최저 심박수', '59 BPM'),
                          _buildMetricColumn('최고 심박수', '99 BPM'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHealthCard('산소포화도', '90 %', Colors.white),
                      _buildHealthCard('HRV', '90 %', Colors.pink[50]),
                      _buildHealthCard('Stress', '31 %', Colors.pink[50]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildHealthCard(String title, String value, Color? color) {
    return Expanded(
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Icon(Icons.info_outline, size: 16),
                ],
              ),
              SizedBox(height: 8),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
