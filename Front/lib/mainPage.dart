import 'package:flutter/material.dart';
import 'Listtile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  DateTime date = DateTime.now(); // 날짜 -> 달력
  // 부정맥 종류, 시간
  List<Map<String, String>> arrhythmiaRecords = [
    {'type': '심방세동', 'time': '오후 8:47'},
    {'type': '심실빈맥', 'time': '오후 8:47'},
    {'type': '서맥', 'time': '오후 8:47'},
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true, // 타이틀 중앙에 배치
        elevation: 0.0, // 그림자 효과 제거
          actions: [ // 앱바 오른쪽에 아이콘 버튼들 추가
            IconButton(
              visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0), //이부분이 줄여주는 부분이다.
              icon: Icon(Icons.info_outline_rounded),onPressed: (){},),
            IconButton(
              visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0), //이부분이 줄여주는 부분이다.
              icon: Icon(Icons.add_alert),onPressed: (){},),
                    ],
        title: Text('Pulse Pulse'),
        ),

      body: SafeArea(
        child: Container(
          color: Colors.grey[300], // 전체배경색
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              Column( // 아래로
                crossAxisAlignment: CrossAxisAlignment.start, //왼쪽
                children: [
                  SizedBox(height: 5,), // 공백
                  Container(child: Text('실시간데이터', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                  SizedBox(height: 13,),  // 공백
                  Row( // 오른쪽으로 컨테이너 2개
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container( // 심박수 컨테이너
                        padding: EdgeInsets.all(10),
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // 그림자 색상
                              spreadRadius: 5, // 그림자가 퍼지는 정도
                              blurRadius: 7, // 그림자의 흐림 정도
                              offset: Offset(0, 3), // 그림자의 위치 (x, y)
                            ),
                          ]
                        ),
                        child: Row( // 아이콘, 심박수
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.heart_broken),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Column 내의 아이템을 중앙에 배치
                              children: [
                                Text('심박수', style: TextStyle(fontSize: 20),),
                                Text('68BPM', style: TextStyle(fontSize: 20, color: Colors.red),)
                              ],
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                spreadRadius: 5, // 그림자가 퍼지는 정도
                                blurRadius: 7, // 그림자의 흐림 정도
                                offset: Offset(0, 3), // 그림자의 위치 (x, y)
                              ),
                            ]
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.heart_broken),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Column 내의 아이템을 중앙에 배치
                              children: [
                                Text('산소포화도', style: TextStyle(fontSize: 20),),
                                Text('90%', style: TextStyle(fontSize: 20, color: Colors.red),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  /////////////////////////////////////////////////컨테이너2개////////////////
                  SizedBox(height: 15,),
                  Container( //////////////////////////////////////////// => 그래프
                    alignment: Alignment.center,
                    height : 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black)
                        ),
                  ),
                  SizedBox(height: 8,),
                  //////////////////////////////////////////달력/////////////////////////
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: (){
                          // 눌렀을때 전 날짜로 가기
                          setState(() {
                            date = date.subtract(Duration(days: 1));
                          });
                        },),
                        ElevatedButton( // 달력띄우기
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(width:1, color: Colors.black),// 버튼의 테두리 두께와 색상
                            //padding: EdgeInsets.all(2)
                          ),
                          onPressed: ()async { // showDatePicker호출
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(), // 초기날짜
                              firstDate: DateTime(2000), // 선택가능한 첫번째 날짜
                              lastDate: DateTime.now(), // 선택가능한 마지막날짜(현재 날짜)
                            );
                            if (selectedDate != null) {
                              setState(() {
                                date = selectedDate;
                              });
                            } // onPressed
                          },
                          child: Text( "${date.year.toString()}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}",
                                        style: TextStyle(fontSize: 15, color: Colors.black),),),
                        IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: (){
                          setState(() {
                            date = date.add(Duration(days: 1));
                          });
                        },),
                      ],
                    ),
                  ),
                  ///////////////////////////////////달력///////////////////////////////////////////////
                  Container(child: Text('기록', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                  SizedBox(height: 8,),
                  Container(
                      alignment: Alignment.centerRight,
                      child: Text('부정맥 의심 발생횟수 3회21', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                  SizedBox(height: 8,),
                  CustomListTile(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// CustomListTile 클래스 기록
class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(15),
      child: ListView(
        shrinkWrap: true, // 리스트뷰의 크기를 자식 요소에 맞게 조정
        physics: NeverScrollableScrollPhysics(), // 내부 ListView의 스크롤 비활성화
        children: [

          //////////////Container
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            child: ListTile( // Flutter의 ListTile 위젯 사용
              title: Text('부정맥종류', style: TextStyle(fontSize: 19),),
              subtitle: Text('오후 12:455'),
              leading: Icon(Icons.heart_broken_sharp),
              trailing: TextButton( // 항목의 오른쪽에 위치한 버튼
                child: Text('상세   >'), // 버튼 텍스트
                onPressed: () {
                  // 버튼 눌렀을때 보고서 화면이동!
                },
              ),
              //dense: false,
              //enabled: faslse,
                onTap: () {
                  print('onTap pressed!');
                },
                onLongPress: () {
                  print('onLong pressed!');
                },
                iconColor: Colors.black,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          SizedBox(height: 10,),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ListTile( // Flutter의 ListTile 위젯 사용
              title: Text('부정맥종류', style: TextStyle(fontSize: 19),),
              subtitle: Text('오후 12:455'),
              leading: Icon(Icons.heart_broken_sharp),
              trailing: TextButton( // 항목의 오른쪽에 위치한 버튼
                child: Text('상세   >'), // 버튼 텍스트
                onPressed: () {
                  // 버튼 눌렀을때 보고서 화면이동!
                },
              ),
              //dense: false,
              //enabled: faslse,
              onTap: () {
                print('onTap pressed!');
              },
              onLongPress: () {
                print('onLong pressed!');
              },
              iconColor: Colors.black,
              textColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),




        ],
      ),
    );




  }
}




/////////////////Card
// Card(
//   child: ListTile( // Flutter의 ListTile 위젯 사용
//     title: Text('부정맥종류', style: TextStyle(color: Colors.red, fontSize: 19),),
//     subtitle: Text('오후 12:45'),
//     leading: Icon(Icons.heart_broken_sharp),
//     trailing: TextButton( // 항목의 오른쪽에 위치한 버튼
//       child: Text('상세   >'), // 버튼 텍스트
//       onPressed: () {
//         // 버튼 눌렀을때 보고서 화면이동!
//       },
//     ),
//   ),
// ),
