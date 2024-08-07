import 'package:flutter/material.dart';

import 'api_service.dart'; // ApiService가 정의된 파일을 import
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart'; // 플러터 차트 패키지 사용
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 추가된 부분
import 'package:path_provider/path_provider.dart'; // 추가된 부분
import 'dart:io'; // 추가된 부분


class reportPage extends StatefulWidget {
  const reportPage({super.key});

  @override
  State<reportPage> createState() => _reportPageState();
}


class _reportPageState extends State<reportPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        leading: Icon(Icons.chevron_left),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.edit),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "2024.08.05 12:22", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        Row(
                          children: [
                            Text(
                              "심방세동 가능성", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                            ),
                            IconButton(
                              onPressed: () {}, // 부정맥 종류 상세 페이지
                              icon: Icon(Icons.info_outline, size: 23, color: Colors.red,),
                            ),
                          ],
                        ),
                        Image.asset('img/AF.png', width: double.infinity,),
                      ],
                    ),
                  ),
                  SizedBox(height: 6,),
                  Container(
                    alignment: Alignment.centerLeft,
                      child: Text("분석결과", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)),
                  SizedBox(height: 5,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: 360,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "심방세동(88%)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.red,
                                  ),
                                ),
                                Text("심방세동에 대한 설명", style: TextStyle(fontSize: 13),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          //color: Colors.red,
                          width: 360,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    //border: Border.all(color: Colors.black12, width: 1),
                                    borderRadius:BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                    )
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.auto_graph, color: Colors.red,),
                                    title: Text("심전도", style: TextStyle(fontWeight: FontWeight.bold),),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("PR interval 178ms"),
                                            SizedBox(width: 10,),
                                            Text("QTC interval 178ms"),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("QT interval 178ms"),
                                            SizedBox(width: 10,),
                                            Text("QRS interval 178ms"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0),
                                    border: Border(
                                      top: BorderSide(color: Colors.black12, width: 1),
                                      bottom: BorderSide(color: Colors.black12, width: 1),
                                    )
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.favorite, color: Colors.red,),
                                    title: Text("심박수22", style: TextStyle(fontWeight: FontWeight.bold),),
                                    subtitle: Text("88 BPM Average")
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: ListTile(
                                      leading: Icon(Icons.water_drop, color: Colors.blue,),
                                      title: Text("산소포화도", style: TextStyle(fontWeight: FontWeight.bold),),
                                      subtitle: Text("88%")
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text("메모", style: TextStyle(fontSize:17, fontWeight: FontWeight.bold),),
                        ListTile(
                          leading: Icon(Icons.article_outlined),
                          title: Text("메모"),
                          subtitle: Text("메모내용"),
                        ),


                      ],
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


// Container(
//   height: 130,
//   width: 340,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(color: Colors.black12),
//     borderRadius: BorderRadius.only(
//       topRight: Radius.circular(20),
//       topLeft: Radius.circular(20),
//     ),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(Icons.auto_graph, color: Colors.red,),
//         SizedBox(width: 10,),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("심전도", style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
//             Text("PR interval 178ms"),
//             Text("PR interval 178ms"),
//             Text("PR interval 178ms"),
//             Text("PR interval 178ms"),
//           ],
//         ),
//       ],
//     ),
//   ),
// ),
// Container(
//   height: 61, width: 340,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(color: Colors.black12),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(Icons.favorite, color: Colors.red,),
//         SizedBox(width: 10,),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("심박수", style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
//             Text("88 BPM Average")
//           ],
//         ),
//       ],
//     ),
//   ),
// ),
// Container(
//   height: 61, width: 340,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(color: Colors.black12),
//     borderRadius: BorderRadius.only(
//       bottomRight: Radius.circular(20),
//       bottomLeft: Radius.circular(20),
//     ),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(Icons.water_drop, color: Colors.blue,),
//         SizedBox(width: 10,),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("산소포화도", style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
//             Text("88 %")
//           ],
//         ),
//       ],
//     ),
//   ),
// ),

