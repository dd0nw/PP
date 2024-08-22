import 'package:flutter/material.dart';

import '../bottomPage.dart';

class Sensorinfo extends StatelessWidget {
  const Sensorinfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 34.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("  센서 연결 전 주의사항", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            SizedBox(height: 15,),
            //Icon(Icons.notification_important_outlined),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('img/lloudspeaker.png', width: 100,height: 100,),
                  Text("- 심전도상의 경미한 이상이 모두 이상소견인 것은 아닙니다", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Text("- 초음파, 24시간 활동형 심전도 등의 정밀 검사가 필요 할 수 있습니다", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Text("- 부정맥이 의심되나 진단되지 않는 경우 24시간동안 활동성 심전도 검사가 필요합니다22", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(height: 200,),
                  ElevatedButton(onPressed: (){}, child: Text("다음"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      fixedSize: Size(284, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
