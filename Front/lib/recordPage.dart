import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:front/reportPage.dart';

class recordPage extends StatefulWidget {
  const recordPage({super.key});

  @override
  State<recordPage> createState() => _recordPageState();
}

class _recordPageState extends State<recordPage> {

  DateTime date = DateTime.now(); // 날짜 -> 달력
  String _selectedDate = DateFormat('yyyy.MM.dd').format(DateTime.now());

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
                  Text("기록", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(height: 13,),
                  Center(
                    child: SizedBox( /////////////////////////////////////////////달력//////////////////
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
                            //disbaledCellsDecoration: const BoxDecoration(),
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
                          print(_selectedDate);

                          if (selectedDate != null) {
                            setState(() {
                              date = selectedDate;
                              _selectedDate = DateFormat('yyyy.MM.dd').format(selectedDate);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(20,35),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:  BorderSide(width: 1, color: Colors.grey,
                            ),
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
                  Center(child: Text("부정맥 발생 횟수 : 2회",style: TextStyle(fontSize: 16),) ,),
                  SizedBox(height: 10,),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1, // 이 값을 실제 데이터의 길이로 변경하세요.
                    itemBuilder: (context, index) =>
                        GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => reportPage()));
                      },
                      child: SizedBox(
                        width: 200,
                        height: 180,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey)
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 0),
                                visualDensity: VisualDensity(vertical: -4), // 시각적 밀도 설정
                                minVerticalPadding: 0, // 최소 수직 패딩 설정
                                title: Text('심방세동', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                subtitle: Text('♥ 68BPM Average'),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: [
                                    Text('24.08.06, 9:24PM', style: TextStyle(fontSize: 17),),
                                    Icon(Icons.chevron_right),
                                  ],
                                ),
                                onTap: (){},
                              ),
                              SizedBox(height: 9,),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 0),
                                visualDensity: VisualDensity(vertical: -4), // 시각적 밀도 설정
                                minVerticalPadding: 0, // 최소 수직 패딩 설정
                                title: Image.asset('img/AF.png'),
                                onTap: (){},
                              ),
                            ],
                          ),
                        ),
                      ),




                    )
                  )





                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}