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

  /////////데이터를 리스트로 저장
  List<Map<String, dynamic>>? _analysisResults;

  Future<void> fetchAnalysis(String selectedDate) async {
    try {
      final result = await memoService.fetchAnalysis(selectedDate);
      setState(() {
        _analysisResults = List<Map<String, dynamic>>.from(result); // 데이터를 리스트로 변환
        print(result);
      });
    } catch (e) {
      print('Error fetching analysis result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Text("기록", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(height: 13,),
                  Center(
                    child: SizedBox(
                      width: 200, // 버튼의 가로 길이를 설정합니다.
                      child: ElevatedButton(
                        onPressed: () async {
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
                          minimumSize: Size(20, 35),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_selectedDate, style: TextStyle(fontSize: 18),),
                            SizedBox(width: 5,),
                            Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  // _analysisResults가 null이 아니고 데이터가 있을 때만 ListView를 표시
                  if (_analysisResults != null && _analysisResults!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _analysisResults!.length,
                      itemBuilder: (context, index) {
                        var analysisResult = _analysisResults![index];
                        return GestureDetector(
                          onTap: () async {
                            await fetchAnalysis(DateFormat('yyyy/MM/dd').format(date));
                            if (_analysisResults != null && _analysisResults!.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => reportPage(analysisResult: _analysisResults![index]), //선택한것으로이동
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            width: 200,
                            height: 180,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 0),
                                    visualDensity: VisualDensity(vertical: -4), // 시각적 밀도 설정
                                    minVerticalPadding: 0, // 최소 수직 패딩 설정
                                    title: Text(analysisResult['ANALISYS_RESULT'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    subtitle: Text('♥ ${analysisResult['BG_AVG'] ?? ''} BPM Average'),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: [
                                        Text(analysisResult['CREATED_AT'] ?? '', style: TextStyle(fontSize: 17),),
                                        Icon(Icons.chevron_right),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                  SizedBox(height: 9,),
                                  // ListTile(
                                  //   contentPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 0),
                                  //   visualDensity: VisualDensity(vertical: -4), // 시각적 밀도 설정
                                  //   minVerticalPadding: 0, // 최소 수직 패딩 설정
                                  //   title: Text(analysisResult['ANALISYS_RESULT'] ?? ''),
                                  //   onTap: () {},
                                  // ),
                                  Container(
                                    child: Image.asset("img/AF.png"), // 부정맥 종류에 따라 이미지 다르게 하기!
                                  )
                                ],
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