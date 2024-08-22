// 부정맥 종류 페이지
import 'package:flutter/material.dart';

class cardiainfoPage extends StatelessWidget {
  const cardiainfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 34.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFFFF8F9),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("  부정맥 종류", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                SizedBox(height: 15,),
                Container(
                    child: Column(
                      children: [
                        Text(" 1. 우각차단 - RBBB(Right bundle branch block)",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.pink),),
                        SizedBox(height: 5,),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.black12,
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 360, height: 315,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("img/F.png", width: 300,),
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Text("심장의 우측 전기 신호 전달 경로가 차단되어 심실의 수축이 지연되는 상태를 말합니다. 일반적으로 큰 위험을 초래하지 않지만, 다른 심장 질환과 연관될 수 있으므로 주의가 필요합니다. ",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(height: 15,),
                Container(
                    child: Column(
                      children: [
                        Text(" 2. 좌각차단 - LBBB(Left bundle branch block)",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.pink),),
                        SizedBox(height: 5,),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.black12,
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 360, height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("img/S.png", width: 300,),
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Text("심장의 좌측 전기 신호 전달 경로가 차단되어 심실의 수축이 지연되는 상태입니다. 심장 질환의 징후일 수 있으며, 특히 심근경색과 같은 심각한 상태와 관련이 있을 수 있습니다.",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(height: 15,),
                Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("3. 심실조기수축 - Ventricular ectopic beats and ventricular premature contraction)",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.pink),),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.black12,
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 360, height: 315,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                              [
                                Image.asset("img/V.png", width: 300,),
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Text("심실에서 정상적인 심장박동보다 빨리 발생하는 추가적인 수축을 의미합니다. 이로 인해 가슴이 두근거리거나 불규칙한 박동을 느낄 수 있습니다. 반복적으로 발생하거나 증상이 심할 경우 추가 검사가 필요할 수 있습니다.",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" 4. 인공 심박 조율기 박동 - Paced beat",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.pink),),
                          SizedBox(height: 5,),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black12,
                                    width: 1
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 360, height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 0,),
                                  Image.asset("img/Q.png", width: 300,),
                                  Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Text("심장이 규칙적으로 뛰도록 전기 신호를 보내는 기기입니다. 심전도에서 인공 심박 조율기의 전기 자극에 의해 발생하는 특이한 패턴이 나타납니다.",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                  ),
                                  // SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ),










          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
