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
                            width: 360, height: 270,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("img/F.png", width: 300,),
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Text("우심실로 전도되는 신호가 지연되어 발생하는 심전도 패턴입니다. 추가 검사 없이 지켜보면 됩니다. ",
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
                            width: 360, height: 310,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("img/S.png", width: 300,),
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Text("좌심실로 전도되는 신호가 지연되어 발생하는 심전도 패턴입니다. 고혈압이나 관상동맥질환, 심장판막질환 등 동반된 심장질환이 있는지 확인하기 위해 심초음파 등 정밀검사를 권합니다.",
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
                            width: 360, height: 290,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                              [
                                Image.asset("img/V.png", width: 300,),
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Text("심실의 정상 수축이 나타나기 전에 심실 수축이 먼저 일어나는 심전도 패턴입니다. 심한 경우 가슴 두근거림, 불안, 어지러움 또는 흉통을 경험할 수 있습니다.",
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
                              width: 360, height: 280,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 0,),
                                  Image.asset("img/Q.png", width: 300,),
                                  Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Text("인공 심박 조율기에 의해 발생하는 박동을 나타냅니다. 심장에 삽입된 인공 심박 조율기가 생성하는 신호입니다.",
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
