import 'package:flutter/material.dart';
import 'package:front/recordPage/recordPage.dart';
import 'package:front/setting2.dart';
import 'dart2Page.dart';
import 'dashPage.dart';


class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {

  int index = 0; // 화면을 관리 인덱스
  List<Widget> pageList = [dashPage(), recordPage(), setting()]; //화면클래스 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index, // 몇번째화면을 선택했는지 체크
        onTap: onItemTap,  // 여러개의 화면과 bottom버튼 연결
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: '실시간'),
          BottomNavigationBarItem(icon: Icon(Icons.add_chart), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],

        // 라벨에 대한 스타일 지정!
        showSelectedLabels: true, // 선택된 아이템의 라벨(텍스트)을 표시하지 않습니다.
        showUnselectedLabels: true, // 선택되지 않은 아이템의 라벨(텍스트)을 표시하지 않습니다.

        // bottom 영역 스타일 지정
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void onItemTap(int i){
    setState((){
      index = i;
    });
  }

} // stf클래스의 범위




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

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('보고서화면22')),
    );
  }
}

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('설정화면222')),
    );
  }
}


