import 'package:flutter/material.dart';

class dashPage extends StatefulWidget {
  const dashPage({super.key});

  @override
  State<dashPage> createState() => _dashPageState();
}

class _dashPageState extends State<dashPage> {

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
                  Container(
                    child: Text('실시간데이터', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                    ),
                  SizedBox(height: 13,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container( ////////////////////////////////////////////////// 심박수
                        height: 80, width: 150,
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
                              )
                            ]
                          ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('심박수', style: TextStyle(fontSize: 20),),
                                Text('68BPM', style: TextStyle(fontSize: 20),)
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container( /////////////////////////////////////////////////// 산소포화도
                        height: 80, width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7), // 그림자 색상
                                spreadRadius: 0.0, // 그림자가 퍼지는 정도
                                blurRadius: 5, // 그림자의 흐림 정도
                                offset: Offset(0, 10), // 그림자의 위치 (x, y)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('산소포화도', style: TextStyle(fontSize: 20),),
                                Text('98%', style: TextStyle(fontSize: 20),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(//////////////////////////////////////////////////실시간그래프
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ECG", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Container(
                          alignment: Alignment.center,
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                          ),
                          child: Text("성훈이가만든 실시간 ECG그래프"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12, height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text("심장 리듬이 안정적입니다. 현재 상태는 정상입니다", style: TextStyle(color: Colors.green, fontSize: 15),),
                        //Text("심장 리듬에 이상이 감지되었습니다", style: TextStyle(color: Colors.red, fontSize: 16),)
                      ],
                    )
                  ),
                  SizedBox(height: 80,),
                  Center(
                    child: ElevatedButton( ////////////////////////////////////버튼 start -> Pause
                      onPressed: (){},
                        child: Text("start", style: TextStyle(fontSize: 20),),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200,50),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey)
                          )
                        ),),
                  )

                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
