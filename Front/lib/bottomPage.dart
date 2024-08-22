import 'package:flutter/material.dart';
import 'package:front/recordPage/recordPage.dart';
import 'package:front/setting/setting2.dart';

import 'dart2Page.dart';
import 'dashPage.dart'; //되는거
// import 'dashPage.dart'; //안되는거



class BottomPage extends StatefulWidget {
  final int initialIndex;

  // index가 어떤 페이지가 선택될지 결정하므로 초기값을 0으로 설정
  const BottomPage({super.key, this.initialIndex = 0});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex; // 초기 인덱스를 설정
  }

  List<Widget> pageList = [dashPage(), recordPage(), Setting()]; //화면클래스 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0)
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: onItemTap,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: '실시간'),
            BottomNavigationBarItem(icon: Icon(Icons.add_chart), label: '기록'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          backgroundColor: Colors.pink,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          //type: BottomNavigationBarType.shifting,
        ),
      ),
    );
  }

  void onItemTap(int i) {
    setState(() {
      index = i;
    });
  }
}// stf클래스의 범위




// 각각의 버튼 클릭시 띄워질 화면 설계! => 클래스로 생성후 관리!
class Main extends StatelessWidget {
  const Main ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('메인페이지222')),
    );
  }
}



