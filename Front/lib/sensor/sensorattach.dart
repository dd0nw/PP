import 'package:flutter/material.dart';
import 'package:front/ex01_login.dart';

import '../bottomPage.dart';

class Sensorattach extends StatelessWidget {
  const Sensorattach({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black, size: 34.0),
        //   onPressed: () {
        //     Navigator.pop(context);
        //
        //   },
        // ),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("  센서 부착", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            SizedBox(height:0,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" ECG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                      Text("            PPG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('img/sensorattachment2.png', width: 100,height: 260,),
                      Image.asset('img/sensorattachment.png', width: 100,height: 260,),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" 1. 부착할 부위의 피부가 깨끗하고 건조한지 확인해주세요",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        SizedBox(height: 5,),
                        Text(" 2. ECG센서를 정확한 위치에 부착하세요."
                          , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        SizedBox(height: 5,),
                        Text(" (만약 PPG 센서를 사용하려면 손목에 착용하세요.)"
                          , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        SizedBox(height: 5,),
                        Text(" 3. 검사가 진행되는 동안 과도한 움직임은 피하세요. "
                          , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        SizedBox(height: 5,),
                        Text(" 4. 검사 중 불편감이 느껴지면 즉시 센서를 제거하고 검사를 중지하세요."
                          , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        SizedBox(height: 7,),
                        Text(" 필요한 경우 의료 전문가에게 상담하십시오"
                          , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        SizedBox(height: 70,),
                        Center(
                          child: ElevatedButton(onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => BottomPage()),
                            );
                          }
                            , child: Text("다음", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              fixedSize: Size(284, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

        ),
      ),
    );;
  }
}
