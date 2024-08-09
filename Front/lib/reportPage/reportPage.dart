import 'package:flutter/material.dart';
// import 'api_service.dart'; // ApiService가 정의된 파일을 import
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../memo2page/memo2.dart';
import '../memo2page/memo2Page.dart';
import 'report_service.dart';


class reportPage extends StatefulWidget {
  final Map<String, dynamic>? analysisResult;

  const reportPage({super.key, this.analysisResult});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<reportPage> {
  final MemoService _memoService = MemoService();
  final TextEditingController memoCon = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  //  메모
  Future<void> _loadMemos() async {
    try {
      List<Memo> memos = await _memoService.fetchMemos();
      if (memos.isNotEmpty) {
        memoCon.text = memos.first.content; // 첫 번째 메모 내용을 TextField에 로드
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load memos: $e';
      });
    }
  }

  // 메모 저장버튼누르면 DB에 저장
  Future<void> _saveMemo() async {
    Memo newMemo = Memo(content: memoCon.text);
    try {
      await _memoService.createMemo(newMemo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Memo saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save memo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼 눌렀을 때 이전 화면으로 돌아가기
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: isLoading
                    ? Center(child: CircularProgressIndicator()) // 로딩 중일 때
                    : errorMessage != null
                    ? Center(child: Text('Error: $errorMessage')) // 오류 발생 시
                    : Column(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.analysisResult?['CREATED_AT'] ?? '날짜 정보 없음', //날짜+시간
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                          ),
                          Row(
                            children: [
                              Text(widget.analysisResult?['ANALISYS_RESULT'] ?? '날짜 정보 없음', // 부정맥종류
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                              IconButton(
                                onPressed: () {// 심방세동 종류에 대한 상세 페이지로 이동할 수 있는 기능 추가하기!!
                                },
                                icon: Icon(Icons.info_outline, size: 23, color: Colors.red[800],
                                ),
                              ),
                            ],
                          ),
                          Image.asset('img/AF.png', width: double.infinity,), // 그래프 띄우기
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("분석결과",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),
                      ),
                    ),
                    SizedBox(height: 5),
                    widget.analysisResult != null
                        ? Column(
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.analysisResult?['ANALISYS_RESULT'] ?? '날짜 정보 없음'} (20%)', // 부정맥종류
                                  // "심방세동(${analysisResult!['BG_AVG']}%)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "심방세동에 대한 설명",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 360,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.auto_graph,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      "심전도",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                                "PR interval ${widget.analysisResult?['PR']}ms"),
                                            SizedBox(width: 10),
                                            Text(
                                                "QTC interval ${widget.analysisResult!['RR']}ms"),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                                "QT interval ${widget.analysisResult!['QT']}ms"),
                                            SizedBox(width: 10),
                                            Text(
                                                "QRS interval ${widget.analysisResult!['QRS']}ms"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(0),
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.black12,
                                          width: 1),
                                      bottom: BorderSide(
                                          color: Colors.black12,
                                          width: 1),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      "심박수",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        "${widget.analysisResult!['BG_AVG']} BPM Average"),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight:
                                      Radius.circular(20),
                                      bottomLeft:
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.water_drop,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      "산소포화도",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        "${widget.analysisResult!['ecg']}%"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("메모", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                ElevatedButton(onPressed: _saveMemo, child: Icon(Icons.save),
                                style: ElevatedButton.styleFrom(
                                  iconColor: Colors.black,
                                    backgroundColor: Colors.transparent, // 배경색 투명
                                    elevation: 0, // 그림자 제거
                                    shadowColor: Colors.transparent, // 그림자투명
                                ),)
                              ],
                            ),
                            SizedBox(height: 6,),
                            Container(
                              color: Colors.white,
                              height: 100, // TextField height 설정
                              child: TextField(
                                controller: memoCon,
                                maxLines: null, // 여러 줄 입력 가능
                                expands: true, // 텍스트 필드가 컨테이너 크기에 맞게 확장
                                textAlignVertical: TextAlignVertical.top, // 텍스트를 위쪽에 정렬
                                decoration: InputDecoration(
                                  hintText: "메모를 입력하세요22",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.green)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Text("이 심전도는 심방세동의 징후를 보이고 있습니다",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                  Divider(color: Colors.grey.shade400),
                                  InkWell(
                                    onTap: (){}, // 허ㅣ먄ㅇ;덩
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.download),
                                        Text("분석결과 PDF내보내기",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo),),
                                      ],
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade400),
                                  Text("심장마비나 의료 응급 상황이 발생했다고 판단되면 응급 서비스에 전화하십시오",
                                    style: TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                  Divider(color: Colors.grey.shade400),
                                  InkWell(
                                    onTap: (){},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.search),
                                        Text("가까운 병원 찾아보기",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo),),
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
        
                            )
        
        
                          ],
                        )
        
                      ],
                    )
                        : Center(child: Text('데이터가 없습니다')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
