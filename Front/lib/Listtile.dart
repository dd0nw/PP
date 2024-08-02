// https://www.youtube.com/watch?app=desktop&v=t7hVCMtnEIw
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [

            /////////////////Card
            Card(
              child: ListTile( // Flutter의 ListTile 위젯 사용
                title: Text('부정맥종류', style: TextStyle(color: Colors.red, fontSize: 19),),
                subtitle: Text('오후 12:45'),
                leading: Icon(Icons.heart_broken_sharp),
                trailing: TextButton( // 항목의 오른쪽에 위치한 버튼
                  child: Text('상세   >'), // 버튼 텍스트
                  onPressed: () {
                    // 버튼 눌렀을때 보고서 화면이동!
                  },
                ),
              ),
            ),

            //////////////Container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.pinkAccent
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
                onTap: (){print('onTap pressed!');},
                onLongPress: (){print('onLong pressed!');},
                iconColor: Colors.white,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
