import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../userinfo/cardiainfoPage.dart';
import '../map/map.dart';
import '../memo2page/AnalysisInfo.dart';
import '../memo2page/memo2.dart';
import '../memo2page/memo2Page.dart';
import 'report_service.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatefulWidget {
  final Map<String, dynamic>? analysisResult;

  const ReportPage({super.key, this.analysisResult});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final MemoService _memoService = MemoService();
  final TextEditingController memoCon = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMemos(); // 초기화 시 메모 데이터 로드
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 자판이 내려가면 호출됨
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _loadMemos() async {
    try {
      List<Memo> memos = await _memoService.fetchMemos();
      if (memos.isNotEmpty) {
        setState(() {
          memoCon.text = memos.first.content;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load memos: $e';
      });
    }
  }

  Future<void> _saveMemo() async {
    FocusScope.of(context).unfocus(); // 자판 내리기
    AnalysisInfo analysisInfo = AnalysisInfo(
      analysisId: widget.analysisResult?['ANALYSIS_IDX']?.toString() ?? 'default_id',
    );
    Memo newMemo = Memo(
      content: memoCon.text,
      analysisId: analysisInfo.analysisId,
    ); // 분석 ID 포함

    try {
      await _memoService.createMemo(newMemo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메모가 저장되었습니다')),
      );
      // Fetch updated memos
      await _loadMemos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save memo: $e')),
      );
    }
  }

  Future<void> downloadPdf() async {
    final analysisId = widget.analysisResult?['ANALYSIS_IDX']?.toString() ?? 'your_analysis_id';
    try {
      setState(() {
        isLoading = true;
      });
      await _memoService.downloadPdf(analysisId, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF 다운로드 중 오류 발생: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildEcgGraph() {
    List<dynamic>? ecgData = widget.analysisResult?['ECG'];

    if (ecgData == null || ecgData.isEmpty) {
      return Center(child: Text('ECG 데이터가 없습니다.'));
    }

    List<FlSpot> ecgPoints = [];
    for (int i = 0; i < ecgData.length; i++) {
      ecgPoints.add(FlSpot(i.toDouble(), ecgData[i].toDouble()));
    }

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: ecgPoints,
            isCurved: false, // 직선으로 연결
            color: Colors.red,
            barWidth: 1,
            isStrokeCapRound: false,
            dotData: FlDotData(show: false), // 점을 비활성화
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F9),
      appBar: AppBar(
        title: Text(
          "부정맥 분석 결과",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: downloadPdf,
            icon: Icon(Icons.download, color: Colors.black),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFFFF8F9),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Color(0xFFFFF8F9),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.analysisResult?['FULLDATE']?.toString() ?? '2021-05-28 14:14:51 검사 결과',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(color: Colors.pink, thickness: 2,),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      color: Colors.black,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: _buildEcgGraph(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.pink, thickness: 2,),
                  Text(
                    '상위 분석 결과',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${widget.analysisResult?['ANALISYS_RESULT']?.toString() ?? '동리듬 (99.06%)'}',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => cardiainfoPage()),
                                  );
                                }, // 버튼 클릭 시 호출될 함수 또는 메서드
                                  icon: Icon(
                                    Icons.info_outline, // 표시할 아이콘
                                    color: Colors.pink, // 아이콘 색상
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.pink, thickness: 2,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '심박수',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${widget.analysisResult?['BP_AVG']?.toString() ?? '80.7 BPM'} BPM',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '산소포화도',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${widget.analysisResult?['ecg']?.toString() ?? '90%'}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'RR_MIN Interval',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    // '${widget.analysisResult?['RR_MIN']?.toString() ?? '91.5 ms'} ms',
                                    '${((double.tryParse(widget.analysisResult?['RR_AVG']?.toString() ?? '146.6') ?? 146.6)
                                        - (double.tryParse(widget.analysisResult?['RR_STD']?.toString() ?? '2.0') ?? 2.0)).toStringAsFixed(0)} ms',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'RR_MAX Interval',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${widget.analysisResult?['RR_MAX']?.toString() ?? '1.2 ms'} ms',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'RR_AVG Interval',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${widget.analysisResult?['RR_AVG']?.toString() ?? '146.6 ms'} ms',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'RR_STD Interval',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${widget.analysisResult?['RR_STD']?.toString() ?? '2.0 ms'} ms',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("메모", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                      ElevatedButton(
                        onPressed: _saveMemo,
                        child: Icon(Icons.save),
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.grey,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width, // 가로 길이를 화면 전체로 설정
                    height: 90,
                    child: TextField(
                      controller: memoCon,
                      focusNode: _focusNode, // FocusNode 설정
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: "메모를 입력하세요",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black12), // 기본 테두리 제거
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.white), // 기본 상태에서의 테두리 색상
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.pink), // 포커스 상태에서의 테두리 색상
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width, // 가로 길이를 화면 전체로 설정
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "심장마비나 의료 응급 상황이 발생했다고 판단되면 응급 서비스에 전화하십시오",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                onPressed: downloadPdf,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.download),
                                    Text('분석결과 다운로드'),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: Colors.pink,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(120, 35),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapPage(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search),
                                      Text('가까운 병원 찾아보기'),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: Colors.pink,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(250, 35),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
