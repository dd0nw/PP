// 기록 화면 (날짜 조회)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:front/reportPage/reportPage.dart';
import 'record_service.dart';

class recordPage extends StatefulWidget {
  const recordPage({super.key});

  @override
  State<recordPage> createState() => _recordPageState();
}

class _recordPageState extends State<recordPage> {

  DateTime date = DateTime.now(); // 날짜 -> 달력
  String _selectedDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
  MemoService memoService = MemoService(); // record_service

  //데이터를 리스트로 저장 -> record_service
  List<Map<String, dynamic>>? _analysisResults;

  // 화면이 로드될때 자동으로 오늘날짜 기록 가져오기!
  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
    fetchAnalysis(DateFormat('yyyy/MM/dd').format(DateTime.now()));
  }

  Future<void> fetchAnalysis(String selectedDate) async { // 달력에 선택한날짜로 가져옴
    try {
      final result = await memoService.fetchAnalysis(selectedDate);
      setState(() {
        _analysisResults = List<Map<String, dynamic>>.from(result); // 데이터를 리스트로 변환
        print('_analysisResults result : $result'); /////////////////////////////////////////////////console
      });
    } catch (e) {
      print('Error fetching analysis result: $e');
    }
  }

  Widget _buildEcgGraph(Map<String, dynamic>? analysisResult) {
    List<dynamic>? ecgData = analysisResult?['ECG'];

    if (ecgData == null || ecgData.isEmpty) {
      return Center(child: Text('ECG 데이터가 없습니다.'));
    }

    List<FlSpot> ecgPoints = [];
    for (int i = 0; i < ecgData.length; i++) {
      ecgPoints.add(FlSpot(i.toDouble(), ecgData[i].toDouble()));
    }

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: ecgPoints,
            isCurved: false, // 직선으로 연결
            color: Colors.black,
            barWidth: 0.8,
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
      body: SafeArea(
        child: Container(
          color: Color(0xFFFFF8F9),
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text("  기록", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(height: 2,),
                  Center(
                    child: SizedBox(
                      width: 200, // 버튼의 가로 길이를 설정합니다.
                      child: ElevatedButton(
                        onPressed: () async { // 달력
                          final selectedDate = await showDatePickerDialog(
                            context: context,
                            initialDate: DateTime.now(), // 초기날짜
                            minDate: DateTime(2020, 10, 10),
                            maxDate: DateTime.now(), // 선택가능한 마지막날짜(현재 날짜)
                            width: 300,
                            height: 300,
                            currentDate: DateTime(2022, 10, 15),
                            selectedDate: DateTime(2022, 10, 16),
                            currentDateDecoration: const BoxDecoration(),
                            currentDateTextStyle: const TextStyle(),
                            daysOfTheWeekTextStyle: const TextStyle(),
                            disabledCellsTextStyle: const TextStyle(),
                            enabledCellsDecoration: const BoxDecoration(),
                            enabledCellsTextStyle: const TextStyle(),
                            initialPickerType: PickerType.days,
                            selectedCellDecoration: const BoxDecoration(),
                            selectedCellTextStyle: const TextStyle(),
                            leadingDateTextStyle: const TextStyle(),
                            slidersColor: Colors.lightBlue,
                            highlightColor: Colors.redAccent,
                            slidersSize: 20,
                            splashColor: Colors.lightBlueAccent,
                            splashRadius: 40,
                            centerLeadingDate: true,
                          );

                          if (selectedDate != null) {
                            setState(() {
                              date = selectedDate;
                              _selectedDate = DateFormat('yyyy.MM.dd').format(selectedDate);
                            });
                            await fetchAnalysis(DateFormat('yyyy/MM/dd').format(selectedDate)); // 선택된 날짜의 데이터를 가져옴
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(30, 35),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 1, color: Colors.black12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_selectedDate, style: TextStyle(fontSize: 21),),
                            SizedBox(width: 5,),
                            Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0,),
                  Center(
                    child: Text( "부정맥 발생횟수: ${_analysisResults?.length ?? 0}회",
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 5,),

                  // _analysisResults가 null이 아니고 데이터가 있을 때만 ListView를 표시
                  if (_analysisResults != null && _analysisResults!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _analysisResults!.length, // 날짜 개수만큼 표시
                      itemBuilder: (context, index) {
                        var analysisResult = _analysisResults![index]; // 선택한것
                        return GestureDetector(
                          onTap: () async {
                            await fetchAnalysis(DateFormat('yyyy/MM/dd').format(date));
                            if (_analysisResults != null && _analysisResults!.isNotEmpty) {
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (_) => reportPage(analysisResult: _analysisResults![index]), //선택한것으로이동
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              width: 200, height: 180,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.black12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                                        visualDensity: VisualDensity(vertical: -4), // 시각적 밀도 설정
                                        minVerticalPadding: 0, // 최소 수직 패딩 설정
                                        title: Text(
                                          '${analysisResult['ANALISYS_RESULT'] ?? ''}',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: Colors.pink),
                                        ),
                                        subtitle: Text(
                                          '♥ ${analysisResult['BP_AVG']?.toString() ?? ''} BPM Average', // int -> String 변환
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        trailing: Wrap(
                                          spacing: 12,
                                          children: [
                                            Text(
                                              '${analysisResult['CREATED_AT']?.toString() ?? ''}', // int -> String 변환
                                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.chevron_right),
                                          ],
                                        ),
                                      ),
                                      //SizedBox(height: 7,),
                                      Divider(color: Colors.pink,thickness: 1,),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                        ),
                                        height: 63,
                                        width: MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: _buildEcgGraph(analysisResult),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}