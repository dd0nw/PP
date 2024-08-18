import 'package:flutter/material.dart';

class AppNoti extends StatefulWidget {
  const AppNoti({super.key});

  @override
  State<AppNoti> createState() => _AppNotiState();
}

class _AppNotiState extends State<AppNoti> {
  bool _isSwitched1 = false; // 첫 번째 스위치의 상태를 저장할 변수
  bool _isSwitched2 = false; // 두 번째 스위치의 상태를 저장할 변수
  bool _isExpanded1 = false; // 첫 번째 드롭다운의 확장 상태
  bool _isSwitched3 = false; // 세 번째 스위치의 상태를 저장할 변수
  bool _isExpanded2 = false; // 두 번째 드롭다운의 확장 상태
  bool _isExpanded3 = false; // 세 번째 드롭다운의 확장 상태
  bool _isExpanded4 = false; // 네 번째 드롭다운의 확장 상태
  bool _isSwitched4 = false; // 네 번째 스위치의 상태를 저장할 변수
  bool _isSwitched5 = false; // 다섯 번째 스위치의 상태를 저장할 변수
  bool _isSwitched6 = false;

  void _toggleExpansion1() {
    setState(() {
      _isExpanded1 = !_isExpanded1;
    });
  }

  void _toggleExpansion2() {
    setState(() {
      _isExpanded2 = !_isExpanded2;
    });
  }

  void _toggleExpansion3() {
    setState(() {
      _isExpanded3 = !_isExpanded3;
    });
  }

  void _toggleExpansion4() {
    setState(() {
      _isExpanded4 = !_isExpanded4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF6F6),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 34,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '알림 설정',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFFFF6F6),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),

            // 첫 번째 텍스트 박스와 스위치
            Container(
              width: 325,
              height: 81,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border.all(color: Color(0xFFC1C1C1)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '센서알림',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '센서 상태 알림',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 31.0,
                    child: Switch(
                      value: _isSwitched1,
                      onChanged: (bool value) {
                        setState(() {
                          _isSwitched1 = value;
                        });
                      },
                      activeColor: Color(0xFFFF6B6B),
                      inactiveTrackColor: Color(0xFFC1C1C1),
                      inactiveThumbColor: Color(0xFFFFFFFF),
                      thumbColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      trackColor: MaterialStateProperty.all<Color>(Color(0xFFC1C1C1)),
                      overlayColor: MaterialStateProperty.all<Color>(Color(0xFF000000).withOpacity(0.1)),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 심박수 알림이 하나의 텍스트 박스 안에 포함됨
            Container(
              width: 325,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border.all(color: Color(0xFFC1C1C1)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      '심박수 알림',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 10.0),

                    // 첫 번째 드롭다운: 매우 높음
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '매우 높음',
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '85 bpm 초과',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: _toggleExpansion1,
                                    child: Icon(
                                      _isExpanded1
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF000000),
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isSwitched2,
                          onChanged: (bool value) {
                            setState(() {
                              _isSwitched2 = value;
                            });
                          },
                          activeColor: Color(0xFFFF6B6B),
                          inactiveTrackColor: Color(0xFFC1C1C1),
                          inactiveThumbColor: Color(0xFFFFFFFF),
                          thumbColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                          trackColor: MaterialStateProperty.all<Color>(Color(0xFFC1C1C1)),
                          overlayColor: MaterialStateProperty.all<Color>(Color(0xFF000000).withOpacity(0.1)),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _isExpanded1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '여기에 세부 내용을 추가하세요.',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ),

                    // 두 번째 드롭다운: 높음
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '높음',
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '85 bpm 초과',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: _toggleExpansion2,
                                    child: Icon(
                                      _isExpanded2
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF000000),
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Switch(
                          value: _isSwitched3,
                          onChanged: (bool value) {
                            setState(() {
                              _isSwitched3 = value;
                            });
                          },
                          activeColor: Color(0xFFFF6B6B),
                          inactiveTrackColor: Color(0xFFC1C1C1),
                          inactiveThumbColor: Color(0xFFFFFFFF),
                          thumbColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                          trackColor: MaterialStateProperty.all<Color>(Color(0xFFC1C1C1)),
                          overlayColor: MaterialStateProperty.all<Color>(Color(0xFF000000).withOpacity(0.1)),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _isExpanded2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '여기에 세부 내용을 추가하세요.',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ),

                    // 세 번째 드롭다운: 낮음
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '낮음',
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '85 bpm 미만',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: _toggleExpansion3,
                                    child: Icon(
                                      _isExpanded3
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF000000),
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isSwitched4,
                          onChanged: (bool value) {
                            setState(() {
                              _isSwitched4 = value;
                            });
                          },
                          activeColor: Color(0xFFFF6B6B),
                          inactiveTrackColor: Color(0xFFC1C1C1),
                          inactiveThumbColor: Color(0xFFFFFFFF),
                          thumbColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                          trackColor: MaterialStateProperty.all<Color>(Color(0xFFC1C1C1)),
                          overlayColor: MaterialStateProperty.all<Color>(Color(0xFF000000).withOpacity(0.1)),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _isExpanded3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '여기에 세부 내용을 추가하세요.',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ),

                    // 네 번째 드롭다운: 매우 낮음
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '매우 낮음',
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '85 bpm 미만',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: _toggleExpansion4,
                                    child: Icon(
                                      _isExpanded4
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF000000),
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isSwitched5,
                          onChanged: (bool value) {
                            setState(() {
                              _isSwitched5 = value;
                            });
                          },
                          activeColor: Color(0xFFFF6B6B),
                          inactiveTrackColor: Color(0xFFC1C1C1),
                          inactiveThumbColor: Color(0xFFFFFFFF),
                          thumbColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                          trackColor: MaterialStateProperty.all<Color>(Color(0xFFC1C1C1)),
                          overlayColor: MaterialStateProperty.all<Color>(Color(0xFF000000).withOpacity(0.1)),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _isExpanded4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '여기에 세부 내용을 추가하세요.',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),



            SizedBox(height: 20),
            Container(
              width: 325,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border.all(color: Color(0xFFC1C1C1)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '부정맥 알림',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 7.0,
                    child: Switch(
                      value: _isSwitched6,
                      onChanged: (bool value) {
                        setState(() {
                          _isSwitched6 = value;
                        });
                      },
                      activeColor: Color(0xFFFF6B6B),
                      inactiveTrackColor: Color(0xFFC1C1C1),
                      inactiveThumbColor: Color(0xFFFFFFFF),
                      thumbColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      trackColor: MaterialStateProperty.all<Color>(Color(0xFFC1C1C1)),
                      overlayColor: MaterialStateProperty.all<Color>(Color(0xFF000000).withOpacity(0.1)),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
